package com.mobilestore.controller.admin;

import com.mobilestore.service.CategoryService;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.impl.CategoryServiceImpl;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.dto.FileUploadResult;
import com.mobilestore.dto.ProductFormData;
import com.mobilestore.dto.ValidationResult;
import com.mobilestore.entity.Category;
import com.mobilestore.entity.Product;
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

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products", "/admin/products/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AdminProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final ProductService productService = new ProductServiceImpl();
    private final CategoryService categoryService = new CategoryServiceImpl();

    private static final String UPLOAD_DIR = "images/products";
    private static final String UPLOAD_ROOT = "D:\\Web-Programming-MobileStore\\src\\main\\webapp";

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
        response.setContentType("text/html; charset=UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showProductList(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/delete")) {
            deleteProduct(request, response);
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
            processAddProduct(request, response);
        } else if (pathInfo != null && pathInfo.equals("/edit")) {
            processEditProduct(request, response);
        } else if (pathInfo != null && pathInfo.equals("/delete")) {
            processDeleteProduct(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/views/admin/products/product-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/products/product-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        ValidationResult idValidation = validateId(idParam);
        if (!idValidation.isValid()) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=" + idValidation.getErrorCode());
            return;
        }

        Integer id = Integer.parseInt(idParam);
        Product product = productService.findById(id);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=not_found");
            return;
        }

        List<Category> categories = categoryService.findAll();
        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/views/admin/products/product-form.jsp").forward(request, response);
    }

    private void processAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductFormData formData = extractAndValidateFormData(request, false);

        if (!formData.isValid()) {
            setErrorAndForward(request, response, formData.getErrors(), formData);
            return;
        }

        try {
            FileUploadResult uploadResult = processImageUpload(request);
            if (!uploadResult.isSuccess() && uploadResult.getErrorMessage() != null) {
                formData.addError(uploadResult.getErrorMessage());
                setErrorAndForward(request, response, formData.getErrors(), formData);
                return;
            }

            Product product = new Product();
            product.setProductName(formData.getProductName());
            product.setManufacturer(formData.getManufacturer());
            product.setProductCondition(formData.getProductCondition());
            product.setPrice(formData.getPrice());
            product.setDiscount(formData.getDiscount());
            product.setQuantityInStock(formData.getQuantityInStock());
            product.setProductInfo(formData.getProductInfo());
            product.setImage(uploadResult.getFilePath());

            Category category = new Category();
            category.setCategoryId(formData.getCategoryId());
            product.setCategory(category);

            Product existing = productService.findByUniqueKey(product.getProductName(),
                    product.getManufacturer(),
                    product.getProductCondition(),
                    product.getCategory() != null ? product.getCategory().getCategoryId() : null);

            if (existing != null) {
                int newQty = existing.getQuantityInStock() + product.getQuantityInStock();
                existing.setQuantityInStock(newQty);
                boolean updated = productService.update(existing) != null;
                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?success=quantity_updated");
                } else {
                    formData.addError("Không thể cập nhật số lượng sản phẩm. Vui lòng thử lại.");
                    setErrorAndForward(request, response, formData.getErrors(), formData);
                }
                return;
            }

            Product createdProduct = productService.save(product);

            if (createdProduct != null) {
                response.sendRedirect(request.getContextPath() + "/admin/products?success=created");
            } else {
                formData.addError("Không thể tạo sản phẩm. Vui lòng thử lại.");
                setErrorAndForward(request, response, formData.getErrors(), formData);
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi thêm sản phẩm: " + e.getMessage());
            e.printStackTrace();
            formData.addError("Lỗi hệ thống: " + e.getMessage());
            setErrorAndForward(request, response, formData.getErrors(), formData);
        }
    }

    private void processEditProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        ValidationResult idValidation = validateId(idStr);
        if (!idValidation.isValid()) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=" + idValidation.getErrorCode());
            return;
        }

        Integer id = Integer.parseInt(idStr);
        Product existingProduct = productService.findById(id);

        if (existingProduct == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=not_found");
            return;
        }

        ProductFormData formData = extractAndValidateFormData(request, true);
        formData.setId(id);

        if (!formData.isValid()) {
            setErrorAndForwardEdit(request, response, formData.getErrors(), formData, id);
            return;
        }

        try {
            FileUploadResult uploadResult = processImageUpload(request);
            if (!uploadResult.isSuccess() && uploadResult.getErrorMessage() != null) {
                formData.addError(uploadResult.getErrorMessage());
                setErrorAndForwardEdit(request, response, formData.getErrors(), formData, id);
                return;
            }

            String imagePath = uploadResult.getFilePath();
            if (imagePath == null || imagePath.isEmpty()) {
                imagePath = existingProduct.getImage();
            } else {
                deleteOldImage(existingProduct.getImage());
            }

            existingProduct.setProductName(formData.getProductName());
            existingProduct.setManufacturer(formData.getManufacturer());
            existingProduct.setProductCondition(formData.getProductCondition());
            existingProduct.setPrice(formData.getPrice());
            existingProduct.setDiscount(formData.getDiscount());
            existingProduct.setQuantityInStock(formData.getQuantityInStock());
            existingProduct.setProductInfo(formData.getProductInfo());
            existingProduct.setImage(imagePath);

            Category category = new Category();
            category.setCategoryId(formData.getCategoryId());
            existingProduct.setCategory(category);

            boolean updated = productService.update(existingProduct) != null;

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
            } else {
                formData.addError("Không thể cập nhật sản phẩm. Vui lòng thử lại.");
                setErrorAndForwardEdit(request, response, formData.getErrors(), formData, id);
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=system");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        String confirm = request.getParameter("confirm");

        ValidationResult idValidation = validateId(idParam);
        if (!idValidation.isValid()) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=" + idValidation.getErrorCode());
            return;
        }

        if (!"true".equals(confirm)) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=confirm_required&id=" + idParam);
            return;
        }

        Integer id = Integer.parseInt(idParam);
        performDelete(id, request, response);
    }

    private void processDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        ValidationResult idValidation = validateId(idParam);
        if (!idValidation.isValid()) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=" + idValidation.getErrorCode());
            return;
        }

        Integer id = Integer.parseInt(idParam);
        performDelete(id, request, response);
    }

    private void performDelete(Integer id, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Product product = productService.findById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=not_found");
            return;
        }

        boolean deleted = productService.delete(id);

        if (deleted) {
            deleteOldImage(product.getImage());
            response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=delete_failed");
        }
    }

    private FileUploadResult processImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("image");

        if (filePart == null || filePart.getSize() == 0) {
            return new FileUploadResult(true, null, null);
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return new FileUploadResult(true, null, null);
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            return new FileUploadResult(false, null, "Kích thước file không được vượt quá 10MB");
        }

        String extension = getFileExtension(fileName).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            return new FileUploadResult(false, null,
                "Định dạng file không được hỗ trợ. Chỉ chấp nhận: JPG, JPEG, PNG, GIF, WEBP");
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            return new FileUploadResult(false, null,
                "Loại file không hợp lệ. Chỉ chấp nhận file ảnh.");
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
            boolean created = uploadDir.mkdirs();
            if (!created) {
                return new FileUploadResult(false, null, "Không thể tạo thư mục upload");
            }
        }

        Path filePath = Paths.get(uploadPath, uniqueFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        String dbPath = UPLOAD_DIR + "/" + uniqueFileName;
        if (dbPath.startsWith("/")) {
            dbPath = dbPath.substring(1);
        }

        return new FileUploadResult(true, dbPath, null);
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
            String actualPath = file.getAbsolutePath();
            if (file.exists()) {
                boolean deleted = file.delete();
                if (!deleted) {
                    System.err.println("Không thể xóa file: " + actualPath);
                }
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

    private ProductFormData extractAndValidateFormData(HttpServletRequest request, boolean isEdit) {
        ProductFormData formData = new ProductFormData();

        String productName = request.getParameter("productName");
        String manufacturer = request.getParameter("manufacturer");
        String productCondition = request.getParameter("productCondition");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");
        String quantityStr = request.getParameter("quantityInStock");
        String productInfo = request.getParameter("productInfo");
        String categoryIdStr = request.getParameter("categoryId");
        String newCategoryName = request.getParameter("newCategoryName");

        formData.setProductName(productName != null ? productName.trim() : "");
        formData.setManufacturer(manufacturer != null ? manufacturer.trim() : "");
        formData.setProductCondition(productCondition != null ? productCondition.trim() : "Mới");
        formData.setProductInfo(productInfo != null ? productInfo.trim() : "");
        formData.setNewCategoryName(newCategoryName != null ? newCategoryName.trim() : "");

        if (productName == null || productName.trim().isEmpty()) {
            formData.addError("Tên sản phẩm không được để trống");
        } else if (productName.trim().length() < 2) {
            formData.addError("Tên sản phẩm phải có ít nhất 2 ký tự");
        } else if (productName.trim().length() > 255) {
            formData.addError("Tên sản phẩm không được vượt quá 255 ký tự");
        }

        if (manufacturer == null || manufacturer.trim().isEmpty()) {
            formData.addError("Nhà sản xuất không được để trống");
        } else if (manufacturer.trim().length() > 255) {
            formData.addError("Tên nhà sản xuất không được vượt quá 255 ký tự");
        }

        if (priceStr == null || priceStr.trim().isEmpty()) {
            formData.addError("Giá không được để trống");
        } else {
            try {
                Long price = Long.parseLong(priceStr.trim());
                if (price < 0) {
                    formData.addError("Giá phải lớn hơn hoặc bằng 0");
                } else if (price > 999999999) {
                    formData.addError("Giá không được vượt quá 999,999,999 VNĐ");
                } else {
                    formData.setPrice(price);
                }
            } catch (NumberFormatException e) {
                formData.addError("Giá không hợp lệ. Vui lòng nhập số");
            }
        }

        if (discountStr != null && !discountStr.trim().isEmpty()) {
            try {
                Long discount = Long.parseLong(discountStr.trim());
                if (discount < 0 || discount > 100) {
                    formData.addError("Giảm giá phải nằm trong khoảng từ 0 đến 100%");
                } else {
                    formData.setDiscount(discount);
                }
            } catch (NumberFormatException e) {
                formData.addError("Giảm giá không hợp lệ. Vui lòng nhập số nguyên");
            }
        } else {
            formData.setDiscount(0L);
        }

        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            formData.addError("Số lượng không được để trống");
        } else {
            try {
                int quantity = Integer.parseInt(quantityStr.trim());
                if (quantity < 0) {
                    formData.addError("Số lượng phải lớn hơn hoặc bằng 0");
                } else if (quantity > 99999) {
                    formData.addError("Số lượng không được vượt quá 99,999");
                } else {
                    formData.setQuantityInStock(quantity);
                }
            } catch (NumberFormatException e) {
                formData.addError("Số lượng không hợp lệ. Vui lòng nhập số nguyên");
            }
        }

        if ((categoryIdStr == null || categoryIdStr.trim().isEmpty())
                && (newCategoryName == null || newCategoryName.trim().isEmpty())) {
            formData.addError("Vui lòng chọn danh mục hoặc nhập tên danh mục mới");
        } else if (newCategoryName != null && !newCategoryName.trim().isEmpty()) {
            String name = newCategoryName.trim();
            if (name.length() > 255) {
                formData.addError("Tên danh mục không được vượt quá 255 ký tự");
            } else {
                Category existing = categoryService.findByName(name);
                if (existing != null) {
                    formData.setCategoryId(existing.getCategoryId());
                } else {
                    Category toCreate = new Category();
                    toCreate.setCategoryName(name);
                    Category created = categoryService.save(toCreate);
                    if (created == null) {
                        formData.addError("Không thể tạo danh mục mới. Vui lòng thử lại.");
                    } else {
                        formData.setCategoryId(created.getCategoryId());
                    }
                }
            }
        } else {
            try {
                int categoryId = Integer.parseInt(categoryIdStr.trim());
                if (categoryId <= 0) {
                    formData.addError("Danh mục không hợp lệ");
                } else {
                    Category category = categoryService.findById(categoryId);
                    if (category == null) {
                        formData.addError("Danh mục không tồn tại");
                    } else {
                        formData.setCategoryId(categoryId);
                    }
                }
            } catch (NumberFormatException e) {
                formData.addError("Danh mục không hợp lệ");
            }
        }

        if (productCondition == null || productCondition.trim().isEmpty()) {
            formData.setProductCondition("Mới");
        } else {
            List<String> validConditions = Arrays.asList("Mới", "Đã qua sử dụng", "Tân trang");
            if (!validConditions.contains(productCondition.trim())) {
                formData.addError("Tình trạng sản phẩm không hợp lệ");
            }
        }

        if (productInfo != null && productInfo.length() > 1000) {
            formData.addError("Mô tả sản phẩm không được vượt quá 1000 ký tự");
        }

        return formData;
    }

    private ValidationResult validateId(String idParam) {
        if (idParam == null || idParam.trim().isEmpty()) {
            return new ValidationResult(false, "missing_id");
        }
        try {
            int id = Integer.parseInt(idParam.trim());
            if (id <= 0) {
                return new ValidationResult(false, "invalid_id");
            }
            return new ValidationResult(true, null);
        } catch (NumberFormatException e) {
            return new ValidationResult(false, "invalid_id");
        }
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
                                    List<String> errors, ProductFormData formData)
            throws ServletException, IOException {
        request.setAttribute("errors", errors);
        request.setAttribute("error", String.join("<br>", errors));
        request.setAttribute("formData", formData);
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/products/product-form.jsp").forward(request, response);
    }

    private void setErrorAndForwardEdit(HttpServletRequest request, HttpServletResponse response,
                                        List<String> errors, ProductFormData formData, Integer id)
            throws ServletException, IOException {
        request.setAttribute("errors", errors);
        request.setAttribute("error", String.join("<br>", errors));

        Product product = new Product();
        product.setProductId(id);
        product.setProductName(formData.getProductName());
        product.setManufacturer(formData.getManufacturer());
        product.setProductCondition(formData.getProductCondition());
        product.setPrice(formData.getPrice());
        product.setDiscount(formData.getDiscount());
        product.setQuantityInStock(formData.getQuantityInStock());
        product.setProductInfo(formData.getProductInfo());

        if (formData.getCategoryId() != null) {
            Category category = new Category();
            category.setCategoryId(formData.getCategoryId());
            product.setCategory(category);
        }

        Product existingProduct = productService.findById(id);
        if (existingProduct != null) {
            product.setImage(existingProduct.getImage());
        }

        request.setAttribute("product", product);
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/views/admin/products/product-form.jsp").forward(request, response);
    }
}
