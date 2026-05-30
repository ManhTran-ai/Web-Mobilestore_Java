package com.mobilestore.constant;

public enum ProductPriceRange {
    UNDER_5M("under_5m", "Dưới 5 triệu", null, 5_000_000L),
    FROM_5_TO_10M("5_10m", "5 - 10 triệu", 5_000_000L, 10_000_000L);

    private final String code;
    private final String label;
    private final Long minPrice;
    private final Long maxPrice;

    ProductPriceRange(String code, String label, Long minPrice, Long maxPrice) {
        this.code = code;
        this.label = label;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    public Long getMinPrice() {
        return minPrice;
    }

    public Long getMaxPrice() {
        return maxPrice;
    }

    public static ProductPriceRange fromCode(String code) {
        if (code == null || code.isBlank()) {
            return null;
        }
        for (ProductPriceRange range : values()) {
            if (range.code.equalsIgnoreCase(code)) {
                return range;
            }
        }
        return null;
    }
}
