package com.mobilestore.dao;

import com.mobilestore.entity.OtpToken;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;

public class OtpTokenDAO {

    public static final int MAX_ATTEMPTS = 5;
    public static final int RESEND_COOLDOWN_SECONDS = 60;
    public static final int OTP_EXPIRE_MINUTES = 5;

    public void insertOtp(OtpToken token) throws SQLException {
        String sql = "INSERT INTO otp_tokens (email, otp_code, expired_at) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token.getEmail());
            ps.setString(2, token.getOtpCode());
            ps.setTimestamp(3, Timestamp.valueOf(token.getExpiredAt()));
            ps.executeUpdate();
        }
    }

    public OtpToken getLatestValidOtp(String email) throws SQLException {
        String sql = """
            SELECT * FROM otp_tokens
            WHERE email = ?
              AND is_used = 0
              AND expired_at > NOW()
              AND attempt_count < ?
            ORDER BY created_at DESC
            LIMIT 1
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, MAX_ATTEMPTS);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        }
    }

    public boolean canResend(String email) throws SQLException {
        String sql = """
            SELECT COUNT(*) as cnt FROM otp_tokens
            WHERE email = ?
              AND is_used = 0
              AND expired_at > NOW()
              AND attempt_count < ?
              AND created_at > DATE_SUB(NOW(), INTERVAL ? SECOND)
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, MAX_ATTEMPTS);
            ps.setInt(3, RESEND_COOLDOWN_SECONDS);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt") == 0;
            }
            return true;
        }
    }

    public int getRemainingResendSeconds(String email) throws SQLException {
        String sql = """
            SELECT TIMESTAMPDIFF(SECOND, NOW(),
                DATE_ADD(
                    (SELECT created_at FROM otp_tokens
                     WHERE email = ? AND is_used = 0 AND expired_at > NOW() AND attempt_count < ?
                     ORDER BY created_at DESC LIMIT 1),
                    INTERVAL ? SECOND
                )
            ) as remaining
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, MAX_ATTEMPTS);
            ps.setInt(3, RESEND_COOLDOWN_SECONDS);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int remaining = rs.getInt("remaining");
                return Math.max(0, remaining);
            }
            return 0;
        }
    }

    public int getFailedAttemptCount(String email) throws SQLException {
        String sql = """
            SELECT attempt_count FROM otp_tokens
            WHERE email = ?
              AND is_used = 0
              AND expired_at > NOW()
            ORDER BY created_at DESC
            LIMIT 1
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("attempt_count");
            }
            return 0;
        }
    }

    public void markAsUsed(int otpId) throws SQLException {
        String sql = "UPDATE otp_tokens SET is_used = 1 WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }

    public void incrementAttempt(int otpId) throws SQLException {
        String sql = "UPDATE otp_tokens SET attempt_count = attempt_count + 1 WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }

    public void invalidateAllOtpByEmail(String email) throws SQLException {
        String sql = "UPDATE otp_tokens SET is_used = 1 WHERE email = ? AND is_used = 0";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        }
    }

    public void deleteExpired() throws SQLException {
        String sql = "DELETE FROM otp_tokens WHERE expired_at < NOW() OR attempt_count >= ? OR is_used = 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, MAX_ATTEMPTS);
            ps.executeUpdate();
        }
    }

    private OtpToken mapRow(ResultSet rs) throws SQLException {
        OtpToken token = new OtpToken();
        token.setId(rs.getInt("id"));
        token.setEmail(rs.getString("email"));
        token.setOtpCode(rs.getString("otp_code"));
        token.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        token.setExpiredAt(rs.getTimestamp("expired_at").toLocalDateTime());
        token.setUsed(rs.getBoolean("is_used"));
        token.setAttemptCount(rs.getInt("attempt_count"));
        return token;
    }
}
