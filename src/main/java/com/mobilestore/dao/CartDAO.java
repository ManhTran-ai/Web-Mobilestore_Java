package com.mobilestore.dao;

import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.Category;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> findByUserId(Integer userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.id, c.quantity, " +
                "pv.variant_id, pv.product_id, pv.color, pv.storage, pv.price, pv.quantity_in_stock, pv.variant_image, " +
                "p.product_name, p.manufacturer, p.product_condition, p.product_info, p.category_id, p.discount, " +
                "cat.category_name " +
                "FROM cart c " +
                "JOIN product_variants pv ON c.variant_id = pv.variant_id " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "LEFT JOIN categories cat ON p.category_id = cat.category_id " +
                "WHERE c.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setManufacturer(rs.getString("manufacturer"));
                    p.setProductCondition(rs.getString("product_condition"));
                    p.setDiscount(rs.getLong("discount"));
                    p.setProductInfo(rs.getString("product_info"));

                    int catId = rs.getInt("category_id");
                    if (!rs.wasNull()) {
                        Category category = new Category();
                        category.setCategoryId(catId);
                        category.setCategoryName(rs.getString("category_name"));
                        p.setCategory(category);
                    }

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
                    variant.setProduct(p);

                    int qty = rs.getInt("quantity");
                    items.add(new CartItem(p, variant, qty));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.findByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public void upsertCartItem(int userId, int variantId, int quantity) {
        String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND variant_id = ?";
        String insertSql = "INSERT INTO cart (quantity, variant_id, user_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, userId);
                ps.setInt(3, variantId);
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    try (PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
                        ps2.setInt(1, quantity);
                        ps2.setInt(2, variantId);
                        ps2.setInt(3, userId);
                        ps2.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.upsertCartItem: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteCartItem(int userId, int variantId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, variantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.deleteCartItem: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void clearCartByUser(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.clearCartByUser: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteByVariantId(int variantId) {
        String sql = "DELETE FROM cart WHERE variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.deleteByVariantId: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
