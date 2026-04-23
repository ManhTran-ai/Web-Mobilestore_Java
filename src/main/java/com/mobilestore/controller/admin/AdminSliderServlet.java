package com.mobilestore.controller.admin;

import com.mobilestore.service.SliderImageService;
import com.mobilestore.service.impl.SliderImageServiceImpl;
import com.mobilestore.entity.SliderImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;

@WebServlet(name = "AdminSliderServlet", urlPatterns = {"/admin/sliders", "/admin/sliders/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 20
)
public class AdminSliderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final SliderImageService sliderService = new SliderImageServiceImpl();

    private static final String UPLOAD_DIR = "images/slider";
    private static final String UPLOAD_ROOT = "D:\\TTLTW\\Java-Web-MobileStore\\src\\main\\webapp";

    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(
            Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp")
    );

    private static final Set<String> ALLOWED_MIME_TYPES = new HashSet<>(
            Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp")
    );

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            showList(request, response);
        } else if ("/delete".equals(pathInfo)) {
            confirmDelete(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if ("/add".equals(pathInfo)) {
            processAdd(request, response);
        } else if ("/toggle".equals(pathInfo)) {
            processToggle(request, response);
        } else if ("/delete".equals(pathInfo)) {
            processDelete(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SliderImage> sliders = sliderService.findAll();
        int total = sliderService.countTotal();
        int active = sliderService.countActive();
        int hidden = total - active;

        request.setAttribute("sliders", sliders);
        request.setAttribute("totalSliders", total);
        request.setAttribute("activeSliders", active);
        request.setAttribute("hiddenSliders", Math.max(0, hidden));
        request.getRequestDispatcher("/views/admin/sliders/slider-list.jsp").forward(request, response);
    }

    private void processAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Part filePart = request.getPart("image");
        String isActiveParam = request.getParameter("isActive");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=no_image");
            return;
        }

        String imageUrl = uploadImage(filePart);
        if (imageUrl == null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=upload_failed");
            return;
        }

        SliderImage slider = new SliderImage();
        slider.setImageUrl(imageUrl);
        slider.setIsActive(!"0".equals(isActiveParam));

        SliderImage created = sliderService.save(slider);
        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=save_failed");
        }
    }

    private void processToggle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam);
            boolean toggled = sliderService.toggleActive(id);

            if (toggled) {
                SliderImage updated = sliderService.findById(id);
                boolean nowActive = updated != null && Boolean.TRUE.equals(updated.getIsActive());
                response.getWriter().write("{\"success\":true,\"isActive\":" + nowActive + "}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy slider\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
        }
    }

    private void confirmDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/sliders?confirm=true&id=" + idParam);
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        String confirm = request.getParameter("confirm");

        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        if (!"true".equals(confirm)) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=confirm_required&id=" + idParam);
            return;
        }

        try {
            SliderImage slider = sliderService.findById(Integer.parseInt(idParam));
            if (slider == null) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=not_found");
                return;
            }

            deleteImageFile(slider.getImageUrl());

            boolean deleted = sliderService.delete(Integer.parseInt(idParam));
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private String uploadImage(Part filePart) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            return null;
        }

        String extension = getFileExtension(fileName).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            return null;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            return null;
        }

        String uniqueFileName = UUID.randomUUID().toString() + extension;

        String uploadPath;
        if (UPLOAD_ROOT != null && !UPLOAD_ROOT.trim().isEmpty()) {
            uploadPath = UPLOAD_ROOT + File.separator + UPLOAD_DIR;
        } else {
            uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        }

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Path filePath = Paths.get(uploadPath, uniqueFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        String dbPath = UPLOAD_DIR + "/" + uniqueFileName;
        if (dbPath.startsWith("/")) {
            dbPath = dbPath.substring(1);
        }

        return dbPath;
    }

    private void deleteImageFile(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return;
        }

        try {
            String fullPath = null;
            if (UPLOAD_ROOT != null && !UPLOAD_ROOT.trim().isEmpty()) {
                fullPath = UPLOAD_ROOT + File.separator + imagePath;
            }
            File file = null;
            if (fullPath != null) {
                file = new File(fullPath);
            }
            if (file == null || !file.exists()) {
                String fallback = getServletContext().getRealPath("") + File.separator + imagePath;
                file = new File(fallback);
            }
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi xóa file ảnh: " + e.getMessage());
        }
    }

    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        if (lastDot > 0) {
            return fileName.substring(lastDot);
        }
        return "";
    }
}
