package com.mobilestore.controller;

import com.mobilestore.service.PasswordResetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Token không hợp lệ");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!passwordResetService.isTokenValid(token)) {
            req.setAttribute("error", "Liên kết đặt lại mật khẩu đã hết hạn hoặc không hợp lệ");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "Token không hợp lệ");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            req.setAttribute("error", "Mật khẩu mới không được để trống");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!passwordResetService.isTokenValid(token)) {
            req.setAttribute("error", "Liên kết đặt lại mật khẩu đã hết hạn hoặc không hợp lệ");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        boolean success = passwordResetService.resetPassword(token, newPassword);

        if (success) {
            req.setAttribute("success", "Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập với mật khẩu mới.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
        }
    }
}
