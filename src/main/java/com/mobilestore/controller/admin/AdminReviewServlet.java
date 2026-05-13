package com.mobilestore.controller.admin;

import com.mobilestore.entity.Review;
import com.mobilestore.service.ReviewService;
import com.mobilestore.service.impl.ReviewServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReviewServlet", urlPatterns = {"/admin/reviews", "/admin/reviews/*"})
public class AdminReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String path = request.getPathInfo();
        if (path == null || "/".equals(path)) {
            listReviews(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();
        if (path != null && path.equals("/approve")) {
            approveReview(request, response);
        } else if (path != null && path.equals("/reject")) {
            rejectReview(request, response);
        } else if (path != null && path.equals("/reply")) {
            replyReview(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Review> pendingReviews = reviewService.getPendingReviewsForAdmin();
        List<Review> allReviews = reviewService.getAllReviews();
        request.setAttribute("pendingReviews", pendingReviews);
        request.setAttribute("allReviews", allReviews);
        request.getRequestDispatcher("/views/admin/reviews/review-list.jsp").forward(request, response);
    }

    private void approveReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = reviewService.approveReview(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=approve_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=invalid_id");
        }
    }

    private void rejectReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = reviewService.rejectReview(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=reject_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=invalid_id");
        }
    }

    private void replyReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String adminReply = request.getParameter("adminReply");
        if (adminReply == null || adminReply.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=reply_empty");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            boolean ok = reviewService.replyReview(id, adminReply);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?success=replied");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reviews?error=reply_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?error=invalid_id");
        }
    }
}
