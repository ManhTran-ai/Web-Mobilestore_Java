package com.mobilestore.service;

import com.mobilestore.dto.response.PageResponse;
import com.mobilestore.entity.Product;
import java.util.List;

public interface ProductService {
    List<Product> findAll();
    Product findById(Integer id);
    List<Product> findByCategory(Integer categoryId);
    List<Product> searchByName(String keyword);
    PageResponse<Product> findByPage(int page, int size, Long minPrice, Long maxPrice, String sortOrder);
    PageResponse<Product> searchWithFilter(String keyword, Integer categoryId, Long minPrice, Long maxPrice,
                                           String sortOrder, int page, int size);
    Product save(Product product);
    Product create(Product product);
    Product update(Product product);
    boolean delete(Integer id);
    int countAll(Long minPrice, Long maxPrice);
    int countSearch(String keyword, Integer categoryId, Long minPrice, Long maxPrice);
    Product findByUniqueKey(String productName, String manufacturer, String productCondition, Integer categoryId);

    List<Product> findSales(int i);
}