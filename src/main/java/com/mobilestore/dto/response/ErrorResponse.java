package com.mobilestore.dto.response;

import java.util.Map;

public class ErrorResponse {
    private int status;
    private String message;
    private String path;
    private long timestamp;
    private Map<String, String> validationErrors;

    public ErrorResponse() {
        this.timestamp = System.currentTimeMillis();
    }

    public ErrorResponse(int status, String message, String path) {
        this.status = status;
        this.message = message;
        this.path = path;
        this.timestamp = System.currentTimeMillis();
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, String> getValidationErrors() {
        return validationErrors;
    }

    public void setValidationErrors(Map<String, String> validationErrors) {
        this.validationErrors = validationErrors;
    }

    public String toJson() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"status\":").append(status).append(",");
        sb.append("\"message\":\"").append(message != null ? message.replace("\"", "\\\"") : "").append("\",");
        sb.append("\"path\":\"").append(path != null ? path.replace("\"", "\\\"") : "").append("\",");
        sb.append("\"timestamp\":").append(timestamp);
        if (validationErrors != null && !validationErrors.isEmpty()) {
            sb.append(",\"validationErrors\":{");
            boolean first = true;
            for (Map.Entry<String, String> entry : validationErrors.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue() != null ? entry.getValue().replace("\"", "\\\"") : "").append("\"");
                first = false;
            }
            sb.append("}");
        }
        sb.append("}");
        return sb.toString();
    }
}