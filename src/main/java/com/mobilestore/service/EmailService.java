package com.mobilestore.service;

import com.mobilestore.util.EmailTemplateBuilder;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.io.entity.StringEntity;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class EmailService {

    private static final String BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";
    private static final String FROM_EMAIL = "manht7000@gmail.com";
    private static final String FROM_NAME = "MobileStore";

    public void sendPasswordResetEmail(String toEmail, String username, String resetToken, HttpServletRequest request) {
        String baseUrl = getBaseUrl(request);
        String resetLink = baseUrl + "/reset-password?token=" + resetToken;
        String htmlContent = EmailTemplateBuilder.buildPasswordResetEmail(username, resetLink);
        sendEmail(toEmail, "[MobileStore] Dat lai mat khau", htmlContent);
    }

    public void sendOtpEmail(String toEmail, String otpCode) {
        sendOtpEmail(toEmail, otpCode, "registration");
    }

    public void sendOtpEmail(String toEmail, String otpCode, String type) {
        String htmlContent = EmailTemplateBuilder.buildOtpEmail(otpCode, type);
        String subject = "registration".equals(type)
                ? "[MobileStore] Ma xac nhan dang ky tai khoan"
                : "[MobileStore] Ma xac nhan dang nhap";
        sendEmail(toEmail, subject, htmlContent);
    }

    public void sendOrderStatusEmail(String toEmail, String orderId, String status,
                                     String customerName, String totalAmount,
                                     String shippingAddress, String paymentMethod,
                                     String cancelReason, String trackingNumber) {
        String statusLabel = mapStatusLabel(status);
        String htmlContent = EmailTemplateBuilder.buildOrderStatusEmail(
                orderId, status, statusLabel, customerName,
                totalAmount, shippingAddress, paymentMethod,
                cancelReason, trackingNumber);
        String subject = "[MobileStore] Cập nhật trạng thái đơn hàng #" + orderId;
        sendEmail(toEmail, subject, htmlContent);
    }

    private String mapStatusLabel(String status) {
        switch (status) {
            case "PENDING":    return "Chờ xác nhận";
            case "PROCESSING": return "Đã xác nhận";
            case "SHIPPED":    return "Đang giao hàng";
            case "DELIVERED":  return "Đã giao hàng";
            case "CANCELLED":  return "Đã hủy";
            default:           return status;
        }
    }

    public String generateResetToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    private void sendEmail(String toEmail, String subject, String htmlContent) {
        System.out.println("[EMAIL-SERVICE] ==============================");
        System.out.println("[EMAIL-SERVICE] Sending email via Brevo API");
        System.out.println("[EMAIL-SERVICE] To     : " + toEmail);
        System.out.println("[EMAIL-SERVICE] Subject: " + subject);

        String apiKey = getApiKey();
        if (apiKey == null || apiKey.isBlank()) {
            logDemoEmail(toEmail, subject, htmlContent);
            return;
        }

        String jsonPayload = buildBrevoPayload(toEmail, subject, htmlContent);

        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost request = new HttpPost(BREVO_API_URL);
            request.setHeader("api-key", apiKey);
            request.setEntity(new StringEntity(jsonPayload,
                ContentType.create("application/json", StandardCharsets.UTF_8)));

            System.out.println("[EMAIL-SERVICE] Sending request to Brevo...");
            try (CloseableHttpResponse response = client.execute(request)) {
                int statusCode = response.getCode();
                String responseBody = response.getEntity() != null
                        ? EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8)
                        : null;

                if (statusCode == 201 || statusCode == 200) {
                    System.out.println("[EMAIL-SERVICE] RESULT   : SUCCESS (HTTP " + statusCode + ")");
                } else {
                    System.out.println("[EMAIL-SERVICE] RESULT   : FAILED (HTTP " + statusCode + ")");
                    if (responseBody != null && !responseBody.isBlank()) {
                        System.out.println("[EMAIL-SERVICE] Response : " + responseBody);
                    }
                }
            }
        } catch (IOException | ParseException e) {
            System.err.println("[EMAIL-SERVICE] EXCEPTION: " + e.getMessage());
            logDemoEmail(toEmail, subject, htmlContent);
        } finally {
            System.out.println("[EMAIL-SERVICE] ==============================");
        }
    }

    private String buildBrevoPayload(String toEmail, String subject, String htmlContent) {
        com.google.gson.JsonObject payload = new com.google.gson.JsonObject();
        com.google.gson.JsonObject sender = new com.google.gson.JsonObject();
        sender.addProperty("name", FROM_NAME);
        sender.addProperty("email", FROM_EMAIL);
        payload.add("sender", sender);

        com.google.gson.JsonArray to = new com.google.gson.JsonArray();
        com.google.gson.JsonObject toObj = new com.google.gson.JsonObject();
        toObj.addProperty("email", toEmail);
        to.add(toObj);
        payload.add("to", to);

        payload.addProperty("subject", subject);
        payload.addProperty("htmlContent", htmlContent);

        return new com.google.gson.Gson().toJson(payload);
    }

    private String getApiKey() {
        String apiKey = System.getenv("BREVO_API_KEY");
        if (apiKey != null && !apiKey.isBlank()) {
            return apiKey;
        }
        String configKey = System.getenv("BREVO_API_KEY_CONFIG");
        if (configKey != null && !configKey.isBlank()) {
            return configKey;
        }
        return null;
    }

    private void logDemoEmail(String toEmail, String subject, String htmlContent) {
        System.out.println("[EMAIL-SERVICE] MODE     : DEMO (no Brevo API key)");
        System.out.println("[EMAIL-SERVICE] Subject  : " + subject);
        System.out.println("[EMAIL-SERVICE] Preview :");
        System.out.println(extractTextPreview(htmlContent));
        System.out.println("[EMAIL-SERVICE] ==============================");
    }

    private String extractTextPreview(String html) {
        if (html == null) return "";
        String text = html.replaceAll("<[^>]+>", " ")
                          .replaceAll("&nbsp;", " ")
                          .replaceAll("&amp;", "&")
                          .replaceAll("\\s+", " ")
                          .trim();
        return text.length() > 300 ? text.substring(0, 300) + "..." : text;
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder base = new StringBuilder();
        base.append(scheme).append("://").append(host);
        if (port != 80 && port != 443) {
            base.append(":").append(port);
        }
        base.append(contextPath);
        return base.toString();
    }
}
