package com.mobilestore.service;

import com.mobilestore.dao.OtpTokenDAO;
import com.mobilestore.entity.OtpToken;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.security.SecureRandom;
import java.time.LocalDateTime;

public class OtpService {

    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRE_MINUTES = 5;
    private static final SecureRandom secureRandom = new SecureRandom();

    private final OtpTokenDAO otpTokenDAO;
    private final EmailService emailService;

    public OtpService() {
        this.otpTokenDAO = new OtpTokenDAO();
        this.emailService = new EmailService();
    }

    public String generateAndSaveOtp(String email) throws SQLException {
        System.out.println("[OTP-SERVICE] === GENERATE OTP ===");
        System.out.println("[OTP-SERVICE] Email: " + email);
        System.out.println("[OTP-SERVICE] Current server time (GMT+7): " + LocalDateTime.now());
        System.out.println("[OTP-SERVICE] Expires at (GMT+7): " + LocalDateTime.now().plusMinutes(OTP_EXPIRE_MINUTES));

        otpTokenDAO.invalidateAllOtpByEmail(email);

        String otpCode = generateOtpCode();
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(OTP_EXPIRE_MINUTES);
        OtpToken token = new OtpToken(email, otpCode, expiredAt);

        otpTokenDAO.insertOtp(token);

        System.out.println("[OTP-SERVICE] OTP saved to DB: code=" + otpCode + ", expiredAt=" + expiredAt);
        System.out.println("[OTP-SERVICE] ===================");
        return otpCode;
    }

    public void sendOtpToEmail(String email, String otpCode) throws Exception {
        emailService.sendOtpEmail(email, otpCode);
    }

    public boolean validateOtp(String email, String inputOtp) throws SQLException {
        System.out.println("[OTP-SERVICE] === VALIDATE OTP ===");
        System.out.println("[OTP-SERVICE] Email: " + email);
        System.out.println("[OTP-SERVICE] Input OTP: " + inputOtp);
        System.out.println("[OTP-SERVICE] Current DB time: " + getDbTime());

        OtpToken token = otpTokenDAO.getLatestValidOtp(email);

        if (token == null) {
            System.out.println("[OTP-SERVICE] RESULT: No valid OTP found in DB (null)");
            System.out.println("[OTP-SERVICE] Possible reasons:");
            System.out.println("[OTP-SERVICE]   - No OTP exists for this email");
            System.out.println("[OTP-SERVICE]   - OTP is expired (expired_at <= NOW())");
            System.out.println("[OTP-SERVICE]   - OTP was already used (is_used = 1)");
            System.out.println("[OTP-SERVICE]   - Too many failed attempts (attempt_count >= 3)");
            System.out.println("[OTP-SERVICE] ===================");
            return false;
        }

        System.out.println("[OTP-SERVICE] DB OTP found: code=" + token.getOtpCode()
            + ", expiredAt=" + token.getExpiredAt()
            + ", isUsed=" + token.isUsed()
            + ", attempts=" + token.getAttemptCount()
            + ", createdAt=" + token.getCreatedAt());

        if (!token.getOtpCode().equals(inputOtp)) {
            System.out.println("[OTP-SERVICE] RESULT: Code mismatch! DB=" + token.getOtpCode() + " vs Input=" + inputOtp);
            otpTokenDAO.incrementAttempt(token.getId());
            System.out.println("[OTP-SERVICE] Incremented attempt count for OTP id=" + token.getId());
            System.out.println("[OTP-SERVICE] ===================");
            return false;
        }

        System.out.println("[OTP-SERVICE] RESULT: Code matched! Marking OTP as used.");
        otpTokenDAO.markAsUsed(token.getId());
        System.out.println("[OTP-SERVICE] ===================");
        return true;
    }

    private String getDbTime() {
        try (Connection conn = DatabaseConnection.getConnection();
             var stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT NOW() as now")) {
            if (rs.next()) {
                return rs.getTimestamp("now").toLocalDateTime().toString();
            }
        } catch (Exception e) {
            return "UNAVAILABLE: " + e.getMessage();
        }
        return "UNKNOWN";
    }

    public boolean isOtpStillValid(String email) throws SQLException {
        return otpTokenDAO.getLatestValidOtp(email) != null;
    }

    private String generateOtpCode() {
        int otpNumber = secureRandom.nextInt((int) Math.pow(10, OTP_LENGTH));
        return String.format("%0" + OTP_LENGTH + "d", otpNumber);
    }
}
