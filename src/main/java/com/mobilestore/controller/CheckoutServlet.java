package com.mobilestore.controller;

import com.mobilestore.service.OrderService;
import com.mobilestore.service.CartService;
import com.mobilestore.service.ShippingService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.service.impl.ShippingServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.ProductVariant;
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
    private final ShippingService shippingService = new ShippingServiceImpl();

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

        double shippingCost = 0.0;
        if (user.getDistrictId() != null && user.getWardCode() != null) {
            long fee = shippingService.calculateShippingFee(user.getDistrictId(), user.getWardCode());
            shippingCost = (double) fee;
        }
        request.setAttribute("shippingCost", shippingCost);

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

        String shippingAddress = request.getParameter("shippingAddress");
        String customerPhone = request.getParameter("phone");
        String note = request.getParameter("note");

        String districtIdParam = request.getParameter("districtId");
        String wardCode = request.getParameter("wardCode");
        Integer districtId = null;
        if (districtIdParam != null && !districtIdParam.trim().isEmpty()) {
            try {
                districtId = Integer.parseInt(districtIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        long actualShippingFee = 0L;
        if (districtId != null && wardCode != null) {
            actualShippingFee = shippingService.calculateShippingFee(districtId, wardCode);
        }

        double cartTotal = 0.0;
        for (CartItem it : cart) {
            if (it == null || it.getProduct() == null) {
                continue;
            }
            ProductVariant variant = it.getVariant();
            long price = (variant != null && variant.getPrice() > 0) ? variant.getPrice() : it.getProduct().getDisplayPrice();
            long discount = it.getProduct().getDiscount() != null ? it.getProduct().getDiscount() : 0L;
            cartTotal += (price * (100 - discount) / 100.0) * it.getQuantity();
        }

        double total = cartTotal + actualShippingFee;

        Integer orderId = orderService.createOrder(
                user.getId(), cartTotal, cart,
                shippingAddress, customerPhone, note,
                (double) actualShippingFee, districtId, wardCode
        );

        if (orderId != null) {
            System.out.println("[ORDER-SHIPPING-COST] OrderId=" + orderId
                    + " | UserId=" + user.getId()
                    + " | DistrictId=" + districtId
                    + " | WardCode=" + wardCode
                    + " | PhiShipThucTe=" + (long) actualShippingFee + " VND"
                    + " | PhiShipUserTra=" + (long) actualShippingFee + " VND"
                    + " | TongTruocShip=" + (long) cartTotal + " VND"
                    + " | TongSauShip=" + (long) total + " VND");
            request.getSession().removeAttribute("cart");
            cartService.clearCartByUser(user.getId());
            response.sendRedirect(request.getContextPath() + "/order-confirmation?id=" + orderId);
        } else {
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
