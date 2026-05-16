package com.mobilestore.controller;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.User;
import com.mobilestore.service.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/send-otp")
public class SendOtpServlet extends HttpServlet {

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
        req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            req.setAttribute("errorMessage", "Email không hợp lệ.");
            req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();

        try {
            User user = userDAO.findByEmail(email);

            if (user != null) {
                String otpCode = otpService.generateAndSaveOtp(email);
                otpService.sendOtpToEmail(email, otpCode);
            }

            HttpSession session = req.getSession();
            session.setAttribute("otpEmail", email);
            session.setMaxInactiveInterval(10 * 60);

            resp.sendRedirect(req.getContextPath() + "/verify-otp");
            return;

        } catch (Exception e) {
            getServletContext().log("Lỗi khi gửi OTP: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
            return;
        }
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }
}
