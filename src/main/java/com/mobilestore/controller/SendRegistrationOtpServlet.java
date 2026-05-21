package com.mobilestore.controller;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.service.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register/send-otp")
public class SendRegistrationOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final OtpService otpService = new OtpService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("[SEND-REG-OTP-SERVLET] ==============================");
        System.out.println("[SEND-REG-OTP-SERVLET] ACTION: Send OTP for Registration");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty()) {
            sendError(req, resp, "Tên đăng nhập không được để trống");
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            sendError(req, resp, "Email không được để trống");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            sendError(req, resp, "Mật khẩu không được để trống");
            return;
        }

        if (!password.equals(confirmPassword)) {
            sendError(req, resp, "Mật khẩu xác nhận không khớp");
            return;
        }

        username = username.trim();
        email = email.trim().toLowerCase();
        password = password.trim();

        if (username.length() < 3 || username.length() > 50) {
            sendError(req, resp, "Tên đăng nhập phải có từ 3 đến 50 ký tự");
            return;
        }

        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            sendError(req, resp, "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới");
            return;
        }

        if (password.length() < 6) {
            sendError(req, resp, "Mật khẩu phải có ít nhất 6 ký tự");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            sendError(req, resp, "Địa chỉ email không hợp lệ");
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            System.out.println("[SEND-REG-OTP-SERVLET] FAIL: Email already registered");
            sendError(req, resp, "Email này đã được sử dụng cho tài khoản khác. Vui lòng sử dụng email khác.");
            return;
        }

        if (userDAO.findByUsername(username) != null) {
            System.out.println("[SEND-REG-OTP-SERVLET] FAIL: Username already taken");
            sendError(req, resp, "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
            return;
        }

        OtpService.OtpGenerationResult result = otpService.generateAndSaveOtp(email);

        if (!result.success) {
            System.out.println("[SEND-REG-OTP-SERVLET] FAIL: " + result.errorMessage);
            sendError(req, resp, result.errorMessage);
            return;
        }

        otpService.sendOtpToEmail(email, result.otpCode);

        HttpSession session = req.getSession();
        session.setAttribute("regUsername", username);
        session.setAttribute("regEmail", email);
        session.setAttribute("regPassword", password);
        session.setAttribute("regOtpSent", true);
        session.setMaxInactiveInterval(10 * 60);

        System.out.println("[SEND-REG-OTP-SERVLET] OTP sent and session stored for: " + email);
        System.out.println("[SEND-REG-OTP-SERVLET] ==============================");

        resp.sendRedirect(req.getContextPath() + "/register/verify-otp");
    }

    private void sendError(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        req.setAttribute("username", req.getParameter("username"));
        req.setAttribute("email", req.getParameter("email"));
        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
    }
}
