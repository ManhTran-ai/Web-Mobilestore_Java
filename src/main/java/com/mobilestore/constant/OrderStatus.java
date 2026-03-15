package com.mobilestore.constant;

public enum OrderStatus {
    PENDING("PENDING", "Chờ xác nhận"),
    PROCESSING("PROCESSING", "Đang xử lý"),
    SHIPPED("SHIPPED", "Đang giao hàng"),
    DELIVERED("DELIVERED", "Đã giao hàng"),
    CANCELLED("CANCELLED", "Đã hủy");

    private final String status;
    private final String description;

    OrderStatus(String status, String description) {
        this.status = status;
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public String getDescription() {
        return description;
    }

    public static OrderStatus fromStatus(String status) {
        for (OrderStatus orderStatus : values()) {
            if (orderStatus.status.equalsIgnoreCase(status)) {
                return orderStatus;
            }
        }
        return PENDING;
    }
}