package com.mobilestore.service.impl;

import com.mobilestore.dao.AdminDashboardDAO;
import com.mobilestore.dto.AdminDashboardData;
import com.mobilestore.service.AdminDashboardService;

import java.util.Map;

public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();

    @Override
    public AdminDashboardData getDashboardData() {
        AdminDashboardData data = new AdminDashboardData();

        data.setNewUsers(dashboardDAO.countNewUsersThisMonth());
        data.setNewOrdersToday(dashboardDAO.countNewOrdersToday());
        data.setTotalOrders(dashboardDAO.countTotalOrders());

        data.setRevenueToday(dashboardDAO.revenueToday());
        data.setRevenueWeek(dashboardDAO.revenueWeek());
        data.setRevenueMonth(dashboardDAO.revenueMonth());
        data.setRevenueQuarter(dashboardDAO.revenueQuarter());
        data.setRevenueYear(dashboardDAO.revenueYear());

        Map<String, Integer> statusCounts = dashboardDAO.countOrdersByStatus();
        data.setPendingCount(statusCounts.getOrDefault("PENDING", 0));
        data.setProcessingCount(statusCounts.getOrDefault("PROCESSING", 0));
        data.setShippedCount(statusCounts.getOrDefault("SHIPPED", 0));
        data.setCompletedCount(statusCounts.getOrDefault("COMPLETED", 0));
        data.setCancelledCount(statusCounts.getOrDefault("CANCELLED", 0));

        data.setChartLabels(dashboardDAO.labelsLastNMonths(6));
        data.setChartValues(dashboardDAO.revenueLastNMonths(6));

        return data;
    }
}
