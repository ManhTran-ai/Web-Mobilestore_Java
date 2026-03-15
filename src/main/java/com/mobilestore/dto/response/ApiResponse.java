package com.mobilestore.dto.response;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private LocalDateTime timestamp;
    private Map<String, Object> metadata;

    public ApiResponse() {
        this.timestamp = LocalDateTime.now();
    }

    public ApiResponse(boolean success, String message, T data) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.timestamp = LocalDateTime.now();
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "Success", data);
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, message, data);
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null);
    }

    public static <T> ApiResponse<T> error(String message, T data) {
        return new ApiResponse<>(false, message, data);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, Object> getMetadata() {
        return metadata;
    }

    public void setMetadata(Map<String, Object> metadata) {
        this.metadata = metadata;
    }

    public ApiResponse<T> addMetadata(String key, Object value) {
        if (this.metadata == null) {
            this.metadata = new HashMap<>();
        }
        this.metadata.put(key, value);
        return this;
    }

    public String toJson() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"success\":").append(success).append(",");
        sb.append("\"message\":\"").append(message != null ? message.replace("\"", "\\\"") : "").append("\",");
        if (data != null) {
            sb.append("\"data\":").append(toJsonValue(data)).append(",");
        } else {
            sb.append("\"data\":null,");
        }
        sb.append("\"timestamp\":\"").append(timestamp).append("\"");
        if (metadata != null && !metadata.isEmpty()) {
            sb.append(",\"metadata\":").append(toJsonValue(metadata));
        }
        sb.append("}");
        return sb.toString();
    }

    private String toJsonValue(Object obj) {
        if (obj == null) return "null";
        if (obj instanceof String) return "\"" + ((String) obj).replace("\"", "\\\"") + "\"";
        if (obj instanceof Number || obj instanceof Boolean) return obj.toString();
        if (obj instanceof Map) {
            StringBuilder sb = new StringBuilder("{");
            Map<?, ?> map = (Map<?, ?>) obj;
            boolean first = true;
            for (Map.Entry<?, ?> entry : map.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(entry.getKey()).append("\":").append(toJsonValue(entry.getValue()));
                first = false;
            }
            sb.append("}");
            return sb.toString();
        }
        if (obj instanceof Iterable) {
            StringBuilder sb = new StringBuilder("[");
            boolean first = true;
            for (Object item : (Iterable<?>) obj) {
                if (!first) sb.append(",");
                sb.append(toJsonValue(item));
                first = false;
            }
            sb.append("]");
            return sb.toString();
        }
        return "\"" + obj.toString().replace("\"", "\\\"") + "\"";
    }
}