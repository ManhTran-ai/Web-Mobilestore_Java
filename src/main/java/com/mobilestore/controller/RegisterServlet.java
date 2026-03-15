package com.mobilestore.controller;

import com.mobilestore.entity.User;
import com.mobilestore.service.AuthService;
import com.mobilestore.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
    }

    private static final java.util.regex.Pattern EMAIL_PATTERN = java.util.regex.Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("error", "Tên đăng nhập không được để trống");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email không được để trống");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }
        email = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            req.setAttribute("error", "Địa chỉ email không hợp lệ");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }
        if (authService.findByEmail(email) != null) {
            req.setAttribute("error", "Email này đã được sử dụng cho tài khoản khác");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Mật khẩu không được để trống");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (authService.findByUsername(username) != null) {
            req.setAttribute("error", "Tên đăng nhập đã tồn tại");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setEmail(email);

        String hashedPassword = PasswordUtil.hashPassword(password);
        newUser.setPassword(hashedPassword);

        newUser.setRoleName("CUSTOMER");

        User createdUser = authService.create(newUser);
        
        if (createdUser != null) {
            req.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Đã xảy ra lỗi khi đăng ký. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
        }
    }
}
