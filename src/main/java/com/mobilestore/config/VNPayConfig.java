package com.mobilestore.config;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPayConfig {
    
    public static String vnp_TmnCode = "J6JEUX7V";
    public static String vnp_HashSecret = "JXJUPG6Y7Z7SZYQ0S9LP3YXLQ7R3RP2H";
    public static String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:8080/mobilestore/vnpay_return.jsp";
    
    public static String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

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

    public static String refund(String txnRef, String transactionNo, long amount, String ipAddr,
                               Date orderDate, String createBy) {
        try {
            if (transactionNo == null || transactionNo.isEmpty()) {
                System.err.println("[REFUND-ERROR] vnp_TransactionNo is null/empty - cannot refund without transaction reference");
                return null;
            }

            String createDateStr = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String transactionDateStr = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(orderDate);
            String requestId = String.valueOf(System.currentTimeMillis());

            String hashData = requestId
                    + "|" + "2.1.0"
                    + "|refund"
                    + "|" + vnp_TmnCode
                    + "|02"
                    + "|" + txnRef
                    + "|" + amount
                    + "|" + transactionNo
                    + "|" + transactionDateStr
                    + "|" + createBy
                    + "|" + createDateStr
                    + "|" + ipAddr
                    + "|" + "Hoan tien don hang " + txnRef;
            String vnp_SecureHash = hmacSHA512(vnp_HashSecret, hashData);

            String jsonBody = String.format(
                    "{"
                    + "\"vnp_RequestId\":\"%s\","
                    + "\"vnp_Version\":\"2.1.0\","
                    + "\"vnp_Command\":\"refund\","
                    + "\"vnp_TmnCode\":\"%s\","
                    + "\"vnp_TransactionType\":\"02\","
                    + "\"vnp_TxnRef\":\"%s\","
                    + "\"vnp_Amount\":%d,"
                    + "\"vnp_OrderInfo\":\"Hoan tien don hang %s\","
                    + "\"vnp_TransactionNo\":\"%s\","
                    + "\"vnp_TransactionDate\":\"%s\","
                    + "\"vnp_CreateBy\":\"%s\","
                    + "\"vnp_CreateDate\":\"%s\","
                    + "\"vnp_IpAddr\":\"%s\","
                    + "\"vnp_SecureHash\":\"%s\""
                    + "}",
                    requestId,
                    vnp_TmnCode,
                    txnRef,
                    amount,
                    txnRef,
                    transactionNo,
                    transactionDateStr,
                    createBy,
                    createDateStr,
                    ipAddr,
                    vnp_SecureHash
            );

            System.out.println("[REFUND-DEBUG] hashData=" + hashData);
            System.out.println("[REFUND-DEBUG] secureHash=" + vnp_SecureHash);
            System.out.println("[REFUND-REQUEST] body=" + jsonBody);

            URL url = URI.create(vnp_ApiUrl).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setRequestProperty("Content-Type", "application/json");
            byte[] postData = jsonBody.getBytes(StandardCharsets.UTF_8);
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(postData);
            }

            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                }
            } else {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                }
            }

            System.out.println("[REFUND-RESPONSE] httpCode=" + responseCode + " body=" + response);
            conn.disconnect();

            return response.toString();
        } catch (Exception e) {
            System.err.println("Loi goi API refund: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}

