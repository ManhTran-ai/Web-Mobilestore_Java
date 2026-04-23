package com.mobilestore.service;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.ShippingStep;
import java.util.List;

public interface OrderService {
    List<Order> findAll();
    Order findById(Integer id);
    boolean updateStatus(Integer orderId, String status);
    boolean delete(Integer id);
    Integer createOrder(Integer userId, Double totalAmount, List<CartItem> items,
                       String shippingAddress, String customerPhone, String note,
                       Double shippingCost, Integer districtId, String wardCode);
    Integer createOrderWithPayment(Integer userId, Double totalAmount, List<CartItem> items,
                                  String shippingAddress, String customerPhone, String note,
                                  Double shippingCost, Integer districtId, String wardCode,
                                  String vnpTransactionId, String vnpOrderId);
    List<Order> findByUserId(Integer userId);
    Order findByIdAndUserId(Integer orderId, Integer userId);
    List<ShippingStep> getShippingHistory(Integer orderId);
    boolean updateTrackingNumber(Integer orderId, String trackingNumber);
}
