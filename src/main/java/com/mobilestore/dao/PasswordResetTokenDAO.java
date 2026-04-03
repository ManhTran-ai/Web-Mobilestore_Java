package com.mobilestore.dao;

import com.mobilestore.entity.PasswordResetToken;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PasswordResetTokenDAO {

    public PasswordResetToken findByToken(String token) {
        String sql = "SELECT id, token, user_id, email, expires_at, used, created_at " +
                "FROM password_reset_tokens WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public PasswordResetToken findByUserId(Integer userId) {
        String sql = "SELECT id, token, user_id, email, expires_at, used, created_at " +
                "FROM password_reset_tokens WHERE user_id = ? AND used = 0 " +
                "ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm token theo user_id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public PasswordResetToken create(PasswordResetToken token) {
        String sql = "INSERT INTO password_reset_tokens (token, user_id, email, expires_at, used) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, token.getToken());
            ps.setInt(2, token.getUserId());
            ps.setString(3, token.getEmail());
            ps.setTimestamp(4, Timestamp.valueOf(token.getExpiresAt()));
            ps.setBoolean(5, token.isUsed());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        token.setId(generatedKeys.getInt(1));
                        return token;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean markAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = 1 WHERE token = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi đánh dấu token đã sử dụng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteByUserId(Integer userId) {
        String sql = "DELETE FROM password_reset_tokens WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa token: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteExpiredTokens() {
        String sql = "DELETE FROM password_reset_tokens WHERE expires_at < NOW() OR used = 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa token hết hạn: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private PasswordResetToken mapResultSetToToken(ResultSet rs) throws SQLException {
        PasswordResetToken token = new PasswordResetToken();
        token.setId(rs.getInt("id"));
        token.setToken(rs.getString("token"));
        token.setUserId(rs.getInt("user_id"));
        token.setEmail(rs.getString("email"));
        token.setExpiresAt(rs.getTimestamp("expires_at").toLocalDateTime());
        token.setUsed(rs.getBoolean("used"));
        token.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return token;
    }
}
