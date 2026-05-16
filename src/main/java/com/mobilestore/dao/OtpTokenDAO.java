package com.mobilestore.dao;

import com.mobilestore.entity.OtpToken;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;

public class OtpTokenDAO {

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
        System.out.println("[OTP-DAO] Querying DB for email: " + email);
        System.out.println("[OTP-DAO] MySQL NOW(): " + getDbNow());
        String sql = """
            SELECT * FROM otp_tokens
            WHERE email = ?
              AND is_used = 0
              AND expired_at > NOW()
              AND attempt_count < 3
            ORDER BY created_at DESC
            LIMIT 1
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OtpToken token = mapRow(rs);
                System.out.println("[OTP-DAO] Found OTP: id=" + token.getId()
                    + ", code=" + token.getOtpCode()
                    + ", expiredAt=" + token.getExpiredAt()
                    + ", createdAt=" + token.getCreatedAt());
                return token;
            }
            System.out.println("[OTP-DAO] No OTP found for email: " + email);
            return null;
        }
    }

    private String getDbNow() {
        try (Connection conn = DatabaseConnection.getConnection();
             var stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT NOW() as now")) {
            if (rs.next()) {
                return rs.getTimestamp("now").toLocalDateTime().toString();
            }
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
        return "UNKNOWN";
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
