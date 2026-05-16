package com.mobilestore.dao;

import com.mobilestore.model.OtpToken;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;

public class OtpTokenDAO {

    public void insertOtp(OtpToken token) throws SQLException {
        String sql = "INSERT INTO otp_tokens (email, otp_code, created_at, expired_at) VALUES (?, ?, NOW(), ?)";
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
              AND attempt_count < 3
            ORDER BY created_at DESC
            LIMIT 1
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
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
        int usedFlag = rs.getInt("is_used");
        token.setUsed(usedFlag == 1);
        token.setAttemptCount(rs.getInt("attempt_count"));
        return token;
    }
}
