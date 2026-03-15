package com.mobilestore.dao;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.OrderDetail;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.User;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, u.username " +
                "FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.order_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setOrderStatus(rs.getString("order_status"));
                Timestamp ts = rs.getTimestamp("order_date");
                if (ts != null) {
                    o.setOrderDate(new java.util.Date(ts.getTime()));
                }
                o.setTotalAmount(rs.getDouble("total_amount"));
                Integer uid = rs.getInt("user_id");
                if (!rs.wasNull()) {
                    User u = new User();
                    u.setId(uid);
                    u.setUsername(rs.getString("username"));
                    o.setUser(u);
                }
                orders.add(o);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findAll: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public Order findById(int orderId) {
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, u.username " +
                "FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderStatus(rs.getString("order_status"));
                    Timestamp ts = rs.getTimestamp("order_date");
                    if (ts != null) {
                        o.setOrderDate(new java.util.Date(ts.getTime()));
                    }
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    Integer uid = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        User u = new User();
                        u.setId(uid);
                        u.setUsername(rs.getString("username"));
                        o.setUser(u);
                    }
                    o.setDetails(findDetailsByOrderId(orderId));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderDetail> findDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.id, od.price, od.quantity, od.product_id, p.product_name FROM order_details od " +
                "LEFT JOIN products p ON od.product_id = p.product_id WHERE od.order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail od = new OrderDetail();
                    od.setId(rs.getInt("id"));
                    od.setPrice(rs.getDouble("price"));
                    od.setQuantity(rs.getInt("quantity"));
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    od.setProduct(p);
                    list.add(od);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findDetailsByOrderId: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.updateStatus: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOrder(int orderId) {
        String delDetails = "DELETE FROM order_details WHERE order_id = ?";
        String delOrder = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(delDetails);
                 PreparedStatement ps2 = conn.prepareStatement(delOrder)) {
                ps1.setInt(1, orderId);
                ps1.executeUpdate();
                ps2.setInt(1, orderId);
                int affected = ps2.executeUpdate();
                conn.commit();
                return affected > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.deleteOrder: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public Integer createOrder(int userId, double totalAmount, List<com.mobilestore.entity.CartItem> items) {
        String orderSql = "INSERT INTO orders (order_status, order_date, total_amount, user_id) VALUES (?, ?, ?, ?)";
        String detailSql = "INSERT INTO order_details (price, quantity, order_id, product_id) VALUES (?, ?, ?, ?)";
        String updateProductSql = "UPDATE products SET quantity_in_stock = quantity_in_stock - ? WHERE product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, "PENDING");
                psOrder.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                psOrder.setDouble(3, totalAmount);
                psOrder.setInt(4, userId);
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                             PreparedStatement psUpdateProduct = conn.prepareStatement(updateProductSql)) {
                            for (com.mobilestore.entity.CartItem item : items) {
                                psDetail.setDouble(1, item.getProduct().getPrice());
                                psDetail.setInt(2, item.getQuantity());
                                psDetail.setInt(3, orderId);
                                psDetail.setInt(4, item.getProduct().getProductId());
                                psDetail.addBatch();

                                psUpdateProduct.setInt(1, item.getQuantity());
                                psUpdateProduct.setInt(2, item.getProduct().getProductId());
                                psUpdateProduct.addBatch();
                            }
                            psDetail.executeBatch();
                            psUpdateProduct.executeBatch();
                        }

                        conn.commit();
                        return orderId;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.createOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Integer createOrderWithPayment(int userId, double totalAmount, 
            List<com.mobilestore.entity.CartItem> items, String vnpTransactionId, String vnpOrderId) {
        
        String orderSql = "INSERT INTO orders (order_status, order_date, total_amount, user_id, " +
                "vnp_transaction_id, vnp_order_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO order_details (price, quantity, order_id, product_id) VALUES (?, ?, ?, ?)";
        String updateProductSql = "UPDATE products SET quantity_in_stock = quantity_in_stock - ? WHERE product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, "PENDING");
                psOrder.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                psOrder.setDouble(3, totalAmount);
                psOrder.setInt(4, userId);
                psOrder.setString(5, vnpTransactionId);
                psOrder.setString(6, vnpOrderId);
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                             PreparedStatement psUpdateProduct = conn.prepareStatement(updateProductSql)) {
                            for (com.mobilestore.entity.CartItem item : items) {
                                psDetail.setDouble(1, item.getProduct().getPrice());
                                psDetail.setInt(2, item.getQuantity());
                                psDetail.setInt(3, orderId);
                                psDetail.setInt(4, item.getProduct().getProductId());
                                psDetail.addBatch();

                                psUpdateProduct.setInt(1, item.getQuantity());
                                psUpdateProduct.setInt(2, item.getProduct().getProductId());
                                psUpdateProduct.addBatch();
                            }
                            psDetail.executeBatch();
                            psUpdateProduct.executeBatch();
                        }

                        conn.commit();
                        return orderId;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi createOrderWithPayment: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}


