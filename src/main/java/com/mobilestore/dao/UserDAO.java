package com.mobilestore.dao;

import com.mobilestore.entity.User;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code " +
                     "FROM users " +
                     "WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo username: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public User findById(Integer id) {
        String sql = "SELECT id, username, password, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code " +
                     "FROM users " +
                     "WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, password, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code " +
                     "FROM users";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tất cả users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    public User create(User user) {
        String sql = "INSERT INTO users (username, password, role_name, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, "CUSTOMER");
            ps.setString(4, user.getEmail());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean update(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, role_name = ?, email = ?, shipping_address = ?, customer_phone = ?, note = ?, district_id = ?, ward_code = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRoleName() != null ? user.getRoleName() : "CUSTOMER");
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getShippingAddress());
            ps.setString(6, user.getCustomerPhone());
            ps.setString(7, user.getNote());
            ps.setObject(8, user.getDistrictId());
            ps.setString(9, user.getWardCode());
            ps.setInt(10, user.getId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, shipping_address = ?, customer_phone = ?, note = ?, district_id = ?, ward_code = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getShippingAddress());
            ps.setString(4, user.getCustomerPhone());
            ps.setString(5, user.getNote());
            ps.setObject(6, user.getDistrictId());
            ps.setString(7, user.getWardCode());
            ps.setInt(8, user.getId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật hồ sơ user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(Integer id, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, id);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật mật khẩu user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(Integer id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRoleName(rs.getString("role_name"));
        user.setOauthProvider(rs.getString("oauth_provider"));
        user.setOauthId(rs.getString("oauth_id"));
        user.setEmail(rs.getString("email"));
        user.setShippingAddress(rs.getString("shipping_address"));
        user.setCustomerPhone(rs.getString("customer_phone"));
        user.setNote(rs.getString("note"));
        user.setDistrictId(rs.getObject("district_id", Integer.class));
        user.setWardCode(rs.getString("ward_code"));
        
        return user;
    }
    
    public User findByOauthId(String oauthId, String oauthProvider) {
        String sql = "SELECT id, username, password, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code " +
                     "FROM users " +
                     "WHERE oauth_id = ? AND oauth_provider = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, oauthId);
            ps.setString(2, oauthProvider);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo oauth_id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User findByEmail(String email) {
        String sql = "SELECT id, username, password, role_name, oauth_provider, oauth_id, email, shipping_address, customer_phone, note, district_id, ward_code " +
                     "FROM users " +
                     "WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm user theo email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User createWithOAuth(User user) {
        String sql = "INSERT INTO users (username, password, role_name, oauth_provider, oauth_id, email) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword() != null ? user.getPassword() : null);
            ps.setString(3, user.getRoleName() != null ? user.getRoleName(): "CUSTOMER");
            ps.setString(4, user.getOauthProvider());
            ps.setString(5, user.getOauthId());
            ps.setString(6, user.getEmail());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo user OAuth: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
