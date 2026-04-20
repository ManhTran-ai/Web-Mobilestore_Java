package com.mobilestore.controller;

import com.mobilestore.config.VNPayConfig;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.CartService;
import com.mobilestore.service.ShippingService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.service.impl.ShippingServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.ProductVariant;
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
    private final ShippingService shippingService = new ShippingServiceImpl();

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

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            cart = cartService.findByUserId(user.getId());
        }

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double cartTotal = 0.0;
        for (CartItem item : cart) {
            ProductVariant variant = item.getVariant();
            long price = (variant != null) ? variant.getPrice() : (item.getProduct() != null ? item.getProduct().getDisplayPrice() : 0);
            long discount = item.getProduct() != null && item.getProduct().getDiscount() != null ? item.getProduct().getDiscount() : 0L;
            cartTotal += (price * (100 - discount) / 100.0) * item.getQuantity();
        }

        String shippingAddress = request.getParameter("shippingAddress");
        String customerPhone = request.getParameter("phone");
        String note = request.getParameter("note");

        String districtIdParam = request.getParameter("districtId");
        String wardCode = request.getParameter("wardCode");
        Integer districtId = null;
        if (districtIdParam != null && !districtIdParam.trim().isEmpty()) {
            try {
                districtId = Integer.parseInt(districtIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        double shippingFee = 0.0;
        if (districtId != null && wardCode != null) {
            long fee = shippingService.calculateShippingFee(districtId, wardCode);
            shippingFee = (double) fee;
            System.out.println("[VNPAY-SHIPPING] UserId=" + user.getId() + " | DistrictId=" + districtId + " | WardCode=" + wardCode + " | Phi ship=" + shippingFee + " VND | Tong=" + (cartTotal + shippingFee) + " VND");
        } else {
            System.out.println("[VNPAY-SHIPPING] UserId=" + user.getId() + " | KHONG co districtId/WardCode -> Mien phi");
        }

        double total = cartTotal + shippingFee;

        String orderId = "ORDER_" + System.currentTimeMillis();

        session.setAttribute("vnp_order_id", orderId);
        session.setAttribute("vnp_total_amount", cartTotal);
        session.setAttribute("vnp_shipping_fee", shippingFee);
        session.setAttribute("vnp_cart", cart);
        session.setAttribute("vnp_user_id", user.getId());
        session.setAttribute("vnp_shipping_address", shippingAddress);
        session.setAttribute("vnp_customer_phone", customerPhone);
        session.setAttribute("vnp_note", note);
        session.setAttribute("vnp_district_id", districtId);
        session.setAttribute("vnp_ward_code", wardCode);

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
