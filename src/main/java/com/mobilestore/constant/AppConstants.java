package com.mobilestore.constant;

import java.util.Set;

public class AppConstants {
    private AppConstants() {}
    
    public static final String UPLOAD_DIR = "images/products";
    public static final String UPLOAD_ROOT = "D:\\Web-Programming-MobileStore\\src\\main\\webapp";
    
    public static final long MAX_FILE_SIZE = 10 * 1024 * 1024;
    public static final int DEFAULT_PAGE_SIZE = 12;
    public static final int DEFAULT_PAGE_NUMBER = 1;
    
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    
    public static final String SESSION_USER = "user";
    public static final String SESSION_CART = "cart";
    
    public static final String PAYMENT_METHOD_CASH = "CASH";
    public static final String PAYMENT_METHOD_VNPAY = "VNPAY";
    
    public static final String PAYMENT_STATUS_PENDING = "PENDING";
    public static final String PAYMENT_STATUS_PAID = "PAID";
    public static final String PAYMENT_STATUS_FAILED = "FAILED";
    
    public static final Set<String> ALLOWED_IMAGE_EXTENSIONS = new java.util.HashSet<>(
        java.util.Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp")
    );
    
    public static final Set<String> ALLOWED_MIME_TYPES = new java.util.HashSet<>(
        java.util.Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp")
    );
}