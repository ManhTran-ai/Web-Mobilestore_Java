package com.mobilestore.controller;

import com.mobilestore.config.VNPayConfig;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.CartService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "VNPayServlet", urlPatterns = {"/vnpay-payment"})
public class VNPayServlet extends HttpServlet {
    
    private final OrderService orderService = new OrderServiceImpl();
    private final CartService cartService = new CartServiceImpl();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                request.getContextPath() + "/checkout");
            return;
        }
        
        HttpSession session = request.getSession();
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            cart = cartService.findByUserId(user.getId());
        }
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        double total = 0.0;
        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }
        
        String orderId = "ORDER_" + System.currentTimeMillis();
        
        session.setAttribute("vnp_order_id", orderId);
        session.setAttribute("vnp_total_amount", total);
        session.setAttribute("vnp_cart", cart);
        session.setAttribute("vnp_user_id", user.getId());
        
        String ipAddr = getClientIP(request);
        
        String paymentUrl = VNPayConfig.createPaymentUrl(
            (long) total,
            orderId,
            "Thanh toan don hang " + orderId,
            ipAddr
        );
        
        response.sendRedirect(paymentUrl);
    }
    
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}

