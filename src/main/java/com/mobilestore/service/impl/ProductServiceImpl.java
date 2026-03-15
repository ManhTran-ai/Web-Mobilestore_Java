package com.mobilestore.service.impl;

import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dto.response.PageResponse;
import com.mobilestore.entity.Product;
import com.mobilestore.service.ProductService;
import java.util.List;

public class ProductServiceImpl implements ProductService {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    public List<Product> findAll() {
        return productDAO.findAll();
    }

    @Override
    public Product findById(Integer id) {
        return productDAO.findById(id);
    }

    @Override
    public List<Product> findByCategory(Integer categoryId) {
        return productDAO.findByCategory(categoryId);
    }

    @Override
    public List<Product> searchByName(String keyword) {
        return productDAO.searchByName(keyword);
    }

    @Override
    public PageResponse<Product> findByPage(int page, int size) {
        int offset = (page - 1) * size;
        List<Product> products = productDAO.findPage(offset, size);
        int total = productDAO.countAll();
        return PageResponse.of(products, page, size, total);
    }

    @Override
    public PageResponse<Product> searchWithFilter(String keyword, Integer categoryId, int page, int size) {
        int offset = (page - 1) * size;
        List<Product> products = productDAO.searchWithFilter(keyword, categoryId, offset, size);
        int total = productDAO.countSearch(keyword, categoryId);
        return PageResponse.of(products, page, size, total);
    }

    @Override
    public Product save(Product product) {
        return productDAO.create(product);
    }

    @Override
    public Product create(Product product) {
        return productDAO.create(product);
    }

    @Override
    public Product update(Product product) {
        boolean updated = productDAO.update(product);
        return updated ? product : null;
    }

    @Override
    public boolean delete(Integer id) {
        return productDAO.delete(id);
    }

    @Override
    public int countAll() {
        return productDAO.countAll();
    }

    @Override
    public int countSearch(String keyword, Integer categoryId) {
        return productDAO.countSearch(keyword, categoryId);
    }

    @Override
    public Product findByUniqueKey(String productName, String manufacturer, String productCondition, Integer categoryId) {
        return productDAO.findByUniqueKey(productName, manufacturer, productCondition, categoryId);
    }
}