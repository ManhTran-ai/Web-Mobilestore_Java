package com.mobilestore.constant;

public enum ProductSortOrder {
    DEFAULT("", "Mặc định"),
    PRICE_ASC("price_asc", "Giá: Thấp đến cao"),
    PRICE_DESC("price_desc", "Giá: Cao đến thấp");

    private final String code;
    private final String label;

    ProductSortOrder(String code, String label) {
        this.code = code;
        this.label = label;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    public static ProductSortOrder fromCode(String code) {
        if (code == null || code.isBlank()) {
            return DEFAULT;
        }
        for (ProductSortOrder order : values()) {
            if (order.code.equalsIgnoreCase(code)) {
                return order;
            }
        }
        return DEFAULT;
    }
}
