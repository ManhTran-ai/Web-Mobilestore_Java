package com.mobilestore.dto;

import java.util.List;

public class AdminDashboardData {

    private int newUsers;
    private int newOrdersToday;
    private int totalOrders;

    private double revenueToday;
    private double revenueWeek;
    private double revenueMonth;
    private double revenueQuarter;
    private double revenueYear;

    private int pendingCount;
    private int processingCount;
    private int shippedCount;
    private int completedCount;
    private int cancelledCount;

    private List<String> chartLabels;
    private List<Double> chartValues;

    public int getNewUsers() {
        return newUsers;
    }

    public void setNewUsers(int newUsers) {
        this.newUsers = newUsers;
    }

    public int getNewOrdersToday() {
        return newOrdersToday;
    }

    public void setNewOrdersToday(int newOrdersToday) {
        this.newOrdersToday = newOrdersToday;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getRevenueToday() {
        return revenueToday;
    }

    public void setRevenueToday(double revenueToday) {
        this.revenueToday = revenueToday;
    }

    public double getRevenueWeek() {
        return revenueWeek;
    }

    public void setRevenueWeek(double revenueWeek) {
        this.revenueWeek = revenueWeek;
    }

    public double getRevenueMonth() {
        return revenueMonth;
    }

    public void setRevenueMonth(double revenueMonth) {
        this.revenueMonth = revenueMonth;
    }

    public double getRevenueQuarter() {
        return revenueQuarter;
    }

    public void setRevenueQuarter(double revenueQuarter) {
        this.revenueQuarter = revenueQuarter;
    }

    public double getRevenueYear() {
        return revenueYear;
    }

    public void setRevenueYear(double revenueYear) {
        this.revenueYear = revenueYear;
    }

    public int getPendingCount() {
        return pendingCount;
    }

    public void setPendingCount(int pendingCount) {
        this.pendingCount = pendingCount;
    }

    public int getProcessingCount() {
        return processingCount;
    }

    public void setProcessingCount(int processingCount) {
        this.processingCount = processingCount;
    }

    public int getShippedCount() {
        return shippedCount;
    }

    public void setShippedCount(int shippedCount) {
        this.shippedCount = shippedCount;
    }

    public int getCompletedCount() {
        return completedCount;
    }

    public void setCompletedCount(int completedCount) {
        this.completedCount = completedCount;
    }

    public int getCancelledCount() {
        return cancelledCount;
    }

    public void setCancelledCount(int cancelledCount) {
        this.cancelledCount = cancelledCount;
    }

    public List<String> getChartLabels() {
        return chartLabels;
    }

    public void setChartLabels(List<String> chartLabels) {
        this.chartLabels = chartLabels;
    }

    public List<Double> getChartValues() {
        return chartValues;
    }

    public void setChartValues(List<Double> chartValues) {
        this.chartValues = chartValues;
    }
}
