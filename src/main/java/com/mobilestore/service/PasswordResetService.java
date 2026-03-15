package com.mobilestore.service;

import com.mobilestore.dao.PasswordResetTokenDAO;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.PasswordResetToken;
import com.mobilestore.entity.User;
import com.mobilestore.util.PasswordUtil;
import jakarta.servlet.ServletContext;
import java.time.LocalDateTime;

public class PasswordResetService {

    private final UserDAO userDAO = new UserDAO();
    private final PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
    private final EmailService emailService = new EmailService();

    private static final int TOKEN_EXPIRATION_MINUTES = 30;

    public String requestPasswordReset(String email, ServletContext context) {
        User user = userDAO.findByEmail(email);

        if (user == null) {
            return "EMAIL_NOT_FOUND";
        }

        if (user.getOauthProvider() != null && !user.getOauthProvider().isEmpty()) {
            return "OAUTH_USER";
        }

        tokenDAO.deleteByUserId(user.getId());

        String token = emailService.generateResetToken();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(TOKEN_EXPIRATION_MINUTES);

        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setToken(token);
        resetToken.setUserId(user.getId());
        resetToken.setEmail(email);
        resetToken.setExpiresAt(expiresAt);
        resetToken.setUsed(false);
        resetToken.setCreatedAt(LocalDateTime.now());

        tokenDAO.create(resetToken);

        emailService.sendPasswordResetEmail(email, user.getUsername(), token, context);

        return "SUCCESS";
    }

    public User validateToken(String token) {
        PasswordResetToken resetToken = tokenDAO.findByToken(token);

        if (resetToken == null) {
            return null;
        }

        if (resetToken.isUsed()) {
            return null;
        }

        if (LocalDateTime.now().isAfter(resetToken.getExpiresAt())) {
            return null;
        }

        return userDAO.findById(resetToken.getUserId());
    }

    public boolean resetPassword(String token, String newPassword) {
        User user = validateToken(token);

        if (user == null) {
            return false;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        user.setPassword(hashedPassword);

        boolean updated = userDAO.update(user);

        if (updated) {
            tokenDAO.markAsUsed(token);
        }

        return updated;
    }

    public boolean isTokenValid(String token) {
        return validateToken(token) != null;
    }
}
