package com.mobilestore.controller;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.User;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderConfirmationServlet", urlPatterns = "/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session != null ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String orderIdParam = req.getParameter("id");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/profile?tab=orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã đơn hàng không hợp lệ.");
            req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
            return;
        }

        Order order;
        try {
            order = orderService.findByIdAndUserId(orderId, sessionUser.getId());
        } catch (Exception e) {
            System.err.println("Lỗi khi tìm đơn hàng: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải thông tin đơn hàng. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
            return;
        }

        if (order == null) {
            req.setAttribute("error", "Không tìm thấy đơn hàng này.");
            req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
            return;
        }

        if (order.getOrderDate() == null) {
            order.setOrderDate(new java.util.Date());
        }
        if (order.getTotalAmount() == null) {
            double cartTotal = 0.0;
            if (order.getDetails() != null) {
                for (var d : order.getDetails()) {
                    cartTotal += (d.getPrice() != null ? d.getPrice() : 0.0) * d.getQuantity();
                }
            }
            order.setTotalAmount(cartTotal + (order.getShippingCost() != null ? order.getShippingCost() : 0.0));
        }
        if (order.getShippingCost() == null) {
            order.setShippingCost(0.0);
        }

        req.setAttribute("confirmedOrder", order);
        req.getRequestDispatcher("/views/auth/order-confirmation.jsp").forward(req, resp);
    }
}
