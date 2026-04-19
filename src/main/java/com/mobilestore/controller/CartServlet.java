package com.mobilestore.controller;

import com.mobilestore.service.CartService;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.ProductVariantService;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.service.impl.ProductVariantServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ProductService productService = new ProductServiceImpl();
    private final ProductVariantService variantService = new ProductVariantServiceImpl();
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
        if (cart == null) {
            cart = cartService.findByUserId(user.getId());
            request.getSession().setAttribute("cart", cart);
        }

        request.setAttribute("cartItems", cart);
        request.getRequestDispatcher("/views/products/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            String loginUrl = request.getContextPath() + "/login?redirect=" + request.getContextPath() + "/cart";
            String xreq = request.getHeader("X-Requested-With");
            if (xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().print("{\"redirect\":\"" + loginUrl + "\"}");
                return;
            } else {
                response.sendRedirect(loginUrl);
                return;
            }
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String variantIdStr = request.getParameter("variantId");
            String qtyStr = request.getParameter("quantity");
            int quantity = 1;
            try { quantity = Math.max(1, Integer.parseInt(qtyStr)); } catch (Exception ignored) {}
            try {
                int variantId = Integer.parseInt(variantIdStr);
                ProductVariant variant = variantService.findById(variantId);
                if (variant == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Phiên bản sản phẩm không tồn tại");
                    return;
                }

                Product product = variant.getProduct();
                if (product == null) {
                    product = productService.findById(variant.getProduct().getProductId());
                }

                List<CartItem> cart = null;
                Object cartObj2 = request.getSession().getAttribute("cart");
                if (cartObj2 instanceof List) {
                    cart = (List<CartItem>) cartObj2;
                }
                if (cart == null) {
                    cart = new ArrayList<>();
                    request.getSession().setAttribute("cart", cart);
                }

                boolean found = false;
                int currentQty = 0;
                for (CartItem item : cart) {
                    if (item.getVariant() != null && item.getVariant().getVariantId().equals(variantId)) {
                        currentQty = item.getQuantity();
                        found = true;
                        break;
                    }
                }
                int newQuantity = currentQty + quantity;

                if (variant.getQuantityInStock() < newQuantity) {
                    String msg;
                    if (variant.getQuantityInStock() <= 0) {
                        msg = "Sản phẩm đã hết hàng";
                    } else {
                        msg = "Chỉ còn " + variant.getQuantityInStock() + " sản phẩm trong kho";
                    }
                    String xreq = request.getHeader("X-Requested-With");
                    if (xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq)) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":false,\"message\":\"" + msg + "\"}");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/products?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                        return;
                    }
                }

                if (found) {
                    for (CartItem item : cart) {
                        if (item.getVariant() != null && item.getVariant().getVariantId().equals(variantId)) {
                            item.setQuantity(newQuantity);
                            break;
                        }
                    }
                } else {
                    cart.add(new CartItem(product, variant, newQuantity));
                }

                cartService.upsertCartItem(user.getId(), variantId, newQuantity);

                int totalQty = 0;
                for (CartItem it : cart) totalQty += it.getQuantity();

                String xreq = request.getHeader("X-Requested-With");
                if (xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq)) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":true, \"count\":" + totalQty + "}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                String xreq = request.getHeader("X-Requested-With");
                if (xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq)) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi thêm vào giỏ");
                    return;
                }
            }
        } else if ("remove".equals(action)) {
            String idxStr = request.getParameter("index");
            String xreq = request.getHeader("X-Requested-With");
            boolean isAjax = xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq);
            try {
                int idx = Integer.parseInt(idxStr);
                List<CartItem> cart = null;
                Object cartObj3 = request.getSession().getAttribute("cart");
                if (cartObj3 instanceof List) {
                    cart = (List<CartItem>) cartObj3;
                }
                if (cart != null && idx >=0 && idx < cart.size()) {
                    CartItem removedItem = cart.get(idx);
                    Integer variantId = removedItem.getVariant() != null ? removedItem.getVariant().getVariantId() : null;
                    cart.remove(idx);
                    if (variantId != null) {
                        cartService.deleteCartItem(user.getId(), variantId);
                    }
                    int cartTotal = 0;
                    for (CartItem item : cart) {
                        long price = item.getVariant() != null ? item.getVariant().getPrice() : 0;
                        long discount = item.getProduct() != null ? item.getProduct().getDiscount() : 0;
                        cartTotal += (long)(price * (100 - discount) / 100.0) * item.getQuantity();
                    }

                    if (isAjax) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":true,\"cartTotal\":" + cartTotal + ",\"itemCount\":" + cart.size() + "}");
                        return;
                    }
                }
            } catch (Exception e) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        } else if ("clear".equals(action)) {
            String xreq = request.getHeader("X-Requested-With");
            boolean isAjax = xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq);

            try {
                cartService.clearCartByUser(user.getId());
                request.getSession().removeAttribute("cart");

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":true,\"count\":0}");
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Lỗi khi xóa giỏ hàng\"}");
                    return;
                }
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xóa giỏ hàng");
                return;
            }
        } else if ("update".equals(action)) {
            String idxStr = request.getParameter("index");
            String qtyStr = request.getParameter("quantity");
            String xreq = request.getHeader("X-Requested-With");
            boolean isAjax = xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq);

            if (idxStr == null || qtyStr == null) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Thiếu thông tin cập nhật\"}");
                    return;
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart?error=Thiếu thông tin cập nhật");
                    return;
                }
            }

            try {
                int idx = Integer.parseInt(idxStr);
                int qty = Math.max(1, Integer.parseInt(qtyStr));

                List<CartItem> cart = null;
                Object cartObj4 = request.getSession().getAttribute("cart");
                if (cartObj4 instanceof List) {
                    cart = (List<CartItem>) cartObj4;
                }

                if (cart == null || cart.isEmpty()) {
                    cart = cartService.findByUserId(user.getId());
                    if (cart != null && !cart.isEmpty()) {
                        request.getSession().setAttribute("cart", cart);
                    }
                }

                if (cart == null || cart.isEmpty()) {
                    if (isAjax) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":false,\"message\":\"Giỏ hàng trống\"}");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart?error=Giỏ hàng trống");
                        return;
                    }
                }

                if (idx < 0 || idx >= cart.size()) {
                    if (isAjax) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":false,\"message\":\"Sản phẩm không tồn tại trong giỏ hàng\"}");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart?error=Sản phẩm không tồn tại");
                        return;
                    }
                }

                CartItem itemToUpdate = cart.get(idx);
                ProductVariant variant = itemToUpdate.getVariant();
                Integer variantId = variant != null ? variant.getVariantId() : null;

                if (variantId != null) {
                    ProductVariant freshVariant = variantService.findById(variantId);
                    if (freshVariant != null && freshVariant.getQuantityInStock() < qty) {
                        String msg;
                        if (freshVariant.getQuantityInStock() <= 0) msg = "Sản phẩm đã hết hàng";
                        else msg = "Chỉ còn " + freshVariant.getQuantityInStock() + " sản phẩm trong kho";
                        if (isAjax) {
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            response.setContentType("application/json;charset=UTF-8");
                            response.getWriter().print("{\"success\":false,\"message\":\"" + msg + "\",\"maxStock\":" + freshVariant.getQuantityInStock() + "}");
                            return;
                        } else {
                            response.sendRedirect(request.getContextPath() + "/cart?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                            return;
                        }
                    }
                    cart.get(idx).setQuantity(qty);
                    cartService.upsertCartItem(user.getId(), variantId, qty);
                } else {
                    cart.get(idx).setQuantity(qty);
                }

                request.getSession().setAttribute("cart", cart);

                long price = variant != null ? variant.getPrice() : 0;
                long discount = itemToUpdate.getProduct() != null ? itemToUpdate.getProduct().getDiscount() : 0;
                double itemTotal = (price * (100 - discount) / 100.0) * qty;
                double cartTotal = 0;
                for (CartItem item : cart) {
                    long vp = item.getVariant() != null ? item.getVariant().getPrice() : 0;
                    long vd = item.getProduct() != null ? item.getProduct().getDiscount() : 0;
                    cartTotal += (vp * (100 - vd) / 100.0) * item.getQuantity();
                }

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":true,\"itemTotal\":" + itemTotal + ",\"cartTotal\":" + (long)cartTotal + "}");
                    return;
                }
            } catch (NumberFormatException e) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Dữ liệu không hợp lệ\"}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Lỗi server: " + e.getMessage() + "\"}");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
