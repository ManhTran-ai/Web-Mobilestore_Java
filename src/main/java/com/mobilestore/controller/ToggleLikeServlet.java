package com.mobilestore.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.mobilestore.dao.UserLikeDAO;
import com.mobilestore.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/toggle-like")
public class ToggleLikeServlet extends HttpServlet {
    private final UserLikeDAO userLikeDAO = new UserLikeDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để sử dụng tính năng này!");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int customerId = user.getId();

            boolean isLiked = userLikeDAO.isLiked(customerId, productId);
            if (isLiked) {
                userLikeDAO.removeLike(customerId, productId);
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("action", "unliked");
                jsonResponse.addProperty("message", "Đã xóa khỏi danh sách yêu thích");
            } else {
                userLikeDAO.addLike(customerId, productId);
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("action", "liked");
                jsonResponse.addProperty("message", "Đã thêm vào danh sách yêu thích của bạn");
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
}
