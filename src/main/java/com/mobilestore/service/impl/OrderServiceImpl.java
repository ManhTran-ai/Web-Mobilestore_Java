package com.mobilestore.service.impl;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.entity.Order;
import com.mobilestore.entity.CartItem;
import com.mobilestore.service.OrderService;
import java.util.List;

public class OrderServiceImpl implements OrderService {
    private final OrderDAO orderDAO = new OrderDAO();

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
                              Double shippingCost, Integer districtId, String wardCode) {
        return orderDAO.createOrder(userId, totalAmount, items,
                shippingAddress, customerPhone, note, shippingCost, districtId, wardCode);
    }

    @Override
    public Integer createOrderWithPayment(Integer userId, Double totalAmount, List<CartItem> items,
                                         String shippingAddress, String customerPhone, String note,
                                         Double shippingCost, Integer districtId, String wardCode,
                                         String vnpTransactionId, String vnpOrderId) {
        return orderDAO.createOrderWithPayment(userId, totalAmount, items,
                shippingAddress, customerPhone, note, shippingCost, districtId, wardCode,
                vnpTransactionId, vnpOrderId);
    }
}
