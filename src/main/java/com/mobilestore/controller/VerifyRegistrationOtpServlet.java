package com.mobilestore.controller;

import com.mobilestore.entity.User;
import com.mobilestore.service.AuthService;
import com.mobilestore.service.OtpService;
import com.mobilestore.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register/verify-otp")
public class VerifyRegistrationOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final OtpService otpService = new OtpService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null ||
            session.getAttribute("regUsername") == null ||
            session.getAttribute("regEmail") == null ||
            session.getAttribute("regPassword") == null ||
            !Boolean.TRUE.equals(session.getAttribute("regOtpSent"))) {

            System.out.println("[VERIFY-REG-OTP-SERVLET] No registration session data - redirecting");
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String email = (String) session.getAttribute("regEmail");
        String username = (String) session.getAttribute("regUsername");
        System.out.println("[VERIFY-REG-OTP-SERVLET] Session valid for: " + username + " / " + email);

        req.getRequestDispatcher("/views/auth/register-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null ||
            session.getAttribute("regUsername") == null ||
            session.getAttribute("regEmail") == null ||
            session.getAttribute("regPassword") == null ||
            !Boolean.TRUE.equals(session.getAttribute("regOtpSent"))) {

            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String username = (String) session.getAttribute("regUsername");
        String email = (String) session.getAttribute("regEmail");
        String password = (String) session.getAttribute("regPassword");

        String otpCode = req.getParameter("otpCode");

        if (otpCode == null || otpCode.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập mã OTP.");
            req.getRequestDispatcher("/views/auth/register-otp.jsp").forward(req, resp);
            return;
        }

        otpCode = otpCode.trim();

        OtpService.OtpValidationResult validationResult = otpService.validateOtp(email, otpCode);

        if (!validationResult.success) {
            System.out.println("[VERIFY-REG-OTP-SERVLET] OTP validation failed: " + validationResult.errorMessage);
            req.setAttribute("errorMessage", validationResult.errorMessage);
            req.getRequestDispatcher("/views/auth/register-otp.jsp").forward(req, resp);
            return;
        }

        if (authService.findByUsername(username) != null) {
            session.invalidate();
            req.setAttribute("error", "Tên đăng nhập đã được sử dụng. Vui lòng chọn tên khác.");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (authService.findByEmail(email) != null) {
            session.invalidate();
            req.setAttribute("error", "Email đã được sử dụng cho tài khoản khác. Vui lòng sử dụng email khác.");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(PasswordUtil.hashPassword(password));
        newUser.setRoleName("CUSTOMER");

        User createdUser = authService.create(newUser);

        if (createdUser != null) {
            session.removeAttribute("regUsername");
            session.removeAttribute("regEmail");
            session.removeAttribute("regPassword");
            session.removeAttribute("regOtpSent");

            System.out.println("[VERIFY-REG-OTP-SERVLET] User created: id=" + createdUser.getId() + ", username=" + createdUser.getUsername());

            session.setAttribute("user", createdUser);
            session.setAttribute("userId", createdUser.getId());
            session.setAttribute("userRole", createdUser.getRoleName());
            session.setMaxInactiveInterval(30 * 60);

            System.out.println("[VERIFY-REG-OTP-SERVLET] Auto-login success - redirecting to /register/success");
            resp.sendRedirect(req.getContextPath() + "/register/success");
        } else {
            req.setAttribute("errorMessage", "Đã xảy ra lỗi khi tạo tài khoản. Vui lòng thử lại.");
            req.getRequestDispatcher("/views/auth/register-otp.jsp").forward(req, resp);
        }
    }
}
