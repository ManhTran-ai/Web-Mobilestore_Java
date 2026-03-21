package com.mobilestore.controller;

import com.mobilestore.service.OrderService;
import com.mobilestore.service.CartService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final OrderService orderService = new OrderServiceImpl();
    private final CartService cartService = new CartServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
            return;
        }
        
        List<CartItem> cart = null;
        Object cartObj = request.getSession().getAttribute("cart");
        if (cartObj instanceof List) {
            cart = (List<CartItem>) cartObj;
        }
        
        if (cart == null || cart.isEmpty()) {
            cart = cartService.findByUserId(user.getId());
            if (cart != null && !cart.isEmpty()) {
                request.getSession().setAttribute("cart", cart);
            }
        }
        
        if (cart == null) {
            cart = new java.util.ArrayList<>();
        }
        
        request.setAttribute("cartItems", cart);
        request.getRequestDispatcher("/views/products/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getContextPath() + "/checkout");
            return;
        }

        List<CartItem> cart = null;
        Object cartObj = request.getSession().getAttribute("cart");
        if (cartObj instanceof List) {
            cart = (List<CartItem>) cartObj;
        }
        
        if (cart == null || cart.isEmpty()) {
            cart = cartService.findByUserId(user.getId());
        }
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=Giỏ hàng trống");
            return;
        }
        
        double total = 0.0;
        for (CartItem it : cart) total += (it.getProduct().getPrice()*(100-it.getProduct().getDiscount())/100) * it.getQuantity();

        Integer orderId = orderService.createOrder(user.getId(), total, cart);
        if (orderId != null) {
            request.getSession().removeAttribute("cart");
            cartService.clearCartByUser(user.getId());
            response.sendRedirect(request.getContextPath() + "/products?success=order_placed&id=" + orderId);
        } else {
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
