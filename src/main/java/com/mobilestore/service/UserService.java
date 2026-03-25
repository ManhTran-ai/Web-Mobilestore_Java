package com.mobilestore.service;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.dao.UserLikeDAO;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.User;
import com.mobilestore.util.PasswordUtil;
import java.util.List;

public class UserService {
    private final UserDAO userDAO = new UserDAO();
    private final UserLikeDAO userLikeDAO = new UserLikeDAO();

    public User getById(Integer id) {
        return userDAO.findById(id);
    }

    public boolean updateProfile(User user) {
        return userDAO.updateProfile(user);
    }

    public boolean updatePassword(Integer userId, String newPlainPassword) {
        if (newPlainPassword == null || newPlainPassword.isBlank()) {
            return false;
        }
        String hashed = PasswordUtil.hashPassword(newPlainPassword);
        return userDAO.updatePassword(userId, hashed);
    }

    public List<Product> getLikedProducts(int userId) {
        return userLikeDAO.findLikedProductsByUser(userId);
    }

    public boolean removeFavorite(int userId, int productId) {
        return userLikeDAO.removeLike(userId, productId);
    }
}
