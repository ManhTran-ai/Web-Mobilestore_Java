package com.mobilestore.service.impl;

import com.mobilestore.service.ShippingService;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class ShippingServiceImpl implements ShippingService {

    private static final String GHN_API_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee";
    private static final String GHN_TOKEN = "fe8aeb73-2785-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "199730";
    private static final int FROM_DISTRICT_ID = 1567;
    private static final String FROM_WARD_CODE = "550307";

    @Override
    public long calculateShippingFee(int toDistrictId, String toWardCode) {
        if (toDistrictId <= 0 || toWardCode == null || toWardCode.isBlank()) {
            return 0L;
        }

        Map<String, Object> body = new HashMap<>();
        body.put("from_district_id", FROM_DISTRICT_ID);
        body.put("from_ward_code", FROM_WARD_CODE);
        body.put("service_type_id", 2);
        body.put("to_district_id", toDistrictId);
        body.put("to_ward_code", toWardCode);
        body.put("weight", 500);
        body.put("length", 20);
        body.put("width", 10);
        body.put("height", 10);

        try {
            URL url = URI.create(GHN_API_URL).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setRequestProperty("ShopId", GHN_SHOP_ID);
            conn.setDoOutput(true);

            String jsonBody = toJson(body);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                StringBuilder response = new StringBuilder();
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                }

                String resp = response.toString();
                System.out.println("[GHN-DEBUG] toDistrict=" + toDistrictId + " | ward=" + toWardCode + " | Response: " + resp);

                int codeIdx = resp.indexOf("\"code\":");
                if (codeIdx != -1) {
                    int codeStart = codeIdx + 7;
                    int codeEnd = codeStart;
                    while (codeEnd < resp.length() && Character.isDigit(resp.charAt(codeEnd))) {
                        codeEnd++;
                    }
                    int ghnCode = Integer.parseInt(resp.substring(codeStart, codeEnd).trim());
                    if (ghnCode != 200) {
                        int msgIdx = resp.indexOf("\"message\":\"", codeIdx);
                        String message = "không rõ";
                        if (msgIdx != -1) {
                            int msgStart = msgIdx + 10;
                            int msgEnd = resp.indexOf("\"", msgStart);
                            message = msgEnd != -1 ? resp.substring(msgStart, msgEnd) : "không rõ";
                        }
                        System.err.println("[GHN-ERROR] code=" + ghnCode + " | message=" + message
                            + " | fromDistrict=" + FROM_DISTRICT_ID + " | toDistrict=" + toDistrictId + " | ward=" + toWardCode);
                        return 0L;
                    }
                }

                int dataIndex = resp.indexOf("\"data\":{");
                if (dataIndex != -1) {
                    int totalStart = resp.indexOf("\"total\":", dataIndex);
                    if (totalStart != -1) {
                        int valueStart = totalStart + 8;
                        int valueEnd = valueStart;
                        while (valueEnd < resp.length() && (Character.isDigit(resp.charAt(valueEnd)) || resp.charAt(valueEnd) == '.')) {
                            valueEnd++;
                        }
                        String totalStr = resp.substring(valueStart, valueEnd).trim();
                        return (long) Double.parseDouble(totalStr);
                    }
                }
            } else {
                System.err.println("GHN API lỗi HTTP: " + responseCode);
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        System.err.println("GHN Error Response: " + line);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi gọi GHN API: " + e.getMessage());
            e.printStackTrace();
        }

        return 0L;
    }

    private String toJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) sb.append(",");
            sb.append("\"").append(entry.getKey()).append("\":");
            Object val = entry.getValue();
            if (val instanceof String) {
                sb.append("\"").append(val).append("\"");
            } else if (val instanceof Integer) {
                sb.append(val);
            }
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }
}
