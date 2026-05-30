package com.mobilestore.controller.admin;

import com.mobilestore.entity.ProductVariant;
import com.mobilestore.entity.User;
import com.mobilestore.service.OrderService;
import com.mobilestore.service.ProductVariantService;
import com.mobilestore.service.impl.OrderServiceImpl;
import com.mobilestore.service.impl.ProductVariantServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminInventoryServlet", urlPatterns = {"/admin/inventory"})
public class AdminInventoryServlet extends HttpServlet {
    private final ProductVariantService variantService = new ProductVariantServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        if (!"ADMIN".equals(currentUser.getRoleName()) && !"INVENTORY_MANAGER".equals(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/?error=access_denied");
            return;
        }

        List<ProductVariant> variants = variantService.findAllWithProduct();
        request.setAttribute("variants", variants);
        request.setAttribute("activeMenu", "inventory");
        request.getRequestDispatcher("/views/admin/inventory/inventory-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        if (!"ADMIN".equals(currentUser.getRoleName()) && !"INVENTORY_MANAGER".equals(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/?error=access_denied");
            return;
        }

        String action = request.getParameter("action");
        String variantIdStr = request.getParameter("variantId");

        if (variantIdStr == null || variantIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_variant");
            return;
        }

        int variantId;
        try {
            variantId = Integer.parseInt(variantIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_variant");
            return;
        }

        if ("import".equals(action)) {
            handleImport(request, response, variantId);
        } else if ("export".equals(action)) {
            handleExport(request, response, variantId);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_action");
        }
    }

    private void handleImport(HttpServletRequest request, HttpServletResponse response, int variantId)
            throws IOException {
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null || quantityStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=missing_quantity");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_quantity");
            return;
        }

        boolean success = variantService.addStock(variantId, quantity);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?success=imported");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=import_failed");
        }
    }

    private void handleExport(HttpServletRequest request, HttpServletResponse response, int variantId)
            throws IOException {
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");
        String customerPhone = request.getParameter("customerPhone");
        String note = request.getParameter("note");

        if (quantityStr == null || quantityStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=missing_quantity");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_quantity");
            return;
        }

        long price = 0;
        if (priceStr != null && !priceStr.isBlank()) {
            try {
                price = Long.parseLong(priceStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/inventory?error=invalid_price");
                return;
            }
        }

        Integer orderId = orderService.createOfflineOrder(variantId, quantity, price, customerPhone, note);
        if (orderId != null) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?success=exported");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/inventory?error=export_failed");
        }
    }
}
