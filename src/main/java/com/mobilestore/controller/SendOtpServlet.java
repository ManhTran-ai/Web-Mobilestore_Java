package com.mobilestore.controller;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.User;
import com.mobilestore.service.EmailService;
import com.mobilestore.service.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/send-otp")
public class SendOtpServlet extends HttpServlet {

    private OtpService otpService;
    private EmailService emailService;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.otpService = new OtpService();
        this.emailService = new EmailService();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/login-email.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            req.setAttribute("errorMessage", "Email không hợp lệ.");
            req.getRequestDispatcher("/views/auth/login-email.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();

        try {
            User user = userDAO.findByEmail(email);

            if (user == null) {
                req.setAttribute("errorMessage", "Email chưa được đăng ký. Vui lòng kiểm tra lại.");
                req.getRequestDispatcher("/views/auth/login-email.jsp").forward(req, resp);
                return;
            }

            String otpCode = otpService.generateAndSaveOtp(email);
            emailService.sendOtpEmail(email, otpCode);

            HttpSession session = req.getSession();
            session.setAttribute("otpEmail", email);
            session.setAttribute("otpSentAt", System.currentTimeMillis());
            session.setMaxInactiveInterval(10 * 60);

            resp.sendRedirect(req.getContextPath() + "/verify-otp");

        } catch (Exception e) {
            getServletContext().log("Lỗi khi gửi OTP: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/auth/login-email.jsp").forward(req, resp);
        }
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }
}
