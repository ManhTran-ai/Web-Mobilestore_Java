package com.mobilestore.controller;

import com.mobilestore.service.CartService;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.impl.CartServiceImpl;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.entity.CartItem;
import com.mobilestore.entity.Product;
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
            String idStr = request.getParameter("productId");
            String qtyStr = request.getParameter("quantity");
            int quantity = 1;
            try { quantity = Math.max(1, Integer.parseInt(qtyStr)); } catch (Exception ignored) {}
            try {
                int productId = Integer.parseInt(idStr);
                Product product = productService.findById(productId);
                if (product != null) {
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
                        if (item.getProduct().getProductId().equals(product.getProductId())) {
                            currentQty = item.getQuantity();
                            found = true;
                            break;
                        }
                    }
                    int newQuantity = currentQty + quantity;

                    if (product.getQuantityInStock() < newQuantity) {
                        String msg;
                        if (product.getQuantityInStock() <= 0) {
                            msg = "Sản phẩm đã hết hàng";
                        } else {
                            msg = "Chỉ còn " + product.getQuantityInStock() + " sản phẩm trong kho";
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
                            if (item.getProduct().getProductId().equals(product.getProductId())) {
                                item.setQuantity(newQuantity);
                                break;
                            }
                        }
                    } else {
                        cart.add(new CartItem(product, newQuantity));
                    }

                    cartService.upsertCartItem(user.getId(), product.getProductId(), newQuantity);

                    int totalQty = 0;
                    for (CartItem it : cart) totalQty += it.getQuantity();

                    String xreq = request.getHeader("X-Requested-With");
                    if (xreq != null && "XMLHttpRequest".equalsIgnoreCase(xreq)) {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":true, \"count\":" + totalQty + "}");
                        return;
                    }
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
                    int productId = cart.get(idx).getProduct().getProductId();
                    cart.remove(idx);
                    cartService.deleteCartItem(user.getId(), productId);
                    int cartTotal = 0;
                    for (CartItem item : cart) {
                        cartTotal += (item.getProduct().getPrice()*(100-item.getProduct().getDiscount())/100) * item.getQuantity();
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

                int productId = cart.get(idx).getProduct().getProductId();
                Product fresh = productService.findById(productId);
                if (fresh != null && fresh.getQuantityInStock() < qty) {
                    String msg;
                    if (fresh.getQuantityInStock() <= 0) msg = "Sß║ún phß║⌐m ─æ├ú hß║┐t h├áng";
                    else msg = "Chß╗ë c├▓n " + fresh.getQuantityInStock() + " sß║ún phß║⌐m trong kho";
                    if (isAjax) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().print("{\"success\":false,\"message\":\"" + msg + "\",\"maxStock\":" + fresh.getQuantityInStock() + "}");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                        return;
                    }
                }
                cart.get(idx).setQuantity(qty);
                cartService.upsertCartItem(user.getId(), productId, qty);

                request.getSession().setAttribute("cart", cart);

                double cartTotal = 0;
                double itemTotal = (cart.get(idx).getProduct().getPrice()*(100-cart.get(idx).getProduct().getDiscount())/100) * qty;
                for (CartItem item : cart) {
                    cartTotal += (item.getProduct().getPrice()*(100-item.getProduct().getDiscount())/100) * item.getQuantity();
                }

                if (isAjax) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":true,\"itemTotal\":" + itemTotal + ",\"cartTotal\":" + cartTotal + "}");
                    return;
                }
            } catch (NumberFormatException e) {
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Dß╗» liß╗çu kh├┤ng hß╗úp lß╗ç\"}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().print("{\"success\":false,\"message\":\"Lß╗ùi server: " + e.getMessage() + "\"}");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
