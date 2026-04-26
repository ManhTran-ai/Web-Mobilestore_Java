package com.mobilestore.controller.admin;

import com.mobilestore.entity.SliderImage;
import com.mobilestore.service.SliderImageService;
import com.mobilestore.service.impl.SliderImageServiceImpl;
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
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

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
            java.util.Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp")
    );

    private static final Set<String> ALLOWED_MIME_TYPES = new HashSet<>(
            java.util.Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp")
    );

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showSliderList(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/delete")) {
            deleteSlider(request, response);
        } else if (pathInfo.equals("/toggle")) {
            processToggleActive(request, response);
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

        if (pathInfo != null && pathInfo.equals("/add")) {
            processAddSlider(request, response);
        } else if (pathInfo != null && pathInfo.equals("/edit")) {
            processEditSlider(request, response);
        } else if (pathInfo != null && pathInfo.equals("/delete")) {
            processDeleteSlider(request, response);
        } else if (pathInfo != null && pathInfo.equals("/toggle")) {
            processToggleActive(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showSliderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        java.util.List<SliderImage> sliders = sliderService.findAll();
        request.setAttribute("sliders", sliders);
        request.setAttribute("activeCount", sliderService.countActive());
        request.setAttribute("inactiveCount", sliderService.countInactive());
        request.getRequestDispatcher("/views/admin/sliders/slider-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/sliders/slider-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam.trim());
            SliderImage slider = sliderService.findById(id);

            if (slider == null) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=not_found");
                return;
            }

            request.setAttribute("slider", slider);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/sliders/slider-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private void processAddSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String isActiveStr = request.getParameter("isActive");
        boolean isActive = "1".equals(isActiveStr) || isActiveStr == null;

        String imageUrl = null;
        Part filePart = null;

        try {
            filePart = request.getPart("image");
        } catch (Exception e) {
            // No file part
        }

        if (filePart != null && filePart.getSize() > 0) {
            imageUrl = uploadImage(filePart);
            if (imageUrl == null) {
                request.setAttribute("error", "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WebP) và kích thước tối đa 10MB");
                request.setAttribute("isEdit", false);
                request.getRequestDispatcher("/views/admin/sliders/slider-form.jsp").forward(request, response);
                return;
            }
        }

        if (imageUrl == null) {
            request.setAttribute("error", "Vui lòng chọn hình ảnh slider");
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/admin/sliders/slider-form.jsp").forward(request, response);
            return;
        }

        SliderImage slider = new SliderImage();
        slider.setImageUrl(imageUrl);
        slider.setIsActive(isActive);

        SliderImage created = sliderService.save(slider);

        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?success=created");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=create_failed");
        }
    }

    private void processEditSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam.trim());
            SliderImage existingSlider = sliderService.findById(id);

            if (existingSlider == null) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=not_found");
                return;
            }

            String isActiveStr = request.getParameter("isActive");
            boolean isActive = "1".equals(isActiveStr);

            String imageUrl = existingSlider.getImageUrl();
            Part filePart = null;

            try {
                filePart = request.getPart("image");
            } catch (Exception e) {
                // No file part
            }

            if (filePart != null && filePart.getSize() > 0) {
                String newImageUrl = uploadImage(filePart);
                if (newImageUrl != null) {
                    deleteOldImage(existingSlider.getImageUrl());
                    imageUrl = newImageUrl;
                }
            }

            existingSlider.setImageUrl(imageUrl);
            existingSlider.setIsActive(isActive);

            boolean updated = sliderService.update(existingSlider);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=update_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private void deleteSlider(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        String confirm = request.getParameter("confirm");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        if (!"true".equals(confirm)) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=confirm_required&id=" + idParam);
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam.trim());
            performDelete(id, request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private void processDeleteSlider(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam.trim());
            performDelete(id, request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private void performDelete(Integer id, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SliderImage slider = sliderService.findById(id);
        if (slider == null) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=not_found");
            return;
        }

        deleteOldImage(slider.getImageUrl());
        boolean deleted = sliderService.delete(id);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=delete_failed");
        }
    }

    private void processToggleActive(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=missing_id");
            return;
        }

        try {
            Integer id = Integer.parseInt(idParam.trim());
            boolean toggled = sliderService.toggleActive(id);

            if (toggled) {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?success=toggled");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/sliders?error=toggle_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/sliders?error=invalid_id");
        }
    }

    private String uploadImage(Part filePart) throws IOException, ServletException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

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

    private void deleteOldImage(String imagePath) {
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
