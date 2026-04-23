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
        String sysHost = System.getProperty("db.host");
        String sysPort = System.getProperty("db.port");
        String sysName = System.getProperty("db.name");
        String sysUser = System.getProperty("db.user");
        String sysPass = System.getProperty("db.pass");

        if (sysHost != null && !sysHost.isEmpty()) {
            URL = String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8",
                sysHost,
                sysPort != null ? sysPort : "3306",
                sysName != null ? sysName : "mobilestore"
            );
            USERNAME = sysUser != null ? sysUser : "root";
            PASSWORD = sysPass != null ? sysPass : "";
        } else {
            try (InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("db.properties")) {
                Properties prop = new Properties();
                if (input == null) {
                    System.out.println("[DB] db.properties not found, using local defaults");
                    URL = "jdbc:mysql://localhost:3306/mobilestore"
                        + "?useSSL=false&allowPublicKeyRetrieval=true"
                        + "&serverTimezone=UTC&characterEncoding=UTF-8";
                    USERNAME = "root";
                    PASSWORD = "1317192005";
                } else {
                    prop.load(input);
                    String host = prop.getProperty("db.host", "localhost");
                    String port  = prop.getProperty("db.port", "3306");
                    String dbName = prop.getProperty("db.name", "mobilestore");
                    URL = String.format(
                        "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true"
                            + "&serverTimezone=UTC&characterEncoding=UTF-8",
                        host, port, dbName
                    );
                    USERNAME = prop.getProperty("db.username", "root");
                    PASSWORD = prop.getProperty("db.password", "1317192005");
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Khong tim thay MySQL JDBC Driver", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            return connection;
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
            throw e;
        }
    }
}
