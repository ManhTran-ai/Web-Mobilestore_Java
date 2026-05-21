package com.mobilestore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register/success")
public class RegisterSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[REGISTER-SUCCESS-SERVLET] Guard fail: no user in session, redirecting to home");
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        System.out.println("[REGISTER-SUCCESS-SERVLET] User already logged in, showing success page");
        req.getRequestDispatcher("/views/auth/register-success.jsp").forward(req, resp);
    }
}
