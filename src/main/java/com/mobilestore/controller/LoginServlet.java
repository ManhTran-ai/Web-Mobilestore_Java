package com.mobilestore.controller;

import com.mobilestore.entity.User;
import com.mobilestore.service.AuthService;
import com.mobilestore.service.GoogleOAuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    private final GoogleOAuthService googleOAuthService = new GoogleOAuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idToken = req.getParameter("id_token");
        
        if (idToken != null && !idToken.isEmpty()) {
            User user = googleOAuthService.verifyAndGetUser(idToken);
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            } else {
                req.setAttribute("error", "Đăng nhập Google thất bại");
                req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
                return;
            }
        }
        
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = authService.authenticate(username, password);
        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/");
        } else {
            req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
