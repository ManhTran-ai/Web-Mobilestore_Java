package com.mobilestore.service;

import com.mobilestore.dao.PasswordResetTokenDAO;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.PasswordResetToken;
import com.mobilestore.entity.User;
import com.mobilestore.util.PasswordUtil;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;

public class PasswordResetService {

    private static final int TOKEN_EXPIRATION_MINUTES = 30;
    private final UserDAO userDAO;
    private final PasswordResetTokenDAO tokenDAO;
    private final EmailService emailService;

    public PasswordResetService() {
        this.userDAO = new UserDAO();
        this.tokenDAO = new PasswordResetTokenDAO();
        this.emailService = new EmailService();
    }

    public String requestPasswordReset(String email, HttpServletRequest request) {
        User user;
        try {
            user = userDAO.findByEmail(email);
        } catch (Exception e) {
            System.err.println("[PASSWORD-RESET] DB error finding user: " + e.getMessage());
            return "SUCCESS_GENERIC";
        }

        if (user == null) {
            System.out.println("[PASSWORD-RESET] Email not found: " + email + " — returning generic success");
            return "SUCCESS_GENERIC";
        }

        if (user.getOauthProvider() != null && !user.getOauthProvider().isEmpty()) {
            System.out.println("[PASSWORD-RESET] OAuth user attempted password reset: " + email);
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

        PasswordResetToken created = tokenDAO.create(resetToken);
        if (created == null) {
            System.err.println("[PASSWORD-RESET] Failed to create reset token in DB");
            return "ERROR";
        }

        emailService.sendPasswordResetEmail(email, user.getUsername(), token, request);

        return "SUCCESS";
    }

    public User validateToken(String token) {
        if (token == null || token.trim().isEmpty()) {
            System.out.println("[PASSWORD-RESET] validateToken: null or empty token");
            return null;
        }

        PasswordResetToken resetToken;
        try {
            resetToken = tokenDAO.findByToken(token);
        } catch (Exception e) {
            System.err.println("[PASSWORD-RESET] DB error finding token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }

        if (resetToken == null) {
            System.out.println("[PASSWORD-RESET] Token not found: " + token);
            return null;
        }

        if (resetToken.isUsed()) {
            System.out.println("[PASSWORD-RESET] Token already used: " + token);
            return null;
        }

        if (LocalDateTime.now().isAfter(resetToken.getExpiresAt())) {
            System.out.println("[PASSWORD-RESET] Token expired: " + token);
            return null;
        }

        User user;
        try {
            user = userDAO.findById(resetToken.getUserId());
        } catch (Exception e) {
            System.err.println("[PASSWORD-RESET] DB error finding user by id: " + e.getMessage());
            e.printStackTrace();
            return null;
        }

        if (user == null) {
            System.out.println("[PASSWORD-RESET] User not found for token, userId=" + resetToken.getUserId());
            return null;
        }

        return user;
    }

    public boolean resetPassword(String token, String newPassword) {
        User user = validateToken(token);

        if (user == null) {
            return false;
        }

        String hashedPassword;
        try {
            hashedPassword = PasswordUtil.hashPassword(newPassword);
        } catch (Exception e) {
            System.err.println("[PASSWORD-RESET] Error hashing password: " + e.getMessage());
            return false;
        }

        boolean updated;
        try {
            updated = userDAO.updatePassword(user.getId(), hashedPassword);
        } catch (Exception e) {
            System.err.println("[PASSWORD-RESET] DB error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        if (updated) {
            tokenDAO.markAsUsed(token);
            System.out.println("[PASSWORD-RESET] Password reset successful for user: " + user.getUsername());
        } else {
            System.err.println("[PASSWORD-RESET] Password update failed for user id: " + user.getId());
        }

        return updated;
    }

    public boolean isTokenValid(String token) {
        return validateToken(token) != null;
    }
}
