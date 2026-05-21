package com.mobilestore.constant;

public enum UserAccountStatus {
    ACTIVE("ACTIVE", "Hoạt động"),
    INACTIVE("INACTIVE", "Ngưng hoạt động"),
    DELETED("DELETED", "Đã xóa");

    private final String code;
    private final String label;

    UserAccountStatus(String code, String label) {
        this.code = code;
        this.label = label;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    public static UserAccountStatus fromCode(String code) {
        if (code == null || code.isBlank()) {
            return ACTIVE;
        }
        for (UserAccountStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        return ACTIVE;
    }
}
