package com.mobilestore.dao;

import com.mobilestore.dto.AdminDashboardData;
import com.mobilestore.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class AdminDashboardDAO {

    public int countNewUsersThisMonth() {
        if (hasColumn("users", "created_at")) {
            String sql = "SELECT COUNT(*) AS cnt FROM users " +
                    "WHERE role_name = 'CUSTOMER' " +
                    "AND created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01') " +
                    "AND created_at < DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH)";
            return queryInt(sql);
        }

        String fallbackSql = "SELECT COUNT(DISTINCT user_id) AS cnt FROM orders " +
                "WHERE user_id IS NOT NULL " +
                "AND order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') " +
                "AND order_date < DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH)";
        return queryInt(fallbackSql);
    }

    public int countNewOrdersToday() {
        String sql = "SELECT COUNT(*) AS cnt FROM orders " +
                "WHERE order_date >= CURDATE() " +
                "AND order_date < DATE_ADD(CURDATE(), INTERVAL 1 DAY)";
        return queryInt(sql);
    }

    public int countTotalOrders() {
        String sql = "SELECT COUNT(*) AS cnt FROM orders";
        return queryInt(sql);
    }

    public double revenueToday() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders " +
                "WHERE UPPER(order_status) = 'DELIVERED' " +
                "AND order_date >= CURDATE() " +
                "AND order_date < DATE_ADD(CURDATE(), INTERVAL 1 DAY)";
        return queryDouble(sql);
    }

    public double revenueWeek() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders " +
                "WHERE UPPER(order_status) = 'DELIVERED' " +
                "AND YEARWEEK(order_date, 1) = YEARWEEK(CURDATE(), 1)";
        return queryDouble(sql);
    }

    public double revenueMonth() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders " +
                "WHERE UPPER(order_status) = 'DELIVERED' " +
                "AND YEAR(order_date) = YEAR(CURDATE()) " +
                "AND MONTH(order_date) = MONTH(CURDATE())";
        return queryDouble(sql);
    }

    public double revenueQuarter() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders " +
                "WHERE UPPER(order_status) = 'DELIVERED' " +
                "AND YEAR(order_date) = YEAR(CURDATE()) " +
                "AND QUARTER(order_date) = QUARTER(CURDATE())";
        return queryDouble(sql);
    }

    public double revenueYear() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total FROM orders " +
                "WHERE UPPER(order_status) = 'DELIVERED' " +
                "AND YEAR(order_date) = YEAR(CURDATE())";
        return queryDouble(sql);
    }

    public Map<String, Integer> countOrdersByStatus() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT UPPER(order_status) AS status_name, COUNT(*) AS cnt FROM orders GROUP BY UPPER(order_status)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getString("status_name"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.err.println("Loi countOrdersByStatus: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    public List<Double> revenueLastNMonths(int months) {
        if (months <= 0) {
            return List.of();
        }

        LocalDate now = LocalDate.now();
        LocalDate startMonth = now.minusMonths(months - 1L).withDayOfMonth(1);

        String sql = "SELECT YEAR(order_date) AS y, MONTH(order_date) AS m, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM orders " +
            "WHERE UPPER(order_status) = 'DELIVERED' " +
            "AND order_date >= ? " +
                "GROUP BY YEAR(order_date), MONTH(order_date) " +
                "ORDER BY YEAR(order_date), MONTH(order_date)";

        Map<String, Double> dbRevenue = new HashMap<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, startMonth.toString() + " 00:00:00");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int year = rs.getInt("y");
                    int month = rs.getInt("m");
                    double total = rs.getDouble("total");
                    dbRevenue.put(year + "-" + month, total);
                }
            }
        } catch (SQLException e) {
            System.err.println("Loi revenueLastNMonths: " + e.getMessage());
            e.printStackTrace();
        }

        List<Double> result = new ArrayList<>();
        LocalDate cursor = startMonth;
        for (int i = 0; i < months; i++) {
            String key = cursor.getYear() + "-" + cursor.getMonthValue();
            result.add(dbRevenue.getOrDefault(key, 0.0));
            cursor = cursor.plusMonths(1);
        }

        return result;
    }

    public List<String> labelsLastNMonths(int months) {
        if (months <= 0) {
            return List.of();
        }

        List<String> labels = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yyyy", new Locale("vi", "VN"));

        LocalDate cursor = LocalDate.now().minusMonths(months - 1L).withDayOfMonth(1);
        for (int i = 0; i < months; i++) {
            labels.add(cursor.format(formatter));
            cursor = cursor.plusMonths(1);
        }

        return labels;
    }

    public List<AdminDashboardData.TopSellingProduct> findTopSellingProducts(int limit) {
        if (limit <= 0) {
            return List.of();
        }

        List<AdminDashboardData.TopSellingProduct> result = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.manufacturer, " +
                "COALESCE(SUM(od.quantity), 0) AS total_sold " +
                "FROM orders o " +
                "JOIN order_details od ON o.order_id = od.order_id " +
                "JOIN product_variants pv ON od.variant_id = pv.variant_id " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "WHERE UPPER(o.order_status) = 'DELIVERED' " +
                "GROUP BY p.product_id, p.product_name, p.manufacturer " +
                "ORDER BY total_sold DESC, p.product_name ASC " +
                "LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new AdminDashboardData.TopSellingProduct(
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("manufacturer"),
                            rs.getInt("total_sold")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Loi findTopSellingProducts: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    public List<AdminDashboardData.LowStockVariant> findLowStockVariants(int limit) {
        if (limit <= 0) {
            return List.of();
        }

        List<AdminDashboardData.LowStockVariant> result = new ArrayList<>();
        String sql = "SELECT pv.variant_id, pv.product_id, p.product_name, p.manufacturer, " +
                "pv.color, pv.storage, pv.quantity_in_stock " +
                "FROM product_variants pv " +
                "JOIN products p ON pv.product_id = p.product_id " +
                "WHERE pv.quantity_in_stock < 5 " +
                "ORDER BY pv.quantity_in_stock ASC, p.product_name ASC, pv.variant_id ASC " +
                "LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new AdminDashboardData.LowStockVariant(
                            rs.getInt("variant_id"),
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("manufacturer"),
                            rs.getString("color"),
                            rs.getString("storage"),
                            rs.getInt("quantity_in_stock")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Loi findLowStockVariants: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    private int queryInt(String sql) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Loi queryInt: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    private double queryDouble(String sql) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("Loi queryDouble: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    private boolean hasColumn(String tableName, String columnName) {
        String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tableName);
            ps.setString(2, columnName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Loi hasColumn: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
