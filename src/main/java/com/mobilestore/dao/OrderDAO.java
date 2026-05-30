package com.mobilestore.dao;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.OrderDetail;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.User;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, " +
                "u.username, o.shipping_address, o.customer_phone, o.note, o.shipping_cost, " +
                "o.district_id, o.ward_code, o.tracking_number " +
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
                o.setShippingCost(rs.getObject("shipping_cost") != null ? rs.getDouble("shipping_cost") : 0.0);
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setNote(rs.getString("note"));
                Integer districtId = (Integer) rs.getObject("district_id");
                o.setDistrictId(districtId);
                o.setWardCode(rs.getString("ward_code"));
                o.setTrackingNumber(rs.getString("tracking_number"));
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
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, " +
                "u.username, o.shipping_address, o.customer_phone, o.note, o.shipping_cost, " +
                "o.district_id, o.ward_code, o.tracking_number, o.payment_method, o.payment_status, " +
                "o.vnp_transaction_id, o.vnp_order_id " +
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
                    o.setShippingCost(rs.getObject("shipping_cost") != null ? rs.getDouble("shipping_cost") : 0.0);
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setCustomerPhone(rs.getString("customer_phone"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    o.setPaymentStatus(rs.getString("payment_status"));
                    o.setVnpTransactionId(rs.getString("vnp_transaction_id"));
                    o.setVnpOrderId(rs.getString("vnp_order_id"));
                    Integer districtId = (Integer) rs.getObject("district_id");
                    o.setDistrictId(districtId);
                    o.setWardCode(rs.getString("ward_code"));
                    o.setTrackingNumber(rs.getString("tracking_number"));
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
        String sql = "SELECT od.id, od.price, od.quantity, od.variant_id, " +
                "p.product_name, p.product_id, pv.color, pv.storage " +
                "FROM order_details od " +
                "LEFT JOIN product_variants pv ON od.variant_id = pv.variant_id " +
                "LEFT JOIN products p ON pv.product_id = p.product_id " +
                "WHERE od.order_id = ?";
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

                    Integer variantId = rs.getInt("variant_id");
                    if (!rs.wasNull()) {
                        ProductVariant pv = new ProductVariant();
                        pv.setVariantId(variantId);
                        pv.setColor(rs.getString("color"));
                        pv.setStorage(rs.getString("storage"));
                        od.setVariant(pv);
                    }

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
        }
        return false;
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
        }
        return false;
    }

    public Integer createOrder(int userId, double totalAmount, List<CartItem> items,
                               String shippingAddress, String customerPhone, String note,
                               double shippingCost, Integer districtId, String wardCode) {
        String orderSql = "INSERT INTO orders (order_status, order_date, total_amount, user_id, " +
                "shipping_address, customer_phone, note, shipping_cost, district_id, ward_code) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO order_details (price, quantity, order_id, variant_id) VALUES (?, ?, ?, ?)";
        String updateVariantSql = "UPDATE product_variants SET quantity_in_stock = quantity_in_stock - ? WHERE variant_id = ?";

        if (totalAmount < 0) totalAmount = 0;
        if (shippingCost < 0) shippingCost = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, "PENDING");
                psOrder.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                psOrder.setDouble(3, totalAmount);
                psOrder.setInt(4, userId);
                psOrder.setString(5, shippingAddress);
                psOrder.setString(6, customerPhone);
                psOrder.setString(7, note);
                psOrder.setDouble(8, shippingCost);
                if (districtId != null) {
                    psOrder.setInt(9, districtId);
                } else {
                    psOrder.setNull(9, Types.INTEGER);
                }
                psOrder.setString(10, wardCode);
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                             PreparedStatement psUpdateVariant = conn.prepareStatement(updateVariantSql)) {
                            for (CartItem item : items) {
                                ProductVariant variant = item.getVariant();
                                Product product = item.getProduct();

                                psDetail.setDouble(1, variant != null ? variant.getPrice() : product.getDisplayPrice());
                                psDetail.setInt(2, item.getQuantity());
                                psDetail.setInt(3, orderId);
                                if (variant != null) {
                                    psDetail.setInt(4, variant.getVariantId());
                                } else {
                                    psDetail.setNull(4, Types.INTEGER);
                                }
                                psDetail.addBatch();

                                if (variant != null) {
                                    psUpdateVariant.setInt(1, item.getQuantity());
                                    psUpdateVariant.setInt(2, variant.getVariantId());
                                    psUpdateVariant.addBatch();
                                }
                            }
                            psDetail.executeBatch();
                            psUpdateVariant.executeBatch();
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
                                          List<CartItem> items,
                                          String shippingAddress, String customerPhone, String note,
                                          double shippingCost, Integer districtId, String wardCode,
                                          String vnpTransactionId, String vnpOrderId) {

        String orderSql = "INSERT INTO orders (order_status, order_date, total_amount, user_id, " +
                "shipping_address, customer_phone, note, shipping_cost, district_id, ward_code, " +
                "vnp_transaction_id, vnp_order_id, payment_method, payment_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO order_details (price, quantity, order_id, variant_id) VALUES (?, ?, ?, ?)";
        String updateVariantSql = "UPDATE product_variants SET quantity_in_stock = quantity_in_stock - ? WHERE variant_id = ?";

        if (totalAmount < 0) totalAmount = 0;
        if (shippingCost < 0) shippingCost = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, "PENDING");
                psOrder.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                psOrder.setDouble(3, totalAmount);
                psOrder.setInt(4, userId);
                psOrder.setString(5, shippingAddress);
                psOrder.setString(6, customerPhone);
                psOrder.setString(7, note);
                psOrder.setDouble(8, shippingCost);
                if (districtId != null) {
                    psOrder.setInt(9, districtId);
                } else {
                    psOrder.setNull(9, Types.INTEGER);
                }
                psOrder.setString(10, wardCode);
                psOrder.setString(11, vnpTransactionId);
                psOrder.setString(12, vnpOrderId);
                psOrder.setString(13, "VNPAY");
                psOrder.setString(14, "PAID");
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                             PreparedStatement psUpdateVariant = conn.prepareStatement(updateVariantSql)) {
                            for (CartItem item : items) {
                                ProductVariant variant = item.getVariant();
                                Product product = item.getProduct();

                                psDetail.setDouble(1, variant != null ? variant.getPrice() : product.getDisplayPrice());
                                psDetail.setInt(2, item.getQuantity());
                                psDetail.setInt(3, orderId);
                                if (variant != null) {
                                    psDetail.setInt(4, variant.getVariantId());
                                } else {
                                    psDetail.setNull(4, Types.INTEGER);
                                }
                                psDetail.addBatch();

                                if (variant != null) {
                                    psUpdateVariant.setInt(1, item.getQuantity());
                                    psUpdateVariant.setInt(2, variant.getVariantId());
                                    psUpdateVariant.addBatch();
                                }
                            }
                            psDetail.executeBatch();
                            psUpdateVariant.executeBatch();
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

    public List<Order> findByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, " +
                "o.shipping_address, o.customer_phone, o.note, o.shipping_cost, o.payment_method, " +
                "o.district_id, o.ward_code, o.tracking_number " +
                "FROM orders o WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderStatus(rs.getString("order_status"));
                    Timestamp ts = rs.getTimestamp("order_date");
                    if (ts != null) {
                        o.setOrderDate(new java.util.Date(ts.getTime()));
                    }
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setShippingCost(rs.getObject("shipping_cost") != null ? rs.getDouble("shipping_cost") : 0.0);
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setCustomerPhone(rs.getString("customer_phone"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    Integer districtId = (Integer) rs.getObject("district_id");
                    o.setDistrictId(districtId);
                    o.setWardCode(rs.getString("ward_code"));
                    o.setTrackingNumber(rs.getString("tracking_number"));
                    o.setDetails(findDetailsByOrderId(o.getOrderId()));
                    orders.add(o);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public Order findByIdAndUserId(int orderId, int userId) {
        String sql = "SELECT o.order_id, o.order_status, o.order_date, o.total_amount, o.user_id, " +
                "o.shipping_address, o.customer_phone, o.note, o.shipping_cost, o.payment_method, " +
                "o.district_id, o.ward_code, o.tracking_number, o.vnp_transaction_id, o.vnp_order_id " +
                "FROM orders o WHERE o.order_id = ? AND o.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
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
                    o.setShippingCost(rs.getObject("shipping_cost") != null ? rs.getDouble("shipping_cost") : 0.0);
                    o.setShippingAddress(rs.getString("shipping_address"));
                    o.setCustomerPhone(rs.getString("customer_phone"));
                    o.setNote(rs.getString("note"));
                    o.setPaymentMethod(rs.getString("payment_method"));
                    Integer districtId = (Integer) rs.getObject("district_id");
                    o.setDistrictId(districtId);
                    o.setWardCode(rs.getString("ward_code"));
                    o.setTrackingNumber(rs.getString("tracking_number"));
                    o.setVnpTransactionId(rs.getString("vnp_transaction_id"));
                    o.setVnpOrderId(rs.getString("vnp_order_id"));
                    User u = new User();
                    u.setId(rs.getInt("user_id"));
                    o.setUser(u);
                    o.setDetails(findDetailsByOrderId(orderId));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findByIdAndUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public String findTrackingNumberById(int orderId) {
        String sql = "SELECT tracking_number FROM orders WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("tracking_number");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.findTrackingNumberById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTrackingNumber(int orderId, String trackingNumber) {
        String sql = "UPDATE orders SET tracking_number = ? WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trackingNumber);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi OrderDAO.updateTrackingNumber: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean restoreStockByOrderId(int orderId) {
        String sql = "UPDATE product_variants pv " +
                "JOIN order_details od ON pv.variant_id = od.variant_id " +
                "SET pv.quantity_in_stock = pv.quantity_in_stock + od.quantity " +
                "WHERE od.order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Loi restoreStockByOrderId: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePaymentStatus(int orderId, String status) {
        String sql = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Loi updatePaymentStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelOrder(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Loi cancelOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Integer createOfflineOrder(int variantId, int quantity, long price, String customerPhone, String note) {
        String orderSql = "INSERT INTO orders (order_status, order_date, total_amount, customer_phone, note, payment_method, payment_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String detailSql = "INSERT INTO order_details (price, quantity, order_id, variant_id) VALUES (?, ?, ?, ?)";
        String updateVariantSql = "UPDATE product_variants SET quantity_in_stock = quantity_in_stock - ? WHERE variant_id = ? AND quantity_in_stock >= ?";

        double totalAmount = price * quantity;

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, "COMPLETED");
                psOrder.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                psOrder.setDouble(3, totalAmount);
                psOrder.setString(4, customerPhone);
                psOrder.setString(5, note);
                psOrder.setString(6, "OFFLINE");
                psOrder.setString(7, "PAID");
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                             PreparedStatement psUpdateVariant = conn.prepareStatement(updateVariantSql)) {
                            psDetail.setDouble(1, price);
                            psDetail.setInt(2, quantity);
                            psDetail.setInt(3, orderId);
                            psDetail.setInt(4, variantId);
                            psDetail.addBatch();

                            psUpdateVariant.setInt(1, quantity);
                            psUpdateVariant.setInt(2, variantId);
                            psUpdateVariant.setInt(3, quantity);
                            psUpdateVariant.addBatch();

                            psDetail.executeBatch();
                            int updated = psUpdateVariant.executeUpdate();
                            if (updated == 0) {
                                throw new SQLException("Khong du so luong trong kho");
                            }
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
            System.err.println("Loi createOfflineOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
