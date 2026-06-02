package com.mobilestore.config;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class EnvConfig {

    private static final Map<String, String> env;
    private static final Pattern LINE_PATTERN = Pattern.compile("^\\s*([^=#]+)\\s*=\\s*(.*)$");

    static {
        env = loadEnv();
    }

    private static Map<String, String> loadEnv() {
        Map<String, String> result = new HashMap<>();
        Path envPath = findEnvFile();

        if (envPath == null || !Files.exists(envPath)) {
            System.err.println("[ENV-CONFIG] WARNING: .env file not found. Email and other features may not work.");
            System.err.println("[ENV-CONFIG] Please copy .env.example to .env and fill in your credentials.");
            return result;
        }

        try {
            Files.lines(envPath)
                    .map(String::trim)
                    .filter(line -> !line.isEmpty() && !line.startsWith("#"))
                    .forEach(line -> {
                        java.util.regex.Matcher matcher = LINE_PATTERN.matcher(line);
                        if (matcher.matches()) {
                            String key = matcher.group(1).trim();
                            String value = matcher.group(2).trim();
                            value = value.replaceAll("^\"|\"$", "");
                            result.put(key, value);
                        }
                    });
            System.out.println("[ENV-CONFIG] Loaded " + result.size() + " config entries from .env");
        } catch (IOException e) {
            System.err.println("[ENV-CONFIG] ERROR loading .env: " + e.getMessage());
        }
        return result;
    }

    private static Path findEnvFile() {
        String catalinaBase = System.getProperty("catalina.base");
        String userDir = System.getProperty("user.dir");
        String userHome = System.getProperty("user.home");
        String projectRoot = findProjectRoot();

        String[] searchPaths = {
            projectRoot != null ? projectRoot : userDir,
            catalinaBase != null ? catalinaBase : userDir,
            userDir,
            userHome
        };

        for (String basePath : searchPaths) {
            if (basePath != null) {
                Path p = Paths.get(basePath, ".env");
                if (Files.exists(p)) return p;
                p = Paths.get(basePath, "src", "main", "webapp", ".env");
                if (Files.exists(p)) return p;
            }
        }
        return null;
    }

    private static String findProjectRoot() {
        String classPath = System.getProperty("java.class.path", "");
        String[] paths = classPath.split(System.getProperty("path.separator", ";"));
        for (String p : paths) {
            if (p.contains("mobilestore") || p.contains("Web-Mobilestore")) {
                Path srcMain = Paths.get(p).getParent();
                if (srcMain != null && Files.exists(srcMain)) {
                    Path root = srcMain.getParent();
                    if (root != null && Files.exists(Paths.get(root.toString(), ".env"))) {
                        return root.toString();
                    }
                }
                Path root = Paths.get(p).getParent();
                if (root != null && Files.exists(Paths.get(root.toString(), ".env"))) {
                    return root.toString();
                }
            }
        }
        return null;
    }

    public static String get(String key) {
        String value = env.get(key);
        if (value == null || value.isBlank()) {
            value = System.getenv(key);
        }
        return value;
    }

    public static String get(String key, String defaultValue) {
        String value = get(key);
        return (value != null && !value.isBlank()) ? value : defaultValue;
    }

    public static boolean has(String key) {
        String value = get(key);
        return value != null && !value.isBlank();
    }
}
