package com.mobilestore.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.mobilestore.entity.User;
import com.mobilestore.service.ReviewService;
import com.mobilestore.service.impl.ReviewServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/reviews")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ReviewService reviewService = new ReviewServiceImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        User user = getAuthUser(request, jsonResponse, out);
        if (user == null) return;

        try {
            String reviewIdParam = request.getParameter("reviewId");
            String ratingParam = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (reviewIdParam != null && !reviewIdParam.trim().isEmpty()) {
                int reviewId = Integer.parseInt(reviewIdParam.trim());
                int rating = parseRating(ratingParam);
                if (rating < 1 || rating > 5) {
                    jsonResponse.addProperty("status", "error");
                    jsonResponse.addProperty("message", "Số sao đánh giá không hợp lệ");
                    out.print(gson.toJson(jsonResponse));
                    return;
                }
                var review = reviewService.updateReview(reviewId, user.getId(), rating, comment);
                if (review != null) {
                    jsonResponse.addProperty("status", "success");
                    jsonResponse.addProperty("message", "Cập nhật đánh giá thành công!");
                } else {
                    jsonResponse.addProperty("status", "error");
                    jsonResponse.addProperty("message", "Không thể cập nhật đánh giá. Bạn chỉ có thể sửa đánh giá của mình.");
                }
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }

            String productIdParam = request.getParameter("productId");
            if (productIdParam == null || productIdParam.trim().isEmpty()) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Thiếu thông tin sản phẩm");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            int productId = Integer.parseInt(productIdParam.trim());
            int rating = parseRating(ratingParam);

            if (rating < 1 || rating > 5) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Số sao đánh giá không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            var review = reviewService.createReview(user.getId(), productId, rating, comment);
            if (review != null) {
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Bạn cần mua sản phẩm này trước khi đánh giá, hoặc đã đánh giá rồi!");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Có lỗi xảy ra, vui lòng thử lại sau!");
            e.printStackTrace();
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        User user = getAuthUser(request, jsonResponse, out);
        if (user == null) return;

        try {
            String reviewIdParam = request.getParameter("reviewId");
            String ratingParam = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (reviewIdParam == null || reviewIdParam.trim().isEmpty()) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Thiếu thông tin đánh giá");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            int reviewId = Integer.parseInt(reviewIdParam.trim());
            int rating = parseRating(ratingParam);

            if (rating < 1 || rating > 5) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Số sao đánh giá không hợp lệ");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            var review = reviewService.updateReview(reviewId, user.getId(), rating, comment);
            if (review != null) {
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Cập nhật đánh giá thành công!");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Không thể cập nhật đánh giá. Bạn chỉ có thể sửa đánh giá của mình.");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Có lỗi xảy ra, vui lòng thử lại sau!");
            e.printStackTrace();
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        User user = getAuthUser(request, jsonResponse, out);
        if (user == null) return;

        try {
            String reviewIdParam = request.getParameter("reviewId");

            if (reviewIdParam == null || reviewIdParam.trim().isEmpty()) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Thiếu thông tin đánh giá");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            int reviewId = Integer.parseInt(reviewIdParam.trim());
            boolean deleted = reviewService.deleteReview(reviewId, user.getId());

            if (deleted) {
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Xóa đánh giá thành công!");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Không thể xóa đánh giá. Bạn chỉ có thể xóa đánh giá của mình.");
            }
        } catch (NumberFormatException e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Có lỗi xảy ra, vui lòng thử lại sau!");
            e.printStackTrace();
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    private User getAuthUser(HttpServletRequest request, JsonObject jsonResponse, PrintWriter out) {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để thực hiện thao tác này!");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return null;
        }
        return user;
    }

    private int parseRating(String ratingParam) {
        if (ratingParam == null || ratingParam.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(ratingParam.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
