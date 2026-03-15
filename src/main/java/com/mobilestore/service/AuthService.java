package com.mobilestore.service;

import com.mobilestore.entity.User;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.util.PasswordUtil;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public User authenticate(String username, String passwordPlain) {
        User user = userDAO.findByUsername(username);
        if (user == null)
            return null;

        boolean matches = PasswordUtil.verifyPassword(passwordPlain, user.getPassword());
        return matches ? user : null;
    }

    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    public User create(User user) {
        return userDAO.create(user);
    }
}
