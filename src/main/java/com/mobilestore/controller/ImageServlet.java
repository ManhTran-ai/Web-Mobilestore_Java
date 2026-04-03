package com.mobilestore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

@WebServlet(name = "ImageServlet", urlPatterns = {"/images/*"})
public class ImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String UPLOAD_ROOT = "D:\\TTLTW\\Java-Web-MobileStore\\src\\main\\webapp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.trim().isEmpty() || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String pathWithinServlet = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        String relative = "images" + File.separator + pathWithinServlet;

        File file = null;
        if (UPLOAD_ROOT != null && !UPLOAD_ROOT.trim().isEmpty()) {
            file = new File(UPLOAD_ROOT + File.separator + relative);
            if (!file.exists() || !file.isFile()) {
                file = null;
            }
        }

        if (file == null) {
            String fallbackPath = getServletContext().getRealPath("") + File.separator + relative;
            file = new File(fallbackPath);
            if (!file.exists() || !file.isFile()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        String contentType = Files.probeContentType(file.toPath());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        response.setHeader("Cache-Control", "public, max-age=86400");

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }
    }
}
