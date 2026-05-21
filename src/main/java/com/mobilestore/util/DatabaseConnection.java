package com.mobilestore.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;
    
    static {
        try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Sorry, unable to find db.properties");
                URL = "jdbc:mysql://localhost:3306/mobilestore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh";
                USERNAME = "root";
                PASSWORD = "1317192005";
            } else {
                prop.load(input);
                URL = prop.getProperty("db.url");
                USERNAME = prop.getProperty("db.username");
                PASSWORD = prop.getProperty("db.password");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Không tìm thấy MySQL JDBC Driver", e);
        }

        try {
            java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        } catch (Exception e) {
            System.err.println("Không thể đặt Timezone mặc định: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

            try (var stmt = connection.createStatement()) {
                stmt.execute("SET time_zone = '+07:00'");
            }

            return connection;
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            throw e;
        }
    }

    public static String getServerTimezone() {
        return "Asia/Ho_Chi_Minh (GMT+07:00)";
    }
}
