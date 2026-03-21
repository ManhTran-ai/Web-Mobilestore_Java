<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm'} - Trang quản lý</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #f5f5f7;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: #1a1a1a;
            color: #ffffff;
            padding: 2rem 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 0 1.5rem 2rem;
            border-bottom: 1px solid #333;
            margin-bottom: 1rem;
        }

        .sidebar-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #ffffff;
        }

        .sidebar-header span {
            font-size: 0.875rem;
            color: #888;
        }

        .sidebar-nav {
            list-style: none;
        }

        .sidebar-nav li {
            margin: 0.25rem 0;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 0.875rem 1.5rem;
            color: #ccc;
            text-decoration: none;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background: #333;
            color: #ffffff;
        }

        .sidebar-nav a.active {
            border-left: 3px solid #0071e3;
        }

        .sidebar-nav .icon {
            margin-right: 0.75rem;
            font-size: 1.1rem;
        }

        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .breadcrumb a {
            color: #0071e3;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb span {
            color: #888;
        }

        .form-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            max-width: 800px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #1a1a1a;
            font-size: 0.95rem;
        }

        .form-label .required {
            color: #ff3b30;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #0071e3;
            box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
        }

        .form-control::placeholder {
            color: #aaa;
        }

        .form-control.is-invalid {
            border-color: #ff3b30;
        }

        .form-control.is-valid {
            border-color: #34c759;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        select.form-control {
            cursor: pointer;
            background: #ffffff url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L1 3h10z'/%3E%3C/svg%3E") no-repeat right 1rem center;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            padding-right: 2.5rem;
        }

        .invalid-feedback {
            display: none;
            color: #ff3b30;
            font-size: 0.85rem;
            margin-top: 0.375rem;
        }

        .form-control.is-invalid + .invalid-feedback,
        .form-control.is-invalid ~ .invalid-feedback {
            display: block;
        }

        .valid-feedback {
            display: none;
            color: #34c759;
            font-size: 0.85rem;
            margin-top: 0.375rem;
        }

        .char-counter {
            font-size: 0.8rem;
            color: #888;
            text-align: right;
            margin-top: 0.25rem;
        }

        .char-counter.warning {
            color: #ff9500;
        }

        .char-counter.danger {
            color: #ff3b30;
        }

        .file-input-wrapper {
            position: relative;
        }

        .file-input {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-input-display {
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px dashed #d1d1d6;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            transition: all 0.2s;
            cursor: pointer;
        }

        .file-input-display:hover {
            border-color: #0071e3;
            background: #f5f5f7;
        }

        .file-input-display.drag-over {
            border-color: #0071e3;
            background: rgba(0, 113, 227, 0.05);
        }

        .file-input-display.is-invalid {
            border-color: #ff3b30;
        }

        .file-input-display .icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .file-input-display p {
            color: #666;
            font-size: 0.9rem;
        }

        .file-input-display .hint {
            color: #888;
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }

        .image-preview-container {
            margin-top: 1rem;
            position: relative;
            display: inline-block;
        }

        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border-radius: 8px;
            display: none;
        }

        .remove-image-btn {
            position: absolute;
            top: -8px;
            right: -8px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #ff3b30;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 14px;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .current-image {
            margin-top: 1rem;
        }

        .current-image img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 8px;
            border: 1px solid #e5e5ea;
        }

        .current-image p {
            font-size: 0.85rem;
            color: #666;
            margin-top: 0.5rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e5e5ea;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.875rem 2rem;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            font-family: inherit;
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-primary {
            background: #0071e3;
            color: #ffffff;
        }

        .btn-primary:hover:not(:disabled) {
            background: #0077ed;
        }

        .btn-secondary {
            background: #e5e5ea;
            color: #1a1a1a;
        }

        .btn-secondary:hover {
            background: #d1d1d6;
        }

        .spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid #ffffff;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .btn-primary.loading .spinner {
            display: inline-block;
        }

        .btn-primary.loading .btn-text {
            margin-left: 8px;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .alert-error {
            background: #fdecea;
            color: #c62828;
            border: 1px solid #f5c6cb;
        }

        .alert-error ul {
            margin: 0.5rem 0 0 1.5rem;
            padding: 0;
        }

        .help-text {
            font-size: 0.85rem;
            color: #888;
            margin-top: 0.375rem;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>Mobile Store</h2>
                <span>Trang quản lý</span>
            </div>
            <nav>
                <ul class="sidebar-nav">
                    <li>
                        <a href="${pageContext.request.contextPath}/">
                            Trang chủ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/products" class="active">
                            Sản phẩm
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            Đơn hàng
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <main class="main-content">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
                <span>/</span>
                <span>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</span>
            </div>

            <div class="page-header">
                <h1>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</h1>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error" id="serverError">
                    <strong>✕ Lỗi:</strong>
                    <c:choose>
                        <c:when test="${not empty errors}">
                            <ul>
                                <c:forEach var="err" items="${errors}">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            ${error}
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="alert alert-error" id="clientErrors" style="display: none;">
                <strong>✕ Vui lòng sửa các lỗi sau:</strong>
                <ul id="errorList"></ul>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/admin/products/${isEdit ? 'edit' : 'add'}"
                      method="post"
                      enctype="multipart/form-data"
                      id="productForm"
                      novalidate>

                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${product.productId}">
                    </c:if>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="productName">
                                Tên sản phẩm <span class="required">*</span>
                            </label>
                            <input type="text"
                                   id="productName"
                                   name="productName"
                                   class="form-control"
                                   placeholder="VD: iPhone 15 Pro Max"
                                   value="${product.productName}"
                                   maxlength="255"
                                   required
                                   data-min="2"
                                   data-max="255">
                            <div class="invalid-feedback" id="productNameError">Tên sản phẩm không hợp lệ</div>
                            <div class="char-counter"><span id="productNameCount">0</span>/255</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="manufacturer">
                                Nhà sản xuất <span class="required">*</span>
                            </label>
                            <input type="text"
                                   id="manufacturer"
                                   name="manufacturer"
                                   class="form-control"
                                   placeholder="VD: Apple, Samsung, Xiaomi..."
                                   value="${product.manufacturer}"
                                   maxlength="255"
                                   required>
                            <div class="invalid-feedback" id="manufacturerError">Nhà sản xuất không hợp lệ</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="price">
                                Giá (VNĐ) <span class="required">*</span>
                            </label>
                            <input type="number"
                                   id="price"
                                   name="price"
                                   class="form-control"
                                   placeholder="VD: 25000000"
                                   min="0"
                                   max="999999999"
                                   step="1000"
                                   value="${product.price != null ? product.price.intValue() : ''}"
                                   required>
                            <div class="invalid-feedback" id="priceError">Giá không hợp lệ</div>
                            <p class="help-text">Nhập giá bằng số (0 - 999,999,999 VNĐ)</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="quantityInStock">
                                Số lượng tồn kho <span class="required">*</span>
                            </label>
                            <input type="number"
                                   id="quantityInStock"
                                   name="quantityInStock"
                                   class="form-control"
                                   placeholder="VD: 50"
                                   min="0"
                                   max="99999"
                                   value="${product.quantityInStock}"
                                   required>
                            <div class="invalid-feedback" id="quantityError">Số lượng không hợp lệ</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="categoryId">
                                Danh mục <span class="required">*</span>
                            </label>
                            <select id="categoryId" name="categoryId" class="form-control" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}"
                                            ${product.category.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback" id="categoryError">Vui lòng chọn danh mục</div>
                        </div>

                        <div class="form-group" style="grid-column: 2 / span 1;">
                            <label class="form-label" for="newCategoryName">
                                Hoặc tạo danh mục mới
                            </label>
                            <input type="text"
                                   id="newCategoryName"
                                   name="newCategoryName"
                                   class="form-control"
                                   placeholder="Nhập tên danh mục mới để tạo nhanh"
                                   maxlength="255"
                                   value="">
                            <div class="help-text">Nhập tên danh mục mới để tạo nhanh. Nếu nhập, mục 'Danh mục' sẽ bị bỏ chọn.</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="productCondition">
                                Tình trạng <span class="required">*</span>
                            </label>
                            <select id="productCondition" name="productCondition" class="form-control" required>
                                <option value="Mới" ${product.productCondition == 'Mới' || empty product.productCondition ? 'selected' : ''}>Mới</option>
                                <option value="Đã qua sử dụng" ${product.productCondition == 'Đã qua sử dụng' ? 'selected' : ''}>Đã qua sử dụng</option>
                                <option value="Tân trang" ${product.productCondition == 'Tân trang' ? 'selected' : ''}>Tân trang</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="productInfo">
                            Mô tả sản phẩm
                        </label>
                        <textarea id="productInfo"
                                  name="productInfo"
                                  class="form-control"
                                  placeholder="Nhập mô tả chi tiết về sản phẩm..."
                                  maxlength="1000">${product.productInfo}</textarea>
                        <div class="char-counter"><span id="productInfoCount">0</span>/1000</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Hình ảnh sản phẩm</label>
                        <div class="file-input-wrapper">
                            <div class="file-input-display" id="fileInputDisplay">
                                <div>
                                    <div class="icon">📷</div>
                                    <p>Kéo thả hoặc click để chọn ảnh</p>
                                    <p class="hint">Hỗ trợ: JPG, PNG, GIF, WEBP (Tối đa 10MB)</p>
                                </div>
                            </div>
                            <input type="file"
                                   id="image"
                                   name="image"
                                   class="file-input"
                                   accept=".jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp">
                        </div>
                        <div class="invalid-feedback" id="imageError">File ảnh không hợp lệ</div>

                        <div class="image-preview-container">
                            <img id="imagePreview" class="image-preview" alt="Preview">
                            <button type="button" class="remove-image-btn" id="removeImageBtn" title="Xóa ảnh">×</button>
                        </div>

                        <c:if test="${isEdit && not empty product.image}">
                            <div class="current-image" id="currentImage">
                                <p>Ảnh hiện tại:</p>
                                <img src="${pageContext.request.contextPath}/${product.image}"
                                     alt="${product.productName}">
                                <p>Chọn ảnh mới để thay đổi hoặc để trống để giữ nguyên</p>
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <span class="spinner"></span>
                            <span class="btn-text">${isEdit ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm'}</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        const CONFIG = {
            maxFileSize: 10 * 1024 * 1024,
            allowedExtensions: ['.jpg', '.jpeg', '.png', '.gif', '.webp'],
            allowedMimeTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
            maxProductNameLength: 255,
            maxProductInfoLength: 1000,
            maxPrice: 999999999,
            maxQuantity: 99999
        };

        const form = document.getElementById('productForm');
        const submitBtn = document.getElementById('submitBtn');
        const clientErrorsDiv = document.getElementById('clientErrors');
        const errorList = document.getElementById('errorList');

        const productNameInput = document.getElementById('productName');
        const manufacturerInput = document.getElementById('manufacturer');
        const priceInput = document.getElementById('price');
        const quantityInput = document.getElementById('quantityInStock');
        const categorySelect = document.getElementById('categoryId');
        const productInfoInput = document.getElementById('productInfo');
        const imageInput = document.getElementById('image');
        const fileInputDisplay = document.getElementById('fileInputDisplay');
        const imagePreview = document.getElementById('imagePreview');
        const removeImageBtn = document.getElementById('removeImageBtn');

        function validateProductName() {
            const value = productNameInput.value.trim();
            const errorEl = document.getElementById('productNameError');

            if (!value) {
                setInvalid(productNameInput, errorEl, 'Tên sản phẩm không được để trống');
                return false;
            }
            if (value.length < 2) {
                setInvalid(productNameInput, errorEl, 'Tên sản phẩm phải có ít nhất 2 ký tự');
                return false;
            }
            if (value.length > CONFIG.maxProductNameLength) {
                setInvalid(productNameInput, errorEl, 'Tên sản phẩm không được vượt quá 255 ký tự');
                return false;
            }

            setValid(productNameInput);
            return true;
        }

        function validateManufacturer() {
            const value = manufacturerInput.value.trim();
            const errorEl = document.getElementById('manufacturerError');

            if (!value) {
                setInvalid(manufacturerInput, errorEl, 'Nhà sản xuất không được để trống');
                return false;
            }
            if (value.length > 255) {
                setInvalid(manufacturerInput, errorEl, 'Tên nhà sản xuất không được vượt quá 255 ký tự');
                return false;
            }

            setValid(manufacturerInput);
            return true;
        }

        function validatePrice() {
            const value = priceInput.value.trim();
            const errorEl = document.getElementById('priceError');

            if (!value) {
                setInvalid(priceInput, errorEl, 'Giá không được để trống');
                return false;
            }

            const price = parseFloat(value);
            if (isNaN(price)) {
                setInvalid(priceInput, errorEl, 'Giá phải là số');
                return false;
            }
            if (price < 0) {
                setInvalid(priceInput, errorEl, 'Giá không được âm');
                return false;
            }
            if (price > CONFIG.maxPrice) {
                setInvalid(priceInput, errorEl, 'Giá không được vượt quá 999,999,999 VNĐ');
                return false;
            }

            setValid(priceInput);
            return true;
        }

        function validateQuantity() {
            const value = quantityInput.value.trim();
            const errorEl = document.getElementById('quantityError');

            if (!value) {
                setInvalid(quantityInput, errorEl, 'Số lượng không được để trống');
                return false;
            }

            const quantity = parseInt(value);
            if (isNaN(quantity)) {
                setInvalid(quantityInput, errorEl, 'Số lượng phải là số nguyên');
                return false;
            }
            if (quantity < 0) {
                setInvalid(quantityInput, errorEl, 'Số lượng không được âm');
                return false;
            }
            if (quantity > CONFIG.maxQuantity) {
                setInvalid(quantityInput, errorEl, 'Số lượng không được vượt quá 99,999');
                return false;
            }

            setValid(quantityInput);
            return true;
        }

        function validateCategory() {
            const value = categorySelect.value;
            const newCategoryVal = newCategoryInput ? newCategoryInput.value.trim() : '';
            const errorEl = document.getElementById('categoryError');

            if ((!value || value.trim() === '') && newCategoryVal === '') {
                setInvalid(categorySelect, errorEl, 'Vui lòng chọn danh mục hoặc nhập danh mục mới');
                return false;
            }

            setValid(categorySelect);
            return true;
        }

        function validateImage() {
            const file = imageInput.files[0];
            const errorEl = document.getElementById('imageError');

            if (!file) {
                fileInputDisplay.classList.remove('is-invalid');
                return true;
            }

            if (file.size > CONFIG.maxFileSize) {
                setInvalidFile(errorEl, 'Kích thước file không được vượt quá 10MB');
                return false;
            }

            const fileName = file.name.toLowerCase();
            const extension = '.' + fileName.split('.').pop();
            if (!CONFIG.allowedExtensions.includes(extension)) {
                setInvalidFile(errorEl, 'Chỉ chấp nhận file: JPG, JPEG, PNG, GIF, WEBP');
                return false;
            }

            if (!CONFIG.allowedMimeTypes.includes(file.type)) {
                setInvalidFile(errorEl, 'Loại file không hợp lệ. Chỉ chấp nhận file ảnh.');
                return false;
            }

            fileInputDisplay.classList.remove('is-invalid');
            errorEl.style.display = 'none';
            return true;
        }

        function setInvalid(input, errorEl, message) {
            input.classList.add('is-invalid');
            input.classList.remove('is-valid');
            errorEl.textContent = message;
            errorEl.style.display = 'block';
        }

        function setValid(input) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
            try {
                var next = input.nextElementSibling;
                if (next && next.classList && next.classList.contains('invalid-feedback')) {
                    next.style.display = 'none';
                }
            } catch (e) {
            }
        }

        function setInvalidFile(errorEl, message) {
            fileInputDisplay.classList.add('is-invalid');
            errorEl.textContent = message;
            errorEl.style.display = 'block';
        }

        function updateCharCounter(input, counterId, maxLength) {
            const counter = document.getElementById(counterId);
            const currentLength = input.value.length;
            counter.textContent = currentLength;

            const counterParent = counter.parentElement;
            counterParent.classList.remove('warning', 'danger');

            if (currentLength > maxLength * 0.9) {
                counterParent.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                counterParent.classList.add('warning');
            }
        }

        function showClientErrors(errors) {
            errorList.innerHTML = '';
            errors.forEach(error => {
                const li = document.createElement('li');
                li.textContent = error;
                errorList.appendChild(li);
            });
            clientErrorsDiv.style.display = 'block';
            clientErrorsDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        function hideClientErrors() {
            clientErrorsDiv.style.display = 'none';
            errorList.innerHTML = '';
        }

        function setLoading(loading) {
            if (loading) {
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;
            } else {
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }
        }

        function previewImage(file) {
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                    removeImageBtn.style.display = 'flex';
                    fileInputDisplay.innerHTML = '<div><div class="icon">✓</div><p>Đã chọn: ' + file.name + '</p><p class="hint">Click để thay đổi</p></div>';
                }
                reader.readAsDataURL(file);
            }
        }

        function clearImagePreview() {
            imageInput.value = '';
            imagePreview.src = '';
            imagePreview.style.display = 'none';
            removeImageBtn.style.display = 'none';
            fileInputDisplay.innerHTML = '<div><div class="icon">📷</div><p>Kéo thả hoặc click để chọn ảnh</p><p class="hint">Hỗ trợ: JPG, PNG, GIF, WEBP (Tối đa 10MB)</p></div>';
            fileInputDisplay.classList.remove('is-invalid');
        }

        productNameInput.addEventListener('input', function() {
            validateProductName();
            updateCharCounter(this, 'productNameCount', CONFIG.maxProductNameLength);
        });

        manufacturerInput.addEventListener('input', validateManufacturer);
        priceInput.addEventListener('input', validatePrice);
        quantityInput.addEventListener('input', validateQuantity);
        categorySelect.addEventListener('change', validateCategory);

        productInfoInput.addEventListener('input', function() {
            updateCharCounter(this, 'productInfoCount', CONFIG.maxProductInfoLength);
        });

        productNameInput.addEventListener('blur', validateProductName);
        manufacturerInput.addEventListener('blur', validateManufacturer);
        priceInput.addEventListener('blur', validatePrice);
        quantityInput.addEventListener('blur', validateQuantity);
        categorySelect.addEventListener('blur', validateCategory);

        imageInput.addEventListener('change', function() {
            if (validateImage()) {
                previewImage(this.files[0]);
            }
        });

        removeImageBtn.addEventListener('click', clearImagePreview);

        fileInputDisplay.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.classList.add('drag-over');
        });

        fileInputDisplay.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.classList.remove('drag-over');
        });

        fileInputDisplay.addEventListener('drop', function(e) {
            e.preventDefault();
            this.classList.remove('drag-over');

            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageInput.files = files;
                if (validateImage()) {
                    previewImage(files[0]);
                }
            }
        });

        form.addEventListener('submit', function(e) {
            e.preventDefault();
            hideClientErrors();

            const errors = [];

            if (!validateProductName()) {
                errors.push('Tên sản phẩm: ' + document.getElementById('productNameError').textContent);
            }
            if (!validateManufacturer()) {
                errors.push('Nhà sản xuất: ' + document.getElementById('manufacturerError').textContent);
            }
            if (!validatePrice()) {
                errors.push('Giá: ' + document.getElementById('priceError').textContent);
            }
            if (!validateQuantity()) {
                errors.push('Số lượng: ' + document.getElementById('quantityError').textContent);
            }
            if (!validateCategory()) {
                errors.push('Danh mục: ' + document.getElementById('categoryError').textContent);
            }
            if (!validateImage()) {
                errors.push('Hình ảnh: ' + document.getElementById('imageError').textContent);
            }

            const newCategoryInput = document.getElementById('newCategoryName');
            if (newCategoryInput && newCategoryInput.value.trim().length > 255) {
                errors.push('Danh mục mới: Tên không được vượt quá 255 ký tự');
            }

            if (errors.length > 0) {
                showClientErrors(errors);
                return false;
            }

            setLoading(true);
            form.submit();
        });

        const newCategoryInput = document.getElementById('newCategoryName');
        const categorySelectEl = document.getElementById('categoryId');
        if (newCategoryInput) {
            newCategoryInput.addEventListener('input', function() {
                if (this.value.trim().length > 0) {
                    categorySelectEl.disabled = true;
                } else {
                    categorySelectEl.disabled = false;
                }
            });
        }
        if (categorySelectEl) {
            categorySelectEl.addEventListener('change', function() {
                if (this.value) {
                    newCategoryInput.value = '';
                    newCategoryInput.dispatchEvent(new Event('input'));
                }
            });
        }

        updateCharCounter(productNameInput, 'productNameCount', CONFIG.maxProductNameLength);
        updateCharCounter(productInfoInput, 'productInfoCount', CONFIG.maxProductInfoLength);
    </script>
</body>
</html>


