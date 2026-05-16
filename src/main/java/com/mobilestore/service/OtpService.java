package com.mobilestore.service;

import com.mobilestore.dao.OtpTokenDAO;
import com.mobilestore.model.OtpToken;
import com.mobilestore.util.EmailConfig;

import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;

public class OtpService {

    private static final ZoneId VN_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRE_MINUTES;
    private static final int OTP_MAX_ATTEMPTS;

    private static final SecureRandom secureRandom = new SecureRandom();

    static {
        OTP_EXPIRE_MINUTES = Integer.parseInt(
            EmailConfig.get("otp.expiry.minutes") != null
                ? EmailConfig.get("otp.expiry.minutes")
                : "5"
        );
        OTP_MAX_ATTEMPTS = Integer.parseInt(
            EmailConfig.get("otp.max.attempts") != null
                ? EmailConfig.get("otp.max.attempts")
                : "3"
        );
    }

    private final OtpTokenDAO otpTokenDAO;

    public OtpService() {
        this.otpTokenDAO = new OtpTokenDAO();
    }

    public String generateAndSaveOtp(String email) throws SQLException {
        otpTokenDAO.invalidateAllOtpByEmail(email);

        String otpCode = generateOtpCode();

        LocalDateTime nowVn = LocalDateTime.now(VN_ZONE);
        LocalDateTime expiredAt = nowVn.plusMinutes(OTP_EXPIRE_MINUTES);

        OtpToken token = new OtpToken(email, otpCode, expiredAt);

        System.out.println("[OTP-SEND] email=" + email + ", otp=" + otpCode + ", expiredAt=" + expiredAt);
        otpTokenDAO.insertOtp(token);
        return otpCode;
    }

    public boolean validateOtp(String email, String inputOtp) throws SQLException {
        OtpToken token = otpTokenDAO.getLatestValidOtp(email);

        if (token == null) {
            System.out.println("[OTP-VERIFY] Khong tim thay OTP hop le cho email: " + email);
            return false;
        }

        System.out.println("[OTP-VERIFY] Token tim thay - db_otp='" + token.getOtpCode()
            + "', input='" + inputOtp + "', expiredAt=" + token.getExpiredAt()
            + ", now(VN)=" + LocalDateTime.now(VN_ZONE));

        if (!token.getOtpCode().equals(inputOtp)) {
            System.out.println("[OTP-VERIFY] Ma OTP khong khop cho email: " + email);
            otpTokenDAO.incrementAttempt(token.getId());
            return false;
        }

        otpTokenDAO.markAsUsed(token.getId());
        System.out.println("[OTP-VERIFY] Xac thuc thanh cong cho email: " + email);
        return true;
    }

    public boolean isOtpStillValid(String email) throws SQLException {
        return otpTokenDAO.getLatestValidOtp(email) != null;
    }

    public int getMaxAttempts() {
        return OTP_MAX_ATTEMPTS;
    }

    private String generateOtpCode() {
        int otpNumber = secureRandom.nextInt((int) Math.pow(10, OTP_LENGTH));
        return String.format("%0" + OTP_LENGTH + "d", otpNumber);
    }
}
