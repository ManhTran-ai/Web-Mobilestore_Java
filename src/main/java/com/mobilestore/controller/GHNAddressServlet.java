package com.mobilestore.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "GHNAddressServlet", urlPatterns = {"/api/ghn/*"})
public class GHNAddressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String GHN_TOKEN = "fe8aeb73-2785-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "199730";
    private static final String GHN_BASE = "https://dev-online-gateway.ghn.vn/shiip/public-api";

    private static final String FROM_DISTRICT_ID = "1567";
    private static final String FROM_WARD_CODE = "550307";

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo.equals("/provinces")) {
            handleGetProvinces(response);
        } else if (pathInfo.equals("/districts")) {
            String provinceId = request.getParameter("province_id");
            handleGetDistricts(response, provinceId);
        } else if (pathInfo.equals("/wards")) {
            String districtId = request.getParameter("district_id");
            handleGetWards(response, districtId);
        } else {
            sendError(response, 404, "Endpoint not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo.equals("/calculate-fee")) {
            handleCalculateFee(request, response);
        } else {
            sendError(response, 404, "Endpoint not found");
        }
    }

    private void handleGetProvinces(HttpServletResponse response) throws IOException {
        String url = GHN_BASE + "/master-data/province";
        String ghnResp = callGHN("GET", url, null);

        JsonObject result = new JsonObject();
        if (ghnResp == null) {
            result.addProperty("success", false);
            result.addProperty("message", "Không thể kết nối GHN API");
        } else {
            JsonObject parsed = gson.fromJson(ghnResp, JsonObject.class);
            JsonArray provinces = parsed.getAsJsonArray("data");

            result.addProperty("success", true);
            result.add("data", provinces);
        }

        sendJson(response, result);
    }

    private void handleGetDistricts(HttpServletResponse response, String provinceId) throws IOException {
        JsonObject result = new JsonObject();

        if (provinceId == null || provinceId.isBlank()) {
            result.addProperty("success", false);
            result.addProperty("message", "Thiếu province_id");
            sendJson(response, result);
            return;
        }

        String url = GHN_BASE + "/master-data/district";
        Map<String, Object> body = new HashMap<>();
        body.put("province_id", Integer.parseInt(provinceId));

        String ghnResp = callGHN("POST", url, body);

        if (ghnResp == null) {
            result.addProperty("success", false);
            result.addProperty("message", "Không thể kết nối GHN API");
        } else {
            JsonObject parsed = gson.fromJson(ghnResp, JsonObject.class);
            JsonArray districts = parsed.getAsJsonArray("data");

            result.addProperty("success", true);
            result.add("data", districts);
        }

        sendJson(response, result);
    }

    private void handleGetWards(HttpServletResponse response, String districtId) throws IOException {
        JsonObject result = new JsonObject();

        if (districtId == null || districtId.isBlank()) {
            result.addProperty("success", false);
            result.addProperty("message", "Thiếu district_id");
            sendJson(response, result);
            return;
        }

        String url = GHN_BASE + "/master-data/ward?district_id=" + districtId;

        String ghnResp = callGHN("GET", url, null);

        if (ghnResp == null) {
            result.addProperty("success", false);
            result.addProperty("message", "Không thể kết nối GHN API");
        } else {
            JsonObject parsed = gson.fromJson(ghnResp, JsonObject.class);
            JsonArray wards = parsed.getAsJsonArray("data");

            result.addProperty("success", true);
            result.add("data", wards);
        }

        sendJson(response, result);
    }

    private void handleCalculateFee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        JsonObject body = gson.fromJson(sb.toString(), JsonObject.class);

        JsonObject result = new JsonObject();

        if (body == null || !body.has("to_district_id") || !body.has("to_ward_code")) {
            result.addProperty("success", false);
            result.addProperty("message", "Thiếu to_district_id hoặc to_ward_code");
            sendJson(response, result);
            return;
        }

        int toDistrictId = body.get("to_district_id").getAsInt();
        String toWardCode = body.get("to_ward_code").getAsString();

        Map<String, Object> ghnBody = new HashMap<>();
        ghnBody.put("from_district_id", Integer.parseInt(FROM_DISTRICT_ID));
        ghnBody.put("from_ward_code", FROM_WARD_CODE);
        ghnBody.put("service_type_id", 2);
        ghnBody.put("to_district_id", toDistrictId);
        ghnBody.put("to_ward_code", toWardCode);
        ghnBody.put("weight", 500);
        ghnBody.put("length", 20);
        ghnBody.put("width", 10);
        ghnBody.put("height", 10);

        String url = GHN_BASE + "/v2/shipping-order/fee";
        String ghnResp = callGHN("POST", url, ghnBody);

        if (ghnResp == null) {
            result.addProperty("success", false);
            result.addProperty("message", "Không thể kết nối GHN API");
        } else {
            JsonObject parsed = gson.fromJson(ghnResp, JsonObject.class);
            JsonObject data = parsed.getAsJsonObject("data");

            result.addProperty("success", true);
            if (data != null && data.has("total")) {
                result.addProperty("fee", data.get("total").getAsLong());
            } else {
                result.addProperty("fee", 0L);
            }
            result.addProperty("raw", ghnResp);
        }

        sendJson(response, result);
    }

    private String callGHN(String method, String urlStr, Map<String, Object> body) {
        try {
            URL url = URI.create(urlStr).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(method);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setRequestProperty("ShopId", GHN_SHOP_ID);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            if (body != null && ("POST".equals(method) || "PUT".equals(method))) {
                conn.setDoOutput(true);
                String json = toJson(body);
                try (OutputStream os = conn.getOutputStream()) {
                    os.write(json.getBytes(StandardCharsets.UTF_8));
                }
            }

            int code = conn.getResponseCode();
            if (code != 200) {
                System.err.println("[GHN] HTTP " + code + " for " + urlStr);
                return null;
            }

            StringBuilder resp = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    resp.append(line);
                }
            }
            return resp.toString();
        } catch (Exception e) {
            System.err.println("[GHN] Lỗi khi gọi GHN API: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private String toJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Object> e : map.entrySet()) {
            if (!first) sb.append(",");
            sb.append("\"").append(e.getKey()).append("\":");
            Object val = e.getValue();
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

    private void sendJson(HttpServletResponse response, JsonObject obj) throws IOException {
        response.getWriter().write(gson.toJson(obj));
    }

    private void sendError(HttpServletResponse response, int code, String message) throws IOException {
        response.setStatus(code);
        JsonObject obj = new JsonObject();
        obj.addProperty("success", false);
        obj.addProperty("message", message);
        sendJson(response, obj);
    }
}
