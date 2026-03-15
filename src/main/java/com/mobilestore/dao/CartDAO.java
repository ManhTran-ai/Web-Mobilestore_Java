package com.mobilestore.dao;

import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.Category;
import com.mobilestore.entity.Product;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> findByUserId(Integer userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.quantity, p.product_id, p.product_name, p.manufacturer, p.product_condition, p.price, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                "cat.category_id as cat_id, cat.category_name " +
                "FROM cart c JOIN products p ON c.product_id = p.product_id " +
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
                    p.setPrice(rs.getLong("price"));
                    p.setImage(rs.getString("image"));
                    p.setProductInfo(rs.getString("product_info"));
                    p.setQuantityInStock(rs.getInt("quantity_in_stock"));

                    int catId = rs.getInt("cat_id");
                    if (!rs.wasNull()) {
                        Category category = new Category();
                        category.setCategoryId(catId);
                        category.setCategoryName(rs.getString("category_name"));
                        p.setCategory(category);
                    }

                    int qty = rs.getInt("quantity");
                    items.add(new CartItem(p, qty));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi CartDAO.findByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public void upsertCartItem(int userId, int productId, int quantity) {
        String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO cart (quantity, product_id, user_id) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, userId);
                ps.setInt(3, productId);
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    try (PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
                        ps2.setInt(1, quantity);
                        ps2.setInt(2, productId);
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

    public void deleteCartItem(int userId, int productId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
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
}


