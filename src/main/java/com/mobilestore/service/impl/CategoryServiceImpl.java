package com.mobilestore.service.impl;

import com.mobilestore.dao.CategoryDAO;
import com.mobilestore.entity.Category;
import com.mobilestore.service.CategoryService;
import java.util.List;

public class CategoryServiceImpl implements CategoryService {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public Category findById(Integer id) {
        return categoryDAO.findById(id);
    }

    @Override
    public Category findByName(String name) {
        return categoryDAO.findByName(name);
    }

    @Override
    public Category save(Category category) {
        return categoryDAO.create(category);
    }

    @Override
    public boolean update(Category category) {
        return categoryDAO.update(category);
    }

    @Override
    public boolean delete(Integer id) {
        return categoryDAO.delete(id);
    }
}