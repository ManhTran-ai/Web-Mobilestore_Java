package com.mobilestore.service;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.UUID;

public class EmailService {

    private static final String BASE_URL = "http://localhost:8080/mobilestore";
    private final Properties mailConfig = new Properties();
    private final boolean smtpEnabled;

    public EmailService() {
        boolean enabled = false;
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("mail.properties")) {
            if (is != null) {
                mailConfig.load(new InputStreamReader(is, StandardCharsets.UTF_8));
                enabled = "true".equalsIgnoreCase(mailConfig.getProperty("smtp.enabled", "false"));
            }
        } catch (Exception e) {
            System.err.println("EmailService: Không đọc được mail.properties, dùng chế độ demo. " + e.getMessage());
        }
        this.smtpEnabled = enabled;
    }

    public void sendPasswordResetEmail(String email, String username, String resetToken, ServletContext context) {
        String resetLink = BASE_URL + "/reset-password?token=" + resetToken;
        String emailContent = buildEmailContent(username, resetLink);

        if (smtpEnabled && sendViaSmtp(email, "[Mobile Store] Đặt lại mật khẩu", emailContent)) {
            return;
        }

        System.out.println("========================================");
        System.out.println("PASSWORD RESET EMAIL (DEMO - NO SMTP CONFIGURED)");
        System.out.println("========================================");
        System.out.println("To: " + email);
        System.out.println("Subject: [Mobile Store] Reset Your Password");
        System.out.println("");
        System.out.println(emailContent);
        System.out.println("========================================");
        System.out.println("Reset Link: " + resetLink);
        System.out.println("========================================");
    }

    private boolean sendViaSmtp(String toEmail, String subject, String textContent) {
        String host = mailConfig.getProperty("smtp.host");
        String port = mailConfig.getProperty("smtp.port", "587");
        String user = mailConfig.getProperty("smtp.username");
        String password = mailConfig.getProperty("smtp.password");
        String from = mailConfig.getProperty("smtp.from", user);
        if (host == null || host.isEmpty() || user == null || user.isEmpty() || password == null || password.isEmpty()) {
            System.err.println("EmailService: Thiếu cấu hình SMTP (host, username, password). Không gửi mail.");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", mailConfig.getProperty("smtp.auth", "true"));
        props.put("mail.smtp.starttls.enable", mailConfig.getProperty("smtp.starttls.enable", "true"));
        props.put("mail.smtp.ssl.trust", host);

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "MobileStore", "UTF-8"));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            msg.setSubject(subject, "UTF-8");
            msg.setText(textContent, "UTF-8");
            Transport.send(msg);
            return true;
        } catch (MessagingException e) {
            System.err.println("EmailService: Gửi mail thất bại: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("EmailService: Lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private String buildEmailContent(String username, String resetLink) {
        StringBuilder sb = new StringBuilder();
        sb.append("Xin chào ").append(username).append(",\n\n");
        sb.append("Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.\n\n");
        sb.append("Nhấp vào liên kết dưới đây để đặt lại mật khẩu:\n\n");
        sb.append(resetLink).append("\n\n");
        sb.append("Liên kết này sẽ hết hạn sau 30 phút.\n\n");
        sb.append("Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.\n\n");
        sb.append("Trân trọng,\n");
        sb.append("Mobile Store Team");
        return sb.toString();
    }

    public String generateResetToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    public void sendOtpEmail(String toEmail, String otpCode) throws MessagingException, UnsupportedEncodingException {
        Properties smtpProps = new Properties();
        smtpProps.put("mail.smtp.host", mailConfig.getProperty("smtp.host"));
        smtpProps.put("mail.smtp.port", mailConfig.getProperty("smtp.port", "587"));
        smtpProps.put("mail.smtp.auth", mailConfig.getProperty("smtp.auth", "true"));
        smtpProps.put("mail.smtp.starttls.enable", mailConfig.getProperty("smtp.starttls.enable", "true"));
        smtpProps.put("mail.smtp.ssl.trust", mailConfig.getProperty("smtp.ssl.trust", mailConfig.getProperty("smtp.host")));

        String username = mailConfig.getProperty("smtp.username");
        String password = mailConfig.getProperty("smtp.password");
        String senderName = mailConfig.getProperty("smtp.from", username);

        Session session = Session.getInstance(smtpProps, new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(username, password);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(senderName, "MobileStore", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(mailConfig.getProperty("otp.email.subject", "[MobileStore] Mã xác nhận đăng nhập của bạn"), "UTF-8");
        message.setContent(buildOtpHtmlBody(otpCode), "text/html; charset=UTF-8");
        Transport.send(message);
    }

    private String buildOtpHtmlBody(String otpCode) {
        StringBuilder html = new StringBuilder();
        html.append("<div style=\"font-family: Arial, sans-serif; max-width: 480px; margin: auto; border: 1px solid #e0e0e0; border-radius: 8px; padding: 32px;\">");
        html.append("<h2 style=\"color: #1a1a2e;\">Mã Xác Nhận Đăng Nhập</h2>");
        html.append("<p>Xin chào,</p>");
        html.append("<p>Mã OTP của bạn là:</p>");
        html.append("<div style=\"text-align: center; margin: 24px 0;\">");
        html.append("<span style=\"font-size: 36px; font-weight: bold; letter-spacing: 12px; color: #e94560; background: #f5f5f5; padding: 12px 24px; border-radius: 8px;\">");
        html.append(otpCode);
        html.append("</span></div>");
        html.append("<p style=\"color: #888;\">Mã có hiệu lực trong <strong>5 phút</strong>.</p>");
        html.append("<p style=\"color: #888;\">Nếu bạn không yêu cầu mã này, hãy bỏ qua email này.</p>");
        html.append("<hr style=\"border: none; border-top: 1px solid #eee; margin: 24px 0;\">");
        html.append("<p style=\"color: #aaa; font-size: 12px;\">MobileStore - Email tự động, vui lòng không trả lời.</p>");
        html.append("</div>");
        return html.toString();
    }
}
