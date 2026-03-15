package com.mobilestore.config;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPayConfig {
    
    public static String vnp_TmnCode = "J6JEUX7V";
    public static String vnp_HashSecret = "JXJUPG6Y7Z7SZYQ0S9LP3YXLQ7R3RP2H";
    public static String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:8080/mobilestore/vnpay_return.jsp";
    
    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] hash = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing data", e);
        }
    }
    
    public static String createPaymentUrl(long amount, String orderId, String orderInfo, String ipAddr) {
        Map<String, String> params = new TreeMap<>();
        params.put("vnp_Amount", String.valueOf(amount * 100));
        params.put("vnp_Command", "pay");
        params.put("vnp_CreateDate", new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_IpAddr", ipAddr);
        params.put("vnp_Locale", "vn");
        params.put("vnp_OrderInfo", orderInfo);
        params.put("vnp_OrderType", "billpayment");
        params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        params.put("vnp_TmnCode", vnp_TmnCode);
        params.put("vnp_TxnRef", orderId);
        params.put("vnp_Version", "2.1.0");
        
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
            query.append("=");
            query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
            query.append("&");
        }
        String queryString = query.toString().substring(0, query.length() - 1);
        
        String vnp_SecureHash = hmacSHA512(vnp_HashSecret, queryString);
        
        return vnp_Url + "?" + queryString + "&vnp_SecureHash=" + vnp_SecureHash;
    }
    
    public static boolean verifyReturnUrl(Map<String, String> params) {
        String vnp_SecureHash = params.get("vnp_SecureHash");
        if (vnp_SecureHash == null) return false;
        
        Map<String, String> sortedParams = new TreeMap<>(params);
        sortedParams.remove("vnp_SecureHash");
        
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> entry : sortedParams.entrySet()) {
            query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
            query.append("=");
            query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
            query.append("&");
        }
        String queryString = query.toString();
        if (queryString.endsWith("&")) {
            queryString = queryString.substring(0, queryString.length() - 1);
        }
        
        String secureHash = hmacSHA512(vnp_HashSecret, queryString);
        return secureHash.equalsIgnoreCase(vnp_SecureHash);
    }
}

