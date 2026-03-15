package com.mobilestore.controller;

import com.mobilestore.service.CartService;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "CartCountServlet", urlPatterns = {"/cart/count"})
public class CartCountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartService cartService = new CartServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        int count = 0;
        if (user != null) {
            List<CartItem> items = cartService.findByUserId(user.getId());
            if (items != null) {
                for (CartItem item : items) {
                    count += item.getQuantity();
                }
            }
        } else {
            Object o = request.getSession().getAttribute("cart");
            if (o instanceof java.util.List) {
                List<CartItem> items = (List<CartItem>) o;
                for (CartItem item : items) {
                    count += item.getQuantity();
                }
            }
        }

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"count\": " + count + "}");
        }
    }
}


