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
    private List<TopSellingProduct> topSellingProducts;
    private List<LowStockVariant> lowStockVariants;

    public static class TopSellingProduct {
        private int productId;
        private String productName;
        private String manufacturer;
        private int totalSold;

        public TopSellingProduct() {
        }

        public TopSellingProduct(int productId, String productName, String manufacturer, int totalSold) {
            this.productId = productId;
            this.productName = productName;
            this.manufacturer = manufacturer;
            this.totalSold = totalSold;
        }

        public int getProductId() {
            return productId;
        }

        public void setProductId(int productId) {
            this.productId = productId;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public String getManufacturer() {
            return manufacturer;
        }

        public void setManufacturer(String manufacturer) {
            this.manufacturer = manufacturer;
        }

        public int getTotalSold() {
            return totalSold;
        }

        public void setTotalSold(int totalSold) {
            this.totalSold = totalSold;
        }
    }

    public static class LowStockVariant {
        private int variantId;
        private int productId;
        private String productName;
        private String manufacturer;
        private String color;
        private String storage;
        private int quantityInStock;

        public LowStockVariant() {
        }

        public LowStockVariant(int variantId, int productId, String productName, String manufacturer,
                               String color, String storage, int quantityInStock) {
            this.variantId = variantId;
            this.productId = productId;
            this.productName = productName;
            this.manufacturer = manufacturer;
            this.color = color;
            this.storage = storage;
            this.quantityInStock = quantityInStock;
        }

        public int getVariantId() {
            return variantId;
        }

        public void setVariantId(int variantId) {
            this.variantId = variantId;
        }

        public int getProductId() {
            return productId;
        }

        public void setProductId(int productId) {
            this.productId = productId;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public String getManufacturer() {
            return manufacturer;
        }

        public void setManufacturer(String manufacturer) {
            this.manufacturer = manufacturer;
        }

        public String getColor() {
            return color;
        }

        public void setColor(String color) {
            this.color = color;
        }

        public String getStorage() {
            return storage;
        }

        public void setStorage(String storage) {
            this.storage = storage;
        }

        public int getQuantityInStock() {
            return quantityInStock;
        }

        public void setQuantityInStock(int quantityInStock) {
            this.quantityInStock = quantityInStock;
        }
    }

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

    public List<TopSellingProduct> getTopSellingProducts() {
        return topSellingProducts;
    }

    public void setTopSellingProducts(List<TopSellingProduct> topSellingProducts) {
        this.topSellingProducts = topSellingProducts;
    }

    public List<LowStockVariant> getLowStockVariants() {
        return lowStockVariants;
    }

    public void setLowStockVariants(List<LowStockVariant> lowStockVariants) {
        this.lowStockVariants = lowStockVariants;
    }
}
