package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Product {
    private Integer productId;
    private String productName;
    private String manufacturer;
    private String productCondition;
    private String productInfo;
    private Category category;
    private Long discount;
    private List<ProductVariant> variants;

    public Long getDisplayPrice() {
        if (variants == null || variants.isEmpty()) {
            return 0L;
        }
        return variants.stream()
                .mapToLong(v -> v.getPrice() != null ? v.getPrice() : 0L)
                .min()
                .orElse(0L);
    }

    public Long getDisplayOriginalPrice() {
        Long displayPrice = getDisplayPrice();
        if (displayPrice == null || displayPrice == 0 || discount == null || discount == 0) {
            return displayPrice;
        }
        return Math.round(displayPrice * 100.0 / (100 - discount));
    }

    public String getDisplayImage() {
        if (variants != null && !variants.isEmpty()) {
            ProductVariant first = variants.get(0);
            if (first.getVariantImage() != null && !first.getVariantImage().isEmpty()) {
                return first.getVariantImage();
            }
        }
        return null;
    }

    public Integer getTotalStock() {
        if (variants == null || variants.isEmpty()) {
            return 0;
        }
        return variants.stream()
                .mapToInt(v -> v.getQuantityInStock() != null ? v.getQuantityInStock() : 0)
                .sum();
    }

    public boolean isInStock() {
        return getTotalStock() > 0;
    }
}
