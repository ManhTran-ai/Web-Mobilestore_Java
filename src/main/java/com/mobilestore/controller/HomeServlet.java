package com.mobilestore.controller;

import com.mobilestore.dao.UserLikeDAO;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.SliderImage;
import com.mobilestore.entity.User;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.SliderImageService;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.service.impl.SliderImageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

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
            ProductService productService = new ProductServiceImpl();
            UserLikeDAO userLikeDAO = new UserLikeDAO();

            List<Product> products = productService.findByPage(1, 5).getContent();

            List<Product> saleProducts = productService.findSales(5);
            request.setAttribute("saleProducts", saleProducts);

            request.setAttribute("products", products);

            SliderImageService sliderService = new SliderImageServiceImpl();
            List<SliderImage> activeSliders = sliderService.findAllActive();
            request.setAttribute("activeSliders", activeSliders);

            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                List<Integer> likedProductIds = userLikeDAO.findLikedProductIdsByUser(user.getId());
                request.setAttribute("likedProductIds", likedProductIds);
            }

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
