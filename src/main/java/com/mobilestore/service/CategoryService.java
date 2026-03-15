package com.mobilestore.service;

import com.mobilestore.entity.Category;
import java.util.List;

public interface CategoryService {
    List<Category> findAll();
    Category findById(Integer id);
    Category findByName(String name);
    Category save(Category category);
    boolean update(Category category);
    boolean delete(Integer id);
}