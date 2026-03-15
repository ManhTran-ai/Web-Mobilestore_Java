package com.mobilestore.controller.admin;

import com.mobilestore.service.OrderService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.entity.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders", "/admin/orders/*"})
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null || "/".equals(path)) {
            listOrders(request, response);
        } else if (path.equals("/view")) {
            viewOrder(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path != null && path.equals("/update")) {
            updateStatus(request, response);
        } else if (path != null && path.equals("/delete")) {
            deleteOrder(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Order> orders = orderService.findAll();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/views/admin/orders/order-list.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Order order = orderService.findById(id);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=not_found");
                return;
            }
            request.setAttribute("order", order);
            request.getRequestDispatcher("/views/admin/orders/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid_id");
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = orderService.updateStatus(id, status);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid_id");
        }
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = orderService.delete(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid_id");
        }
    }
}


