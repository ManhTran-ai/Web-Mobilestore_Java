<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa Slider' : 'Thêm Slider'} - Trang quản lý</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #1a1a1a; background-color: #f5f5f7; }
        .admin-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1a1a1a; color: #ffffff; padding: 2rem 0; position: fixed; height: 100vh; overflow-y: auto; }
        .sidebar-header { padding: 0 1.5rem 2rem; border-bottom: 1px solid #333; margin-bottom: 1rem; }
        .sidebar-header h2 { font-size: 1.25rem; font-weight: 600; color: #ffffff; }
        .sidebar-header span { font-size: 0.875rem; color: #888; }
        .sidebar-nav { list-style: none; }
        .sidebar-nav li { margin: 0.25rem 0; }
        .sidebar-nav a { display: flex; align-items: center; padding: 0.875rem 1.5rem; color: #ccc; text-decoration: none; transition: all 0.2s; font-size: 0.95rem; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background: #333; color: #ffffff; }
        .sidebar-nav a.active { border-left: 3px solid #0071e3; }
        .sidebar-nav .icon { margin-right: 0.75rem; font-size: 1.1rem; }
        .main-content { flex: 1; margin-left: 260px; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header h1 { font-size: 1.75rem; font-weight: 600; color: #1a1a1a; }
        .breadcrumb { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #888; }
        .form-card { background: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; max-width: 600px; }
        .form-group { margin-bottom: 1.5rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #1a1a1a; font-size: 0.95rem; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .form-control::placeholder { color: #aaa; }
        .form-control.is-invalid { border-color: #ff3b30; }
        .help-text { font-size: 0.85rem; color: #888; margin-top: 0.375rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e5e5ea; }
        .btn { display: inline-flex; align-items: center; justify-content: center; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 0.95rem; font-weight: 500; text-decoration: none; cursor: pointer; transition: all 0.2s; border: none; font-family: inherit; }
        .btn-primary { background: #0071e3 !important; color: #ffffff !important; }
        .btn-primary:hover { background: #0077ed !important; }
        .btn-secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn-secondary:hover { background: #d1d1d6 !important; }
        .alert { padding: 1rem 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-error { background: #fdecea; color: #c62828; border: 1px solid #f5c6cb; }
        .image-preview-container { margin-top: 1rem; }
        .current-image { max-width: 100%; max-height: 300px; border-radius: 12px; border: 2px dashed #e5e5ea; object-fit: contain; background: #f9f9fb; }
        .image-upload-area { border: 2px dashed #d1d1d6; border-radius: 12px; padding: 2rem; text-align: center; cursor: pointer; transition: all 0.2s; background: #f9f9fb; }
        .image-upload-area:hover { border-color: #0071e3; background: #f0f7ff; }
        .image-upload-area.dragover { border-color: #0071e3; background: #e8f4fd; }
        .image-upload-icon { font-size: 3rem; margin-bottom: 1rem; color: #888; }
        .image-upload-text { color: #666; font-size: 0.95rem; }
        .image-upload-text strong { color: #0071e3; }
        .image-upload-hint { color: #888; font-size: 0.85rem; margin-top: 0.5rem; }
        .file-input-hidden { display: none; }
        .preview-image { max-width: 100%; max-height: 250px; border-radius: 8px; margin-top: 1rem; object-fit: contain; }
        .toggle-group { display: flex; align-items: center; gap: 1rem; }
        .toggle-switch { position: relative; display: inline-block; width: 48px; height: 26px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: 0.3s; border-radius: 26px; }
        .toggle-slider:before { position: absolute; content: ""; height: 20px; width: 20px; left: 3px; bottom: 3px; background-color: white; transition: 0.3s; border-radius: 50%; }
        .toggle-switch input:checked + .toggle-slider { background-color: #34c759; }
        .toggle-switch input:checked + .toggle-slider:before { transform: translateX(22px); }
        .toggle-label { font-size: 0.95rem; color: #666; }
        .toggle-label.active { color: #34c759; font-weight: 500; }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; }
            .form-card { padding: 1.5rem; }
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
                    <a href="${pageContext.request.contextPath}/admin/products">
                        Sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders">
                        Đơn hàng
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/sliders" class="active">
                        Slider Images
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/sliders">Slider Images</a>
            <span>/</span>
            <span>${isEdit ? 'Sửa Slider' : 'Thêm Slider mới'}</span>
        </div>

        <div class="page-header">
            <h1>${isEdit ? 'Sửa Slider' : 'Thêm Slider mới'}</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <strong>&#10060; Lỗi:</strong> ${error}
            </div>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/sliders/${isEdit ? 'edit' : 'add'}"
                  method="post"
                  enctype="multipart/form-data"
                  id="sliderForm">

                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${slider.id}">
                </c:if>

                <div class="form-group">
                    <label class="form-label">Hình ảnh Slider <span class="required">*</span></label>

                    <c:if test="${isEdit && not empty slider.imageUrl}">
                        <div class="image-preview-container">
                            <p class="help-text" style="margin-bottom: 0.5rem;">Hình ảnh hiện tại:</p>
                            <img src="${pageContext.request.contextPath}/${slider.imageUrl}"
                                 alt="Current Slider"
                                 class="current-image"
                                 id="currentImage">
                        </div>
                        <p class="help-text" style="margin-top: 1rem;">Chọn ảnh mới để thay thế (để trống nếu giữ nguyên):</p>
                    </c:if>

                    <div class="image-upload-area" id="uploadArea">
                        <div class="image-upload-icon">&#128247;</div>
                        <p class="image-upload-text">
                            <strong>Click để chọn ảnh</strong> hoặc kéo thả ảnh vào đây
                        </p>
                        <p class="image-upload-hint">Định dạng: JPG, PNG, GIF, WebP. Kích thước tối đa: 10MB</p>
                        <input type="file"
                               id="imageInput"
                               name="image"
                               class="file-input-hidden"
                               accept=".jpg,.jpeg,.png,.gif,.webp">
                        <img id="previewImage" class="preview-image" style="display: none;">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Trạng thái hiển thị</label>
                    <div class="toggle-group">
                        <label class="toggle-switch">
                            <input type="checkbox"
                                   name="isActive"
                                   id="isActive"
                                   value="1"
                                   ${slider.isActive || empty slider ? 'checked' : ''}>
                            <span class="toggle-slider"></span>
                        </label>
                        <span class="toggle-label" id="statusLabel">
                            ${slider.isActive || empty slider ? 'Đang hiển thị' : 'Đã ẩn'}
                        </span>
                    </div>
                    <p class="help-text">Bật/tắt để slider có hiển thị trên trang chủ hay không</p>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        ${isEdit ? 'Cập nhật Slider' : 'Thêm Slider'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/sliders" class="btn btn-secondary">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    const uploadArea = document.getElementById('uploadArea');
    const imageInput = document.getElementById('imageInput');
    const previewImage = document.getElementById('previewImage');
    const currentImage = document.getElementById('currentImage');
    const isActiveCheckbox = document.getElementById('isActive');
    const statusLabel = document.getElementById('statusLabel');
    const sliderForm = document.getElementById('sliderForm');

    uploadArea.addEventListener('click', function() {
        imageInput.click();
    });

    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleFile(files[0]);
        }
    });

    imageInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            handleFile(this.files[0]);
        }
    });

    function handleFile(file) {
        if (!file.type.match(/^image\/(jpeg|jpg|png|gif|webp)$/)) {
            alert('Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WebP)');
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('File ảnh phải nhỏ hơn 10MB');
            return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
            previewImage.src = e.target.result;
            previewImage.style.display = 'block';
            if (currentImage) {
                currentImage.style.display = 'none';
            }
        };
        reader.readAsDataURL(file);
    }

    isActiveCheckbox.addEventListener('change', function() {
        if (this.checked) {
            statusLabel.textContent = 'Đang hiển thị';
            statusLabel.classList.add('active');
        } else {
            statusLabel.textContent = 'Đã ẩn';
            statusLabel.classList.remove('active');
        }
    });

    sliderForm.addEventListener('submit', function(e) {
        if (!imageInput.files || imageInput.files.length === 0) {
            <c:choose>
                <c:when test="${isEdit}">
                </c:when>
                <c:otherwise>
                    e.preventDefault();
                    alert('Vui lòng chọn hình ảnh slider');
                </c:otherwise>
            </c:choose>
        }
    });
</script>
</body>
</html>
