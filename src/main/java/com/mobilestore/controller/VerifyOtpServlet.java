package com.mobilestore.controller;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.User;
import com.mobilestore.service.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private OtpService otpService;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.otpService = new OtpService();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otpEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/send-otp");
            return;
        }

        String email = (String) session.getAttribute("otpEmail");
        req.setAttribute("otpEmail", email);
        req.getRequestDispatcher("/views/auth/login-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otpEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/send-otp");
            return;
        }

        String email = (String) session.getAttribute("otpEmail");
        String otpCode = req.getParameter("otpCode");

        if (otpCode == null || otpCode.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập mã OTP.");
            req.getRequestDispatcher("/views/auth/login-otp.jsp").forward(req, resp);
            return;
        }

        otpCode = otpCode.trim();

        try {
            boolean isValid = otpService.validateOtp(email, otpCode);

            if (!isValid) {
                req.setAttribute("errorMessage",
                    "Mã OTP không đúng, đã hết hạn, hoặc đã dùng. Vui lòng thử lại.");
                req.getRequestDispatcher("/views/auth/login-otp.jsp").forward(req, resp);
                return;
            }

            User user = userDAO.findByEmail(email);
            if (user == null) {
                req.setAttribute("errorMessage", "Tài khoản không tồn tại.");
                req.getRequestDispatcher("/views/auth/login-email.jsp").forward(req, resp);
                return;
            }

            session.invalidate();
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("user", user);
            newSession.setAttribute("userId", user.getId());
            newSession.setAttribute("userRole", user.getRoleName());
            newSession.setMaxInactiveInterval(30 * 60);

            if ("ADMIN".equalsIgnoreCase(user.getRoleName())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
            return;

        } catch (Exception e) {
            getServletContext().log("Lỗi khi verify OTP: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/auth/login-otp.jsp").forward(req, resp);
        }
    }
}
