package com.mobilestore.dao;

import com.mobilestore.constant.UserAccountStatus;
import com.mobilestore.entity.User;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UserDAO {

    private static final String USER_COLUMNS =
            "id, username, password, role_name, account_status, deleted_at, oauth_provider, oauth_id, " +
            "email, shipping_address, customer_phone, note, district_id, ward_code";

    public User findByUsername(String username) {
        String sql = "SELECT " + USER_COLUMNS + " FROM users WHERE username = ? AND account_status <> 'DELETED'";

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
        String sql = "SELECT " + USER_COLUMNS + " FROM users WHERE id = ?";

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
        return findAllForAdmin(false);
    }

    /** Danh sách quản trị: mặc định gồm cả tài khoản đã xóa mềm để admin tra cứu. */
    public List<User> findAllForAdmin(boolean includeDeletedOnly) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT " + USER_COLUMNS + " FROM users";
        if (includeDeletedOnly) {
            sql += " WHERE account_status = 'DELETED'";
        }
        sql += " ORDER BY id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public User create(User user) {
        String sql = "INSERT INTO users (username, password, role_name, account_status, email) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRoleName() != null ? user.getRoleName() : "CUSTOMER");
            ps.setString(4, user.getAccountStatus() != null ? user.getAccountStatus() : UserAccountStatus.ACTIVE.getCode());
            ps.setString(5, user.getEmail());

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

    public User createByAdmin(User user) {
        String sql = "INSERT INTO users (username, password, role_name, account_status, email, customer_phone, shipping_address, note) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRoleName() != null ? user.getRoleName() : "CUSTOMER");
            ps.setString(4, user.getAccountStatus() != null ? user.getAccountStatus() : UserAccountStatus.ACTIVE.getCode());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getCustomerPhone());
            ps.setString(7, user.getShippingAddress());
            ps.setString(8, user.getNote());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        return findById(user.getId());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi admin tạo user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, role_name = ?, account_status = ?, email = ?, " +
                     "shipping_address = ?, customer_phone = ?, note = ?, district_id = ?, ward_code = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRoleName() != null ? user.getRoleName() : "CUSTOMER");
            ps.setString(4, user.getAccountStatus() != null ? user.getAccountStatus() : UserAccountStatus.ACTIVE.getCode());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getShippingAddress());
            ps.setString(7, user.getCustomerPhone());
            ps.setString(8, user.getNote());
            ps.setObject(9, user.getDistrictId());
            ps.setString(10, user.getWardCode());
            ps.setInt(11, user.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAdmin(User user) {
        String sql = "UPDATE users SET username = ?, role_name = ?, account_status = ?, email = ?, " +
                     "customer_phone = ?, shipping_address = ?, note = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getRoleName());
            ps.setString(3, user.getAccountStatus());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getCustomerPhone());
            ps.setString(6, user.getShippingAddress());
            ps.setString(7, user.getNote());
            ps.setInt(8, user.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi admin cập nhật user: " + e.getMessage());
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

            return ps.executeUpdate() > 0;
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

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật mật khẩu user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /** Xóa mềm: đổi account_status = DELETED, ghi deleted_at, không xóa dòng trong DB. */
    public boolean softDelete(Integer id) {
        String sql = "UPDATE users SET account_status = 'DELETED', deleted_at = NOW() WHERE id = ? AND account_status <> 'DELETED'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa mềm user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Deprecated
    public boolean delete(Integer id) {
        return softDelete(id);
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRoleName(rs.getString("role_name"));
        user.setAccountStatus(rs.getString("account_status"));
        Timestamp deletedAt = rs.getTimestamp("deleted_at");
        if (deletedAt != null) {
            user.setDeletedAt(new Date(deletedAt.getTime()));
        }
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
        String sql = "SELECT " + USER_COLUMNS + " FROM users WHERE oauth_id = ? AND oauth_provider = ? AND account_status <> 'DELETED'";

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
        String sql = "SELECT " + USER_COLUMNS + " FROM users WHERE email = ? AND account_status <> 'DELETED'";

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
        String sql = "INSERT INTO users (username, password, role_name, account_status, oauth_provider, oauth_id, email) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRoleName() != null ? user.getRoleName() : "CUSTOMER");
            ps.setString(4, UserAccountStatus.ACTIVE.getCode());
            ps.setString(5, user.getOauthProvider());
            ps.setString(6, user.getOauthId());
            ps.setString(7, user.getEmail());

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
