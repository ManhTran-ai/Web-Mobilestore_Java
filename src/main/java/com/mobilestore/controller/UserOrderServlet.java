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

@WebServlet(name = "UserOrderServlet", urlPatterns = "/my-orders")
public class UserOrderServlet extends HttpServlet {

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
            resp.sendRedirect(req.getContextPath() + "/profile?tab=orders");
            return;
        }

        Order order = orderService.findByIdAndUserId(orderId, sessionUser.getId());
        if (order == null) {
            resp.sendRedirect(req.getContextPath() + "/profile?tab=orders");
            return;
        }

        req.setAttribute("userOrder", order);
        req.getRequestDispatcher("/views/auth/order-detail.jsp").forward(req, resp);
    }
}
