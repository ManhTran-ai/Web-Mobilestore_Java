package com.mobilestore.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet(name = "CategoryImageUploadServlet", urlPatterns = {"/admin/categories/upload-image"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class CategoryImageUploadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "images/categories";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        try {
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                sendJsonResponse(response, false, "Không có file được chọn", null);
                return;
            }

            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                sendJsonResponse(response, false, "Chỉ chấp nhận file hình ảnh", null);
                return;
            }

            String originalFilename = getFileName(filePart);
            String extension = getFileExtension(originalFilename);
            if (extension.isEmpty()) {
                extension = ".png";
            }

            String newFilename = UUID.randomUUID().toString() + extension;
            String uploadPath = getServletContext().getRealPath("") + UPLOAD_DIR;
            Path uploadDir = Paths.get(uploadPath);
            
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            Path filePath = uploadDir.resolve(newFilename);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            String imageUrl = UPLOAD_DIR + "/" + newFilename;
            sendJsonResponse(response, true, "Upload thành công", imageUrl);

        } catch (Exception e) {
            System.err.println("Lỗi upload hình ảnh: " + e.getMessage());
            sendJsonResponse(response, false, "Lỗi khi upload: " + e.getMessage(), null);
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                int equalIndex = token.indexOf('=');
                if (equalIndex > 0) {
                    String filename = token.substring(equalIndex + 1).trim();
                    filename = filename.replace("\"", "");
                    int lastSlash = Math.max(filename.lastIndexOf('/'), filename.lastIndexOf('\\'));
                    if (lastSlash > 0) {
                        filename = filename.substring(lastSlash + 1);
                    }
                    return filename;
                }
            }
        }
        return "unknown";
    }

    private String getFileExtension(String filename) {
        int lastDot = filename.lastIndexOf('.');
        if (lastDot > 0) {
            return filename.substring(lastDot);
        }
        return "";
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, String imageUrl)
            throws IOException {
        String json;
        if (success) {
            json = String.format("{\"success\":true,\"message\":\"%s\",\"imageUrl\":\"%s\"}", message, imageUrl);
        } else {
            json = String.format("{\"success\":false,\"message\":\"%s\"}", message);
        }
        response.getWriter().write(json);
    }
}
