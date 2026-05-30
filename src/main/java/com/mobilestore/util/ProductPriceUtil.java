package com.mobilestore.util;

import com.mobilestore.entity.Product;

public final class ProductPriceUtil {

    private ProductPriceUtil() {
    }

    public static long getEffectiveDisplayPrice(Product product) {
        if (product == null) {
            return 0L;
        }
        return product.getDisplayPrice();
    }

    public static boolean matchesPriceRange(Product product, Long minPrice, Long maxPrice) {
        if (minPrice == null && maxPrice == null) {
            return true;
        }
        long price = getEffectiveDisplayPrice(product);
        if (minPrice != null && price < minPrice) {
            return false;
        }
        if (maxPrice != null && price > maxPrice) {
            return false;
        }
        return true;
    }
}
