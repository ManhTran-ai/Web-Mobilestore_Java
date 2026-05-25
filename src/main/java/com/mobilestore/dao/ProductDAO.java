package com.mobilestore.dao;

import com.mobilestore.constant.ProductSortOrder;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.Category;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String PRICE_AGG_JOIN =
            " LEFT JOIN (SELECT pv.product_id AS agg_product_id, " +
            "MIN(pv.price) AS effective_price " +
            "FROM product_variants pv " +
            "INNER JOIN products pr ON pr.product_id = pv.product_id " +
            "GROUP BY pv.product_id) price_agg ON price_agg.agg_product_id = p.product_id ";

    private static final String EFFECTIVE_PRICE_COLUMN = "price_agg.effective_price";

    public Product findById(Integer id) {
        String sql = "SELECT p.product_id, p.product_name, " +
                "p.manufacturer, p.product_condition, " +
                "p.discount, p.product_info, p.category_id, " +
                "c.category_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "WHERE p.product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(id));
                    return product;
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
                "p.discount, p.product_info, p.category_id, " +
                "c.category_name " +
                "FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "ORDER BY p.product_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                product.setVariants(findVariantsByProductId(product.getProductId()));
                products.add(product);
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
                "p.discount, p.product_info, p.category_id, " +
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
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
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
                "p.discount, p.product_info, p.category_id, " +
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
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public int countSearch(String keyword, Integer categoryId, Long minPrice, Long maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM products p ");
        appendPriceJoin(sql, minPrice, maxPrice, null);
        sql.append("WHERE 1=1");
        appendKeywordFilter(sql, keyword);
        appendCategoryFilter(sql, categoryId);
        appendPriceFilter(sql, minPrice, maxPrice);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = bindKeywordAndCategory(ps, 1, keyword, categoryId);
            bindPriceParams(ps, paramIndex, minPrice, maxPrice);

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

    public List<Product> searchWithFilter(String keyword, Integer categoryId, Long minPrice, Long maxPrice,
                                          String sortOrder, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.product_id, p.product_name, ")
                .append("p.manufacturer, p.product_condition, ")
                .append("p.discount, p.product_info, p.category_id, ")
                .append("c.category_name ")
                .append("FROM products p ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ");
        appendPriceJoin(sql, minPrice, maxPrice, sortOrder);
        sql.append("WHERE 1=1");

        appendKeywordFilter(sql, keyword);
        appendCategoryFilter(sql, categoryId);
        appendPriceFilter(sql, minPrice, maxPrice);
        appendOrderBy(sql, sortOrder);
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = bindKeywordAndCategory(ps, 1, keyword, categoryId);
            paramIndex = bindPriceParams(ps, paramIndex, minPrice, maxPrice);
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm products với filter: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public int countAll(Long minPrice, Long maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM products p ");
        appendPriceJoin(sql, minPrice, maxPrice, null);
        sql.append("WHERE 1=1");
        appendPriceFilter(sql, minPrice, maxPrice);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindPriceParams(ps, 1, minPrice, maxPrice);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm products: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> findPage(int offset, int limit, Long minPrice, Long maxPrice, String sortOrder) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.product_id, p.product_name, ")
                .append("p.manufacturer, p.product_condition, ")
                .append("p.discount, p.product_info, p.category_id, ")
                .append("c.category_name ")
                .append("FROM products p ")
                .append("LEFT JOIN categories c ON p.category_id = c.category_id ");
        appendPriceJoin(sql, minPrice, maxPrice, sortOrder);
        sql.append("WHERE 1=1");

        appendPriceFilter(sql, minPrice, maxPrice);
        appendOrderBy(sql, sortOrder);
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = bindPriceParams(ps, 1, minPrice, maxPrice);
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy trang products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    private void appendKeywordFilter(StringBuilder sql, String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.product_info LIKE ?)");
        }
    }

    private void appendCategoryFilter(StringBuilder sql, Integer categoryId) {
        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
        }
    }

    private void appendPriceJoin(StringBuilder sql, Long minPrice, Long maxPrice, String sortOrder) {
        if (needsPriceJoin(minPrice, maxPrice, sortOrder)) {
            sql.append(PRICE_AGG_JOIN);
        }
    }

    private boolean needsPriceJoin(Long minPrice, Long maxPrice, String sortOrder) {
        if (minPrice != null || maxPrice != null) {
            return true;
        }
        ProductSortOrder order = ProductSortOrder.fromCode(sortOrder);
        return order == ProductSortOrder.PRICE_ASC || order == ProductSortOrder.PRICE_DESC;
    }

    private void appendPriceFilter(StringBuilder sql, Long minPrice, Long maxPrice) {
        if (minPrice == null && maxPrice == null) {
            return;
        }
        sql.append(" AND ").append(EFFECTIVE_PRICE_COLUMN).append(" IS NOT NULL");
        if (minPrice != null) {
            sql.append(" AND ").append(EFFECTIVE_PRICE_COLUMN).append(" >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND ").append(EFFECTIVE_PRICE_COLUMN).append(" <= ?");
        }
    }

    private void appendOrderBy(StringBuilder sql, String sortOrder) {
        ProductSortOrder order = ProductSortOrder.fromCode(sortOrder);
        if (order == ProductSortOrder.PRICE_ASC) {
            sql.append(" ORDER BY COALESCE(").append(EFFECTIVE_PRICE_COLUMN).append(", 0) ASC, p.product_id DESC");
        } else if (order == ProductSortOrder.PRICE_DESC) {
            sql.append(" ORDER BY COALESCE(").append(EFFECTIVE_PRICE_COLUMN).append(", 0) DESC, p.product_id DESC");
        } else {
            sql.append(" ORDER BY p.product_id DESC");
        }
    }

    private int bindKeywordAndCategory(PreparedStatement ps, int startIndex, String keyword, Integer categoryId)
            throws SQLException {
        int paramIndex = startIndex;
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
        }
        if (categoryId != null) {
            ps.setInt(paramIndex++, categoryId);
        }
        return paramIndex;
    }

    private int bindPriceParams(PreparedStatement ps, int startIndex, Long minPrice, Long maxPrice) throws SQLException {
        int paramIndex = startIndex;
        if (minPrice != null) {
            ps.setLong(paramIndex++, minPrice);
        }
        if (maxPrice != null) {
            ps.setLong(paramIndex++, maxPrice);
        }
        return paramIndex;
    }

    public Product create(Product product) {
        String sql = "INSERT INTO products (product_name, manufacturer, product_condition, " +
                "product_info, category_id, discount) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getProductName());
            ps.setString(2, product.getManufacturer());
            ps.setString(3, product.getProductCondition());
            ps.setString(4, product.getProductInfo());
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                ps.setInt(5, product.getCategory().getCategoryId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setLong(6, product.getDiscount());

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
                "discount = ?, product_info = ?, category_id = ? " +
                "WHERE product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getProductName());
            ps.setString(2, product.getManufacturer());
            ps.setString(3, product.getProductCondition());
            ps.setLong(4, product.getDiscount());
            ps.setString(5, product.getProductInfo());
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                ps.setInt(6, product.getCategory().getCategoryId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setInt(7, product.getProductId());

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
                .append("p.discount, p.product_info, p.category_id, c.category_name ")
                .append("FROM products p LEFT JOIN categories c ON p.category_id = c.category_id ")
                .append("WHERE p.product_name = ? AND p.manufacturer = ? AND p.product_condition = ? ");

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
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    return product;
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
        String sql = "SELECT DISTINCT p.product_id, p.product_name, p.manufacturer, p.product_condition, " +
                "p.discount, p.product_info, p.category_id, " +
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
                    Product product = mapResultSetToProduct(rs);
                    product.setVariants(findVariantsByProductId(product.getProductId()));
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách sản phẩm sale: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
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
            System.err.println("Lỗi khi lấy variants: " + e.getMessage());
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
        product.setProductInfo(rs.getString("product_info"));
        product.setDiscount(rs.getLong("discount"));

        Integer categoryId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryName(rs.getString("category_name"));
            product.setCategory(category);
        }

        return product;
    }
}
