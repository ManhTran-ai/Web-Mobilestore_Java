package com.mobilestore.service.impl;

import com.mobilestore.config.VNPayConfig;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.entity.Order;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.ShippingStep;
import com.mobilestore.service.GHNService;
import com.mobilestore.service.OrderService;
import java.util.List;

public class OrderServiceImpl implements OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final GHNService ghnService = new GHNServiceImpl();

    @Override
    public List<Order> findAll() {
        return orderDAO.findAll();
    }

    @Override
    public Order findById(Integer id) {
        return orderDAO.findById(id);
    }

    @Override
    public boolean updateStatus(Integer orderId, String status) {
        return orderDAO.updateStatus(orderId, status);
    }

    @Override
    public boolean delete(Integer id) {
        return orderDAO.deleteOrder(id);
    }

    @Override
    public Integer createOrder(Integer userId, Double totalAmount, List<CartItem> items,
                              String shippingAddress, String customerPhone, String note,
                              Double shippingCost, Double shippingDiscount, Integer districtId, String wardCode) {
        return orderDAO.createOrder(userId, totalAmount, items,
                shippingAddress, customerPhone, note, shippingCost, shippingDiscount, districtId, wardCode);
    }

    @Override
    public Integer createOrderWithPayment(Integer userId, Double totalAmount, List<CartItem> items,
                                         String shippingAddress, String customerPhone, String note,
                                         Double shippingCost, Double shippingDiscount, Integer districtId, String wardCode,
                                         String vnpTransactionId, String vnpOrderId) {
        return orderDAO.createOrderWithPayment(userId, totalAmount, items,
                shippingAddress, customerPhone, note, shippingCost, shippingDiscount, districtId, wardCode,
                vnpTransactionId, vnpOrderId);
    }

    @Override
    public List<Order> findByUserId(Integer userId) {
        return orderDAO.findByUserId(userId);
    }

    @Override
    public Order findByIdAndUserId(Integer orderId, Integer userId) {
        return orderDAO.findByIdAndUserId(orderId, userId);
    }

    @Override
    public List<ShippingStep> getShippingHistory(Integer orderId) {
        if (orderId == null) {
            return List.of();
        }
        String trackingNumber = orderDAO.findTrackingNumberById(orderId);
        if (trackingNumber == null || trackingNumber.isBlank()) {
            return List.of();
        }
        return ghnService.getShippingHistory(trackingNumber);
    }

    @Override
    public boolean updateTrackingNumber(Integer orderId, String trackingNumber) {
        if (orderId == null || trackingNumber == null) {
            return false;
        }
        return orderDAO.updateTrackingNumber(orderId, trackingNumber);
    }

    @Override
    public boolean cancelOrder(Integer orderId, Integer userId) {
        if (orderId == null || userId == null) {
            return false;
        }
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return false;
        }
        if (order.getUser() == null || !order.getUser().getId().equals(userId)) {
            return false;
        }
        if (!"PENDING".equals(order.getOrderStatus())) {
            return false;
        }
        boolean updated = orderDAO.cancelOrder(orderId, "CANCELLED");
        if (!updated) {
            return false;
        }
        orderDAO.restoreStockByOrderId(orderId);
        if ("VNPAY".equals(order.getPaymentMethod()) && "PAID".equals(order.getPaymentStatus())) {
            String ipAddr = "127.0.0.1";
            String response = VNPayConfig.refund(
                    order.getVnpOrderId(),
                    order.getVnpTransactionId(),
                    (long) Math.round(order.getTotalAmount() * 100),
                    ipAddr,
                    order.getOrderDate(),
                    "customer"
            );
            System.out.println("[REFUND] orderId=" + orderId
                    + " | vnpTxnRef=" + order.getVnpOrderId()
                    + " | vnpTransNo=" + order.getVnpTransactionId()
                    + " | refundAmount=" + (long) Math.round(order.getTotalAmount() * 100)
                    + " | response=" + response);
            if (response != null && response.contains("\"vnp_ResponseCode\":\"00\"")) {
                orderDAO.updatePaymentStatus(orderId, "REFUNDED");
            }
        }
        return true;
    }

    @Override
    public Integer createOfflineOrder(int variantId, int quantity, long price, String customerPhone, String note) {
        return orderDAO.createOfflineOrder(variantId, quantity, price, customerPhone, note);
    }
}
