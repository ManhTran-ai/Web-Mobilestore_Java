package com.mobilestore.service.impl;

import com.mobilestore.dao.ProductVariantDAO;
import com.mobilestore.entity.ProductVariant;
import com.mobilestore.service.ProductVariantService;
import java.util.List;

public class ProductVariantServiceImpl implements ProductVariantService {
    private final ProductVariantDAO variantDAO = new ProductVariantDAO();

    @Override
    public List<ProductVariant> findByProductId(Integer productId) {
        return variantDAO.findByProductId(productId);
    }

    @Override
    public ProductVariant findById(Integer variantId) {
        return variantDAO.findById(variantId);
    }

    @Override
    public ProductVariant findByIdWithProduct(Integer variantId) {
        return variantDAO.findByIdWithProduct(variantId);
    }

    @Override
    public boolean updateStock(Integer variantId, int quantityChange) {
        return variantDAO.updateStock(variantId, quantityChange);
    }

    @Override
    public ProductVariant create(ProductVariant variant) {
        return variantDAO.create(variant);
    }

    @Override
    public boolean update(ProductVariant variant) {
        return variantDAO.update(variant);
    }

    @Override
    public boolean delete(Integer variantId) {
        return variantDAO.delete(variantId);
    }

    @Override
    public boolean deleteByProductId(Integer productId) {
        return variantDAO.deleteByProductId(productId);
    }
}
