package com.mobilestore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "HomeServlet", urlPatterns = {"/", "/home", "/index"})
public class HomeServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getRequestURI().substring(request.getContextPath().length());
        
        if (path.startsWith("/images/") || 
            path.startsWith("/css/") || 
            path.startsWith("/js/") ||
            path.startsWith("/assets/") ||
            (path.contains(".") && !path.endsWith(".jsp") && !path.endsWith(".html"))) {
            getServletContext().getNamedDispatcher("default").forward(request, response);
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        String action = request.getParameter("action");
        
        if (action != null) {
            switch (action) {
                case "about":
                    request.getRequestDispatcher("/views/common/about.jsp").forward(request, response);
                    return;
                case "contact":
                    request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);
                    return;
                default:
                    break;
            }
        }
        
        try {
            com.mobilestore.service.ProductService productService = new com.mobilestore.service.impl.ProductServiceImpl();

            int page = 1;
            int pageSize = 12;
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");
            if (pageParam != null) {
                try { page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
            }
            if (sizeParam != null) {
                try { pageSize = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}
            }

            int totalItems = productService.countAll();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            java.util.List<com.mobilestore.entity.Product> products = productService.findByPage(page, pageSize).getContent();

            request.setAttribute("products", products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalItems", totalItems);
        } catch (Exception e) {
            System.err.println("Lỗi khi load products trên homepage: " + e.getMessage());
        }
        request.getRequestDispatcher("/views/common/home.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
