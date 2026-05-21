package com.mobilestore.controller.admin;

import com.mobilestore.entity.Order;
import com.mobilestore.entity.User;
import com.mobilestore.service.EmailService;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.HashSet;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders", "/admin/orders/*"})
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> EMAIL_STATUSES;
    private final OrderService orderService;
    private final EmailService emailService;

    static {
        EMAIL_STATUSES = new HashSet<>();
        EMAIL_STATUSES.add("PROCESSING");
        EMAIL_STATUSES.add("SHIPPED");
        EMAIL_STATUSES.add("DELIVERED");
        EMAIL_STATUSES.add("CANCELLED");
    }

    public AdminOrderServlet() {
        this.orderService = new OrderServiceImpl();
        this.emailService = new EmailService();
    }

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
        String cancelReason = request.getParameter("cancelReason");

        try {
            int id = Integer.parseInt(idStr);
            Order order = orderService.findById(id);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=not_found");
                return;
            }

            boolean ok = orderService.updateStatus(id, status);

            if (ok && EMAIL_STATUSES.contains(status)) {
                sendOrderStatusEmail(order, status, cancelReason);
            }

            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid_id");
        }
    }

    private void sendOrderStatusEmail(Order order, String status, String cancelReason) {
        User user = order.getUser();
        if (user == null || user.getEmail() == null || user.getEmail().isBlank()) {
            System.out.println("[ADMIN-ORDER-SERVLET] No user email for order " + order.getOrderId() + " - skipping email");
            return;
        }

        String customerName = user.getUsername();
        String totalAmount = formatCurrency(order.getTotalAmount());
        String trackingNumber = order.getTrackingNumber();

        try {
            emailService.sendOrderStatusEmail(
                    user.getEmail(),
                    String.valueOf(order.getOrderId()),
                    status,
                    customerName,
                    totalAmount,
                    order.getShippingAddress(),
                    order.getPaymentMethod(),
                    cancelReason,
                    trackingNumber
            );
            System.out.println("[ADMIN-ORDER-SERVLET] Order status email queued for order " + order.getOrderId() + " to " + user.getEmail());
        } catch (Exception e) {
            System.err.println("[ADMIN-ORDER-SERVLET] Failed to send order status email for order " + order.getOrderId() + ": " + e.getMessage());
        }
    }

    private String formatCurrency(Double amount) {
        if (amount == null) return "0 ₫";
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return nf.format(amount);
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
