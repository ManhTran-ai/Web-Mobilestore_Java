package com.mobilestore.controller;

import com.mobilestore.entity.Product;
import com.mobilestore.entity.User;
import com.mobilestore.entity.Order;
import com.mobilestore.service.UserService;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserService();
    private final OrderService orderService = new OrderServiceImpl();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\-\\s]{8,15}$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session != null ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User freshUser = userService.getById(sessionUser.getId());
        if (freshUser == null) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Product> favorites = userService.getLikedProducts(freshUser.getId());
        List<Order> userOrders = orderService.findByUserId(freshUser.getId());

        req.setAttribute("profileUser", freshUser);
        req.setAttribute("favoriteProducts", favorites);
        req.setAttribute("userOrders", userOrders);
        String activeTab = req.getParameter("tab");
        req.setAttribute("activeTab", activeTab != null ? activeTab : "info");
        req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session != null ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("removeFavorite".equals(action)) {
            handleRemoveFavorite(req, resp, sessionUser);
            return;
        }

        handleProfileUpdate(req, resp, session, sessionUser);
    }

    private void handleRemoveFavorite(HttpServletRequest req, HttpServletResponse resp, User sessionUser) throws ServletException, IOException {
        String productIdParam = req.getParameter("productId");
        Integer productId = null;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException ignored) {
        }

        if (productId != null) {
            boolean removed = userService.removeFavorite(sessionUser.getId(), productId);
            if (removed) {
                req.setAttribute("successMessage", "Đã xóa khỏi yêu thích");
            } else {
                req.setAttribute("errorMessage", "Không thể xóa sản phẩm khỏi danh sách yêu thích");
            }
        } else {
            req.setAttribute("errorMessage", "Sản phẩm không hợp lệ");
        }

        populateAndForward(req, resp, sessionUser, "favorites");
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User sessionUser) throws ServletException, IOException {
        List<String> errors = new ArrayList<>();

        String username = trimToNull(req.getParameter("username"));
        String email = trimToNull(req.getParameter("email"));
        String shippingAddress = trimToNull(req.getParameter("shippingAddress"));
        String customerPhone = trimToNull(req.getParameter("customerPhone"));
        String note = trimToNull(req.getParameter("note"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        String districtIdParam = trimToNull(req.getParameter("districtId"));
        String wardCode = trimToNull(req.getParameter("wardCode"));

        if (username == null || username.length() < 3) {
            errors.add("Họ tên cần ít nhất 3 ký tự");
        }

        if (email != null && !EMAIL_PATTERN.matcher(email).matches()) {
            errors.add("Email không hợp lệ");
        }

        if (customerPhone != null && !PHONE_PATTERN.matcher(customerPhone).matches()) {
            errors.add("Số điện thoại không hợp lệ");
        }

        boolean wantsPasswordChange = newPassword != null && !newPassword.trim().isEmpty();
        if (wantsPasswordChange) {
            if (newPassword.length() < 6) {
                errors.add("Mật khẩu mới phải từ 6 ký tự trở lên");
            }
            if (!newPassword.equals(confirmPassword)) {
                errors.add("Xác nhận mật khẩu không khớp");
            }
        }

        Integer districtId = null;
        if (districtIdParam != null && !districtIdParam.isBlank()) {
            try {
                districtId = Integer.parseInt(districtIdParam);
            } catch (NumberFormatException ignored) {
            }
        }

        User userFromDb = userService.getById(sessionUser.getId());
        if (userFromDb == null) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!errors.isEmpty()) {
            userFromDb.setUsername(username);
            userFromDb.setEmail(email);
            userFromDb.setShippingAddress(shippingAddress);
            userFromDb.setCustomerPhone(customerPhone);
            userFromDb.setNote(note);
            userFromDb.setDistrictId(districtId);
            userFromDb.setWardCode(wardCode);
            req.setAttribute("errorMessage", String.join(". ", errors));
            populateAndForward(req, resp, userFromDb, "info");
            return;
        }

        userFromDb.setUsername(username);
        userFromDb.setEmail(email);
        userFromDb.setShippingAddress(shippingAddress);
        userFromDb.setCustomerPhone(customerPhone);
        userFromDb.setNote(note);
        userFromDb.setDistrictId(districtId);
        userFromDb.setWardCode(wardCode);

        boolean profileUpdated = userService.updateProfile(userFromDb);
        boolean passwordUpdated = true;
        if (profileUpdated && wantsPasswordChange) {
            passwordUpdated = userService.updatePassword(userFromDb.getId(), newPassword);
        }

        if (profileUpdated && passwordUpdated) {
            User refreshed = userService.getById(userFromDb.getId());
            session.setAttribute("user", refreshed);
            req.setAttribute("successMessage", "Cập nhật hồ sơ thành công");
            populateAndForward(req, resp, refreshed, "info");
        } else {
            req.setAttribute("errorMessage", "Không thể cập nhật thông tin. Vui lòng thử lại.");
            populateAndForward(req, resp, userFromDb, "info");
        }
    }

    private void populateAndForward(HttpServletRequest req, HttpServletResponse resp, User user, String activeTab) throws ServletException, IOException {
        List<Product> favorites = userService.getLikedProducts(user.getId());
        List<Order> userOrders = orderService.findByUserId(user.getId());
        req.setAttribute("profileUser", user);
        req.setAttribute("favoriteProducts", favorites);
        req.setAttribute("userOrders", userOrders);
        req.setAttribute("activeTab", activeTab);
        req.getRequestDispatcher("/views/auth/profile.jsp").forward(req, resp);
    }

    private String trimToNull(String input) {
        if (input == null) return null;
        String value = input.trim();
        return value.isEmpty() ? null : value;
    }
}
