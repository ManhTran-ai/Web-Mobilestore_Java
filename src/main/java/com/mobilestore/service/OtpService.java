package com.mobilestore.service;

import com.mobilestore.dao.OtpTokenDAO;
import com.mobilestore.entity.OtpToken;

import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class OtpService {

    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRE_MINUTES = 5;
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final ZoneId GMT7 = ZoneId.of("Asia/Ho_Chi_Minh");

    private final OtpTokenDAO otpTokenDAO;
    private final EmailService emailService;

    public OtpService() {
        this.otpTokenDAO = new OtpTokenDAO();
        this.emailService = new EmailService();
    }

    public OtpService(OtpTokenDAO dao, EmailService emailSvc) {
        this.otpTokenDAO = dao;
        this.emailService = emailSvc;
    }

    public OtpGenerationResult generateAndSaveOtp(String email) {
        LocalDateTime nowGmt7 = LocalDateTime.now(GMT7);
        LocalDateTime expireGmt7 = nowGmt7.plusMinutes(OTP_EXPIRE_MINUTES);

        try {
            if (!otpTokenDAO.canResend(email)) {
                int remaining = otpTokenDAO.getRemainingResendSeconds(email);
                return new OtpGenerationResult(false, null, remaining,
                        "Vui lòng đợi " + remaining + " giây trước khi gửi lại mã.");
            }

            int failedAttempts = otpTokenDAO.getFailedAttemptCount(email);
            if (failedAttempts >= OtpTokenDAO.MAX_ATTEMPTS) {
                return new OtpGenerationResult(false, null, 0,
                        "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng thử lại sau 5 phút.");
            }

            otpTokenDAO.invalidateAllOtpByEmail(email);

            String otpCode = generateOtpCode();
            OtpToken token = new OtpToken(email, otpCode, expireGmt7);
            otpTokenDAO.insertOtp(token);

            System.out.println("[OTP-SERVICE] Generated OTP code: " + otpCode + " for " + email);
            return new OtpGenerationResult(true, otpCode, 0, null);

        } catch (SQLException e) {
            System.err.println("[OTP-SERVICE] DB error during OTP generation: " + e.getMessage());
            e.printStackTrace();
            return new OtpGenerationResult(false, null, 0, "Lỗi hệ thống. Vui lòng thử lại sau.");
        }
    }

    public void sendOtpToEmail(String email, String otpCode) {
        try {
            emailService.sendOtpEmail(email, otpCode);
            System.out.println("[OTP-SERVICE] Email sent successfully to: " + email);
        } catch (Exception e) {
            System.err.println("[OTP-SERVICE] FAILED to send email: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public OtpValidationResult validateOtp(String email, String inputOtp) {
        try {
            OtpToken token = otpTokenDAO.getLatestValidOtp(email);

            if (token == null) {
                int failedAttempts = otpTokenDAO.getFailedAttemptCount(email);
                if (failedAttempts >= OtpTokenDAO.MAX_ATTEMPTS) {
                    return new OtpValidationResult(false,
                            "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng thử lại sau 5 phút.",
                            OtpTokenDAO.MAX_ATTEMPTS - failedAttempts, true);
                }
                return new OtpValidationResult(false,
                        "Mã OTP không tồn tại, đã hết hạn, hoặc đã bị khóa.",
                        -1, false);
            }

            if (!token.getOtpCode().equals(inputOtp)) {
                int newAttempts = token.getAttemptCount() + 1;
                otpTokenDAO.incrementAttempt(token.getId());
                int remaining = OtpTokenDAO.MAX_ATTEMPTS - newAttempts;
                if (remaining <= 0) {
                    return new OtpValidationResult(false,
                            "Bạn đã nhập sai mã OTP quá nhiều lần. Vui lòng thử lại sau 5 phút.",
                            0, true);
                }
                return new OtpValidationResult(false,
                        "Mã OTP không đúng. Bạn còn " + remaining + " lần thử.",
                        remaining, false);
            }

            otpTokenDAO.markAsUsed(token.getId());
            System.out.println("[OTP-SERVICE] OTP validated successfully for: " + email);
            return new OtpValidationResult(true, null, OtpTokenDAO.MAX_ATTEMPTS, false);

        } catch (SQLException e) {
            System.err.println("[OTP-SERVICE] DB error during OTP validation: " + e.getMessage());
            e.printStackTrace();
            return new OtpValidationResult(false, "Lỗi hệ thống khi xác thực mã OTP.", -1, false);
        }
    }

    public boolean isOtpStillValid(String email) {
        try {
            return otpTokenDAO.getLatestValidOtp(email) != null;
        } catch (SQLException e) {
            return false;
        }
    }

    private String generateOtpCode() {
        int otpNumber = secureRandom.nextInt((int) Math.pow(10, OTP_LENGTH));
        return String.format("%0" + OTP_LENGTH + "d", otpNumber);
    }

    public static class OtpGenerationResult {
        public final boolean success;
        public final String otpCode;
        public final int remainingSeconds;
        public final String errorMessage;

        public OtpGenerationResult(boolean success, String otpCode, int remainingSeconds, String errorMessage) {
            this.success = success;
            this.otpCode = otpCode;
            this.remainingSeconds = remainingSeconds;
            this.errorMessage = errorMessage;
        }
    }

    public static class OtpValidationResult {
        public final boolean success;
        public final String errorMessage;
        public final int remainingAttempts;
        public final boolean locked;

        public OtpValidationResult(boolean success, String errorMessage, int remainingAttempts, boolean locked) {
            this.success = success;
            this.errorMessage = errorMessage;
            this.remainingAttempts = remainingAttempts;
            this.locked = locked;
        }
    }
}
