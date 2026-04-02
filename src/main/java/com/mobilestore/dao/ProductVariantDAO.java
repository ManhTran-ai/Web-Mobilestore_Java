package com.mobilestore.dao;

import com.mobilestore.entity.ProductVariant;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.Category;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO {

    public List<ProductVariant> findByProductId(Integer productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT pv.variant_id, pv.product_id, pv.color, pv.storage, " +
                "pv.price, pv.quantity_in_stock, pv.variant_image, " +
                "p.product_name, p.manufacturer, p.product_condition, p.product_info, " +
                "p.category_id, p.discount, c.category_name " +
                "FROM product_variants pv " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE pv.product_id = ? " +
                "ORDER BY pv.price ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    variants.add(mapResultSetToVariant(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findByProductId: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

    public ProductVariant findById(Integer variantId) {
        String sql = "SELECT pv.variant_id, pv.product_id, pv.color, pv.storage, " +
                "pv.price, pv.quantity_in_stock, pv.variant_image, " +
                "p.product_name, p.manufacturer, p.product_condition, p.product_info, " +
                "p.category_id, p.discount, c.category_name " +
                "FROM product_variants pv " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE pv.variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVariant(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findById (variant): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public ProductVariant findByIdWithProduct(Integer variantId) {
        String sql = "SELECT pv.variant_id, pv.product_id, pv.color, pv.storage, " +
                "pv.price, pv.quantity_in_stock, pv.variant_image, " +
                "p.product_name, p.manufacturer, p.product_condition, p.product_info, " +
                "p.category_id, p.discount, c.category_name " +
                "FROM product_variants pv " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE pv.variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVariant(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi findByIdWithProduct (variant): " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStock(Integer variantId, int quantityChange) {
        String sql = "UPDATE product_variants SET quantity_in_stock = quantity_in_stock - ? WHERE variant_id = ? AND quantity_in_stock >= ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityChange);
            ps.setInt(2, variantId);
            ps.setInt(3, quantityChange);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi updateStock: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public ProductVariant create(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, color, storage, price, quantity_in_stock, variant_image) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, variant.getProduct().getProductId());
            ps.setString(2, variant.getColor());
            ps.setString(3, variant.getStorage());
            ps.setLong(4, variant.getPrice());
            ps.setInt(5, variant.getQuantityInStock());
            String img = variant.getVariantImage();
            if (img != null && img.startsWith("/")) {
                img = img.substring(1);
            }
            ps.setString(6, img);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        variant.setVariantId(rs.getInt(1));
                        return variant;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi create variant: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(ProductVariant variant) {
        String sql = "UPDATE product_variants SET color = ?, storage = ?, price = ?, " +
                "quantity_in_stock = ?, variant_image = ? WHERE variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, variant.getColor());
            ps.setString(2, variant.getStorage());
            ps.setLong(3, variant.getPrice());
            ps.setInt(4, variant.getQuantityInStock());
            String img = variant.getVariantImage();
            if (img != null && img.startsWith("/")) {
                img = img.substring(1);
            }
            ps.setString(5, img);
            ps.setInt(6, variant.getVariantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi update variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(Integer variantId) {
        String deleteCartSql = "DELETE FROM cart WHERE variant_id = ?";
        String deleteVariantSql = "DELETE FROM product_variants WHERE variant_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement psCart = conn.prepareStatement(deleteCartSql)) {
            psCart.setInt(1, variantId);
            psCart.executeUpdate();

            try (PreparedStatement psVariant = conn.prepareStatement(deleteVariantSql)) {
                psVariant.setInt(1, variantId);
                return psVariant.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi delete variant: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteByProductId(Integer productId) {
        String sql = "DELETE FROM product_variants WHERE product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            System.err.println("Lỗi deleteByProductId: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private ProductVariant mapResultSetToVariant(ResultSet rs) throws SQLException {
        ProductVariant variant = new ProductVariant();
        variant.setVariantId(rs.getInt("variant_id"));

        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setManufacturer(rs.getString("manufacturer"));
        product.setProductCondition(rs.getString("product_condition"));
        product.setProductInfo(rs.getString("product_info"));
        product.setDiscount(rs.getLong("discount"));

        Integer categoryId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(rs.getString("category_name"));
            product.setCategory(category);
        }

        variant.setProduct(product);
        variant.setColor(rs.getString("color"));
        variant.setStorage(rs.getString("storage"));
        variant.setPrice(rs.getLong("price"));
        variant.setQuantityInStock(rs.getInt("quantity_in_stock"));

        String img = rs.getString("variant_image");
        if (img != null && img.startsWith("/")) {
            img = img.substring(1);
        }
        variant.setVariantImage(img);

        return variant;
    }
}
