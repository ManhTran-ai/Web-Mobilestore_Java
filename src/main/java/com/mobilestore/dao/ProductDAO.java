package com.mobilestore.dao;

import com.mobilestore.entity.Product;
import com.mobilestore.entity.Category;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    public Product findById(Integer id) {
        String sql = "SELECT p.product_id, p.product_name, " +
                     "p.manufacturer, p.product_condition, " +
                     "p.price,p.discount,p.product_info, p.image, p.quantity_in_stock, p.category_id, " +
                     "c.category_name " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm product theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.manufacturer, p.product_condition, " +
                "p.price, p.discount, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                "c.category_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "ORDER BY p.product_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tất cả products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> findByCategory(Integer categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, " +
                     "p.manufacturer, p.product_condition, " +
                     "p.price,p.discount,p.product_info, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                     "c.category_name " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.category_id = ? " +
                     "ORDER BY p.product_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm products theo category: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public List<Product> searchByName(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, " +
                     "p.manufacturer, p.product_condition, " +
                     "p.price,p.discount,p.product_info, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                     "c.category_name " +
                     "FROM products p " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE p.product_name LIKE ? OR p.product_info LIKE ? " +
                     "ORDER BY p.product_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public int countSearch(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM products p WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.product_info LIKE ?)");
        }

        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (categoryId != null) {
                ps.setInt(paramIndex, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm products tìm kiếm: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> searchWithFilter(String keyword, Integer categoryId, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.product_id, p.product_name, ")
                .append("p.manufacturer, p.product_condition, ")
                .append("p.price, p.image, p.product_info, p.quantity_in_stock, p.category_id, ")
                .append("p.discount, ")
                .append("c.category_name ")
                .append("FROM products p ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.product_info LIKE ?)");
        }

        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
        }

        sql.append(" ORDER BY p.product_id DESC LIMIT ? OFFSET ?");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (categoryId != null) {
                ps.setInt(paramIndex++, categoryId);
            }

            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm products với filter: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public int countAll() {
        String sql = "SELECT COUNT(*) AS total FROM products";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm products: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> findPage(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, " +
                "p.manufacturer, p.product_condition, " +
                "p.price, p.discount, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                "c.category_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "ORDER BY p.product_id DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy trang products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    public Product create(Product product) {
        String sql = "INSERT INTO products (product_name, manufacturer, product_condition, price," +
                     "image, product_info, quantity_in_stock, category_id, discount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getManufacturer());
            ps.setString(3, product.getProductCondition());
            ps.setLong(4, product.getPrice());
            String imageToStore = product.getImage();
            if (imageToStore != null && imageToStore.startsWith("/")) {
                imageToStore = imageToStore.substring(1);
            }
            ps.setString(5, imageToStore);
            ps.setString(6, product.getProductInfo());
            ps.setInt(7, product.getQuantityInStock());
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                ps.setInt(8, product.getCategory().getCategoryId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            ps.setLong(9, product.getDiscount());

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setProductId(generatedKeys.getInt(1));
                        return product;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo product: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean update(Product product) {
        String sql = "UPDATE products SET product_name = ?, manufacturer = ?, product_condition = ?, " +
                     "price = ?,discount = ?, image = ?, product_info = ?, quantity_in_stock = ?, category_id = ? " +
                     "WHERE product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getManufacturer());
            ps.setString(3, product.getProductCondition());
            ps.setLong(4, product.getPrice());
            ps.setLong(5, product.getDiscount());
            ps.setString(6, product.getImage());
            ps.setString(7, product.getProductInfo());
            ps.setInt(8, product.getQuantityInStock());
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                ps.setInt(9, product.getCategory().getCategoryId());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            ps.setInt(10, product.getProductId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(Integer id) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Product findByUniqueKey(String productName, String manufacturer, String productCondition, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT p.product_id, p.product_name, p.manufacturer, p.product_condition, ")
                .append("p.price, p.discount, p.image, p.product_info, p.quantity_in_stock, p.category_id, c.category_name ")
                .append("FROM products p LEFT JOIN categories c ON p.category_id = c.category_id WHERE p.product_name = ? AND p.manufacturer = ? AND p.product_condition = ? ");

        if (categoryId == null) {
            sql.append("AND p.category_id IS NULL");
        } else {
            sql.append("AND p.category_id = ?");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setString(1, productName);
            ps.setString(2, manufacturer);
            ps.setString(3, productCondition);
            if (categoryId != null) {
                ps.setInt(4, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm product theo unique key: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    public List<Product> findSales(int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.manufacturer, p.product_condition, " +
                "p.price, p.discount, p.image, p.product_info, p.quantity_in_stock, p.category_id, " +
                "c.category_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE p.discount > 0 " +
                "ORDER BY p.discount DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách sản phẩm sale: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }
    
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setManufacturer(rs.getString("manufacturer"));
        product.setProductCondition(rs.getString("product_condition"));
        product.setPrice(rs.getLong("price"));
        String img = rs.getString("image");
        if (img != null) {
            if (img.startsWith("/")) {
                img = img.substring(1);
            }
        }
        product.setImage(img);
        product.setProductInfo(rs.getString("product_info"));
        product.setQuantityInStock(rs.getInt("quantity_in_stock"));
        
        Integer categoryId = rs.getInt("category_id");
        if (categoryId != null && !rs.wasNull()) {
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(rs.getString("category_name"));
            product.setCategory(category);
        }
            product.setDiscount(rs.getLong("discount"));

        
        return product;
    }
}
