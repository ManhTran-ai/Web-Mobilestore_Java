package com.mobilestore.service;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;

import java.io.InputStream;
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
                mailConfig.load(is);
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
            msg.setFrom(new InternetAddress(from, "Mobile Store"));
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
}
