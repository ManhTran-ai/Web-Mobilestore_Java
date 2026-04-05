package com.mobilestore.dao;

import com.mobilestore.entity.Category;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserLikeDAO {

    public List<Product> findLikedProductsByUser(int userId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.manufacturer, p.product_condition, " +
                "p.discount, p.product_info, p.category_id, c.category_name " +
                "FROM user_likes ul " +
                "JOIN products p ON ul.product_id = p.product_id " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE ul.customer_id = ? " +
                "ORDER BY ul.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách sản phẩm yêu thích: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public boolean removeLike(int userId, int productId) {
        String sql = "DELETE FROM user_likes WHERE customer_id = ? AND product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa sản phẩm yêu thích: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean addLike(int userId, int productId) {
        String sql = "INSERT INTO user_likes (customer_id, product_id) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm sản phẩm yêu thích: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean isLiked(int userId, int productId) {
        String sql = "SELECT 1 FROM user_likes WHERE customer_id = ? AND product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra trạng thái yêu thích: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> findLikedProductIdsByUser(int userId) {
        List<Integer> productIds = new ArrayList<>();
        String sql = "SELECT product_id FROM user_likes WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productIds.add(rs.getInt("product_id"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách ID sản phẩm yêu thích: " + e.getMessage());
            e.printStackTrace();
        }
        return productIds;
    }

    private List<ProductVariant> findVariantsByProductId(Integer productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT variant_id, product_id, color, storage, price, quantity_in_stock, variant_image " +
                "FROM product_variants WHERE product_id = ? ORDER BY price ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductVariant variant = new ProductVariant();
                    variant.setVariantId(rs.getInt("variant_id"));
                    variant.setColor(rs.getString("color"));
                    variant.setStorage(rs.getString("storage"));
                    variant.setPrice(rs.getLong("price"));
                    variant.setQuantityInStock(rs.getInt("quantity_in_stock"));
                    String img = rs.getString("variant_image");
                    if (img != null && img.startsWith("/")) {
                        img = img.substring(1);
                    }
                    variant.setVariantImage(img);
                    variants.add(variant);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy variants trong UserLikeDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setManufacturer(rs.getString("manufacturer"));
        product.setProductCondition(rs.getString("product_condition"));
        product.setDiscount(rs.getLong("discount"));
        product.setProductInfo(rs.getString("product_info"));

        Integer categoryId = rs.getInt("category_id");
        if (categoryId != null && !rs.wasNull()) {
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(rs.getString("category_name"));
            product.setCategory(category);
        }

        return product;
    }
}
