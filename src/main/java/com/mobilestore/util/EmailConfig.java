package com.mobilestore.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailConfig {

    private static final Properties props = new Properties();

    static {
        try (InputStream input = EmailConfig.class
                .getClassLoader()
                .getResourceAsStream("mail.properties")) {
            if (input == null) {
                throw new RuntimeException(
                    "Khong tim thay file mail.properties trong classpath!"
                );
            }
            props.load(new InputStreamReader(input, StandardCharsets.UTF_8));
        } catch (IOException e) {
            throw new RuntimeException("Loi khi load mail.properties: " + e.getMessage(), e);
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}
