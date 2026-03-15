package com.mobilestore.controller;

import com.mobilestore.service.PasswordResetService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ email");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        email = email.trim();

        String result = passwordResetService.requestPasswordReset(email, getServletContext());

        switch (result) {
            case "SUCCESS":
                req.setAttribute("success", "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư (bao gồm thư rác).");
                req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
                break;
            case "EMAIL_NOT_FOUND":
                req.setAttribute("error", "Email không tồn tại trong hệ thống");
                req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
                break;
            case "OAUTH_USER":
                req.setAttribute("error", "Tài khoản này được đăng nhập qua Google. Vui lòng đăng nhập bằng Google.");
                req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
                break;
            default:
                req.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
        }
    }
}
