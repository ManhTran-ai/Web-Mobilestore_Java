package com.mobilestore.controller;

import com.mobilestore.service.ProductService;
import com.mobilestore.service.CategoryService;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.service.impl.CategoryServiceImpl;
import com.mobilestore.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products", "/products/*"})
public class ProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.equals(contextPath + "/products/view")) {
            handleProductDetail(request, response);
            return;
        }

        int page = 1;
        int pageSize = 15;
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        String searchKeyword = request.getParameter("search");
        String categoryParam = request.getParameter("category");

        if (pageParam != null) {
            try { page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        }
        if (sizeParam != null) {
            try { pageSize = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}
        }

        ProductService productService = new ProductServiceImpl();
        CategoryService categoryService = new CategoryServiceImpl();

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Product> products;
        int totalItems;
        int totalPages;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            totalItems = productService.countSearch(searchKeyword.trim(), categoryId);
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.searchWithFilter(searchKeyword.trim(), categoryId, page, pageSize).getContent();

            request.setAttribute("searchKeyword", searchKeyword.trim());
        } else if (categoryId != null) {
            totalItems = productService.countSearch(null, categoryId);
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.searchWithFilter(null, categoryId, page, pageSize).getContent();
        } else {
            totalItems = productService.countAll();
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.findByPage(page, pageSize).getContent();
        }

        List<com.mobilestore.entity.Category> categories = categoryService.findAll();

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            com.mobilestore.entity.User user = (com.mobilestore.entity.User) session.getAttribute("user");
            com.mobilestore.dao.UserLikeDAO userLikeDAO = new com.mobilestore.dao.UserLikeDAO();
            List<Integer> likedProductIds = userLikeDAO.findLikedProductIdsByUser(user.getId());
            request.setAttribute("likedProductIds", likedProductIds);
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("/views/products/product-list.jsp").forward(request, response);
    }

    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số id sản phẩm");
            return;
        }

        try {
            Integer productId = Integer.parseInt(idParam.trim());
            ProductService productService = new ProductServiceImpl();
            Product product = productService.findById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
                return;
            }

            List<Product> relatedProducts = new ArrayList<>();
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                relatedProducts = productService.findByCategory(product.getCategory().getCategoryId())
                    .stream()
                    .filter(p -> !p.getProductId().equals(product.getProductId()))
                    .limit(7)
                    .toList();
            }

            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                com.mobilestore.entity.User user = (com.mobilestore.entity.User) session.getAttribute("user");
                com.mobilestore.dao.UserLikeDAO userLikeDAO = new com.mobilestore.dao.UserLikeDAO();
                List<Integer> likedProductIds = userLikeDAO.findLikedProductIdsByUser(user.getId());
                request.setAttribute("likedProductIds", likedProductIds);
            }

            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            request.getRequestDispatcher("/views/products/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
