package com.mobilestore.service;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.CartItem;
import java.util.List;

public interface OrderService {
    List<Order> findAll();
    Order findById(Integer id);
    boolean updateStatus(Integer orderId, String status);
    boolean delete(Integer id);
    Integer createOrder(Integer userId, Double totalAmount, List<CartItem> items);
    Integer createOrderWithPayment(Integer userId, Double totalAmount, List<CartItem> items, String vnpTransactionId, String vnpOrderId);
}
