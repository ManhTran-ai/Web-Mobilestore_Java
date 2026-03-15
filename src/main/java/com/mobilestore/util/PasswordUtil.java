package com.mobilestore.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
    
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            System.err.println("Lỗi khi verify mật khẩu: " + e.getMessage());
            return false;
        }
    }
}
