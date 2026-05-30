package com.mobilestore.service;

import com.mobilestore.entity.ProductVariant;
import java.util.List;

public interface ProductVariantService {
    List<ProductVariant> findByProductId(Integer productId);
    ProductVariant findById(Integer variantId);
    ProductVariant findByIdWithProduct(Integer variantId);
    boolean updateStock(Integer variantId, int quantityChange);
    boolean addStock(Integer variantId, int quantity);
    List<ProductVariant> findAllWithProduct();
    ProductVariant create(ProductVariant variant);
    boolean update(ProductVariant variant);
    boolean delete(Integer variantId);
    boolean deleteByProductId(Integer productId);
}
