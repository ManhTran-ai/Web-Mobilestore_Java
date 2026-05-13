package com.mobilestore.dao;

import com.mobilestore.entity.Review;
import com.mobilestore.entity.User;
import com.mobilestore.entity.Product;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public Review findById(int reviewId) {
        String sql = """
            SELECT r.id, r.rating, r.comment, r.created_at, r.updated_at, r.is_approved,
                   r.admin_reply, r.admin_reply_at,
                   u.id AS user_id, u.username, u.oauth_provider,
                   p.product_id, p.product_name
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            JOIN products p ON r.product_id = p.product_id
            WHERE r.id = ?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReview(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.findById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Review> findByProductId(int productId) {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.id, r.rating, r.comment, r.created_at, r.updated_at, r.is_approved,
                   r.admin_reply, r.admin_reply_at,
                   u.id AS user_id, u.username, u.oauth_provider,
                   p.product_id, p.product_name
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            JOIN products p ON r.product_id = p.product_id
            WHERE r.product_id = ? AND r.is_approved = TRUE
            ORDER BY r.created_at DESC
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.findByProductId: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    public List<Review> findAll() {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.id, r.rating, r.comment, r.created_at, r.updated_at, r.is_approved,
                   r.admin_reply, r.admin_reply_at,
                   u.id AS user_id, u.username, u.oauth_provider,
                   p.product_id, p.product_name
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            JOIN products p ON r.product_id = p.product_id
            ORDER BY r.created_at DESC
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.findAll: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    public List<Review> findPendingReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT r.id, r.rating, r.comment, r.created_at, r.updated_at, r.is_approved,
                   r.admin_reply, r.admin_reply_at,
                   u.id AS user_id, u.username, u.oauth_provider,
                   p.product_id, p.product_name
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            JOIN products p ON r.product_id = p.product_id
            WHERE r.is_approved = FALSE
            ORDER BY r.created_at DESC
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.findPendingReviews: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = """
            SELECT 1 FROM order_details od
            JOIN orders o ON od.order_id = o.order_id
            JOIN product_variants pv ON od.variant_id = pv.variant_id
            WHERE o.user_id = ? AND pv.product_id = ? AND o.order_status = 'DELIVERED'
            LIMIT 1
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.hasUserPurchasedProduct: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT 1 FROM reviews WHERE user_id = ? AND product_id = ? LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.hasUserReviewedProduct: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Review save(Review review) {
        if (review.getId() == null) {
            return insert(review);
        } else {
            update(review);
            return review;
        }
    }

    private Review insert(Review review) {
        String sql = "INSERT INTO reviews (user_id, product_id, rating, comment, is_approved) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, review.getUser().getId());
            ps.setInt(2, review.getProduct().getProductId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setBoolean(5, review.getIsApproved() != null ? review.getIsApproved() : false);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        review.setId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.insert: " + e.getMessage());
            e.printStackTrace();
        }
        return review;
    }

    private void update(Review review) {
        String sql = "UPDATE reviews SET rating = ?, comment = ?, is_approved = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getRating());
            ps.setString(2, review.getComment());
            ps.setBoolean(3, review.getIsApproved() != null ? review.getIsApproved() : false);
            ps.setInt(4, review.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.update: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean approveReview(int reviewId) {
        String sql = "UPDATE reviews SET is_approved = TRUE, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.approveReview: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectReview(int reviewId) {
        return delete(reviewId);
    }

    public boolean delete(int reviewId) {
        String sql = "DELETE FROM reviews WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.delete: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM reviews WHERE product_id = ? AND is_approved = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.getAverageRating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getReviewCount(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = ? AND is_approved = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.getReviewCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateAdminReply(int reviewId, String adminReply) {
        String sql = "UPDATE reviews SET admin_reply = ?, admin_reply_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, adminReply);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi ReviewDAO.updateAdminReply: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setIsApproved(rs.getBoolean("is_approved"));
        r.setAdminReply(rs.getString("admin_reply"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) r.setCreatedAt(createdAt);
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) r.setUpdatedAt(updatedAt);
        Timestamp adminReplyAt = rs.getTimestamp("admin_reply_at");
        if (adminReplyAt != null) r.setAdminReplyAt(adminReplyAt);

        User user = new User();
        user.setId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setOauthProvider(rs.getString("oauth_provider"));
        r.setUser(user);

        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        r.setProduct(product);

        return r;
    }
}
