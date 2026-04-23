package com.mobilestore.service.impl;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mobilestore.entity.ShippingStep;
import com.mobilestore.service.GHNService;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class GHNServiceImpl implements GHNService {

    private static final String GHN_API_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/detail";
    private static final String GHN_TOKEN = "fe8aeb73-2785-11f1-a973-aee5264794df";
    private static final String GHN_SHOP_ID = "199730";

    private final Gson gson = new Gson();

    @Override
    public List<ShippingStep> getShippingHistory(String trackingNumber) {
        if (trackingNumber == null || trackingNumber.isBlank()) {
            return Collections.emptyList();
        }

        JsonObject body = new JsonObject();
        body.addProperty("tracking_number", trackingNumber);

        try {
            URL url = URI.create(GHN_API_URL).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Token", GHN_TOKEN);
            conn.setRequestProperty("ShopId", GHN_SHOP_ID);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toString().getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("[GHN-Tracking] HTTP " + responseCode + " for tracking: " + trackingNumber);
                return Collections.emptyList();
            }

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            String resp = response.toString();
            JsonObject parsed = gson.fromJson(resp, JsonObject.class);

            if (parsed == null || !parsed.has("code")) {
                return Collections.emptyList();
            }

            int ghnCode = parsed.get("code").getAsInt();
            if (ghnCode != 200) {
                String message = parsed.has("message") ? parsed.get("message").getAsString() : "unknown";
                System.err.println("[GHN-Tracking] GHN code=" + ghnCode + " message=" + message);
                return Collections.emptyList();
            }

            if (!parsed.has("data")) {
                return Collections.emptyList();
            }

            JsonObject data = parsed.getAsJsonObject("data");
            if (!data.has("logs") || data.get("logs").isJsonNull()) {
                return Collections.emptyList();
            }

            JsonArray logs = data.getAsJsonArray("logs");
            List<ShippingStep> steps = new ArrayList<>();

            for (int i = 0; i < logs.size(); i++) {
                JsonObject log = logs.get(i).getAsJsonObject();
                ShippingStep step = new ShippingStep();

                if (log.has("status_name") && !log.get("status_name").isJsonNull()) {
                    step.setStatusName(log.get("status_name").getAsString());
                }
                if (log.has("status_description") && !log.get("status_description").isJsonNull()) {
                    step.setStatusDescription(log.get("status_description").getAsString());
                }
                if (log.has("updated_date") && !log.get("updated_date").isJsonNull()) {
                    String dateStr = log.get("updated_date").getAsString();
                    try {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        step.setUpdatedDate(sdf.parse(dateStr));
                    } catch (Exception e) {
                        try {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                            step.setUpdatedDate(sdf.parse(dateStr));
                        } catch (Exception ex) {
                            step.setUpdatedDate(new Date());
                        }
                    }
                } else {
                    step.setUpdatedDate(new Date());
                }

                steps.add(step);
            }

            return steps;

        } catch (Exception e) {
            System.err.println("[GHN-Tracking] Error fetching tracking: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
