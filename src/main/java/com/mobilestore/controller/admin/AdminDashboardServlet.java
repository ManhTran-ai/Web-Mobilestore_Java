package com.mobilestore.controller.admin;

import com.mobilestore.dto.AdminDashboardData;
import com.mobilestore.service.AdminDashboardService;
import com.mobilestore.service.impl.AdminDashboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/dashboard/*"})
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AdminDashboardService dashboardService = new AdminDashboardServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        AdminDashboardData data = dashboardService.getDashboardData();

        request.setAttribute("newUsers", data.getNewUsers());
        request.setAttribute("newOrdersToday", data.getNewOrdersToday());
        request.setAttribute("totalOrders", data.getTotalOrders());

        request.setAttribute("revenueToday", data.getRevenueToday());
        request.setAttribute("revenueWeek", data.getRevenueWeek());
        request.setAttribute("revenueMonth", data.getRevenueMonth());
        request.setAttribute("revenueQuarter", data.getRevenueQuarter());
        request.setAttribute("revenueYear", data.getRevenueYear());

        request.setAttribute("pendingCount", data.getPendingCount());
        request.setAttribute("processingCount", data.getProcessingCount());
        request.setAttribute("shippedCount", data.getShippedCount());
        request.setAttribute("completedCount", data.getCompletedCount());
        request.setAttribute("cancelledCount", data.getCancelledCount());

        request.setAttribute("chartLabels", data.getChartLabels());
        request.setAttribute("chartValues", data.getChartValues());

        request.getRequestDispatcher("/views/admin/dashboard/dashboard.jsp").forward(request, response);
    }
}
