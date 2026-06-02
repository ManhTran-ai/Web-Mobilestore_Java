<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa Danh mục' : 'Thêm Danh mục'} - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .breadcrumb { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #888; }
        .form-card { background: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; max-width: 600px; }
        .form-group { margin-bottom: 1.5rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #1a1a1a; font-size: 0.95rem; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .form-control.is-invalid { border-color: #ff3b30; }
        .help-text { font-size: 0.85rem; color: #888; margin-top: 0.375rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e5e5ea; }
        .image-upload-container { display: flex; flex-direction: column; gap: 1rem; }
        .image-preview { width: 200px; height: 200px; border: 2px dashed #d1d1d6; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; background: #f5f5f7; }
        .image-preview img { max-width: 100%; max-height: 100%; object-fit: contain; }
        .image-preview.empty { color: #888; font-size: 0.9rem; }
        .file-input-wrapper { position: relative; }
        .file-input-wrapper input[type="file"] { position: absolute; opacity: 0; width: 100%; height: 100%; cursor: pointer; }
        .file-input-btn { display: inline-block; padding: 0.75rem 1.5rem; background: #f5f5f7; border: 1px solid #d1d1d6; border-radius: 8px; cursor: pointer; font-size: 0.95rem; transition: background 0.2s; }
        .file-input-wrapper:hover .file-input-btn { background: #e5e5ea; }
        .hidden-field { display: none; }
        .upload-status { font-size: 0.85rem; margin-top: 0.5rem; }
        .upload-status.success { color: #34c759; }
        .upload-status.error { color: #ff3b30; }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="categories" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a>
            <span>/</span>
            <span>${isEdit ? 'Sửa Danh mục' : 'Thêm Danh mục mới'}</span>
        </div>

        <div class="page-header">
            <h1>${isEdit ? 'Sửa Danh mục' : 'Thêm Danh mục mới'}</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <strong>&#10060; Lỗi:</strong> ${error}
            </div>
        </c:if>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/categories/${isEdit ? 'edit' : 'add'}${isEdit ? '?id='.concat(category.categoryId) : ''}"
                  method="post"
                  id="categoryForm">

                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${category.categoryId}">
                </c:if>

                <div class="form-group">
                    <label class="form-label" for="categoryName">
                        Tên danh mục <span class="required">*</span>
                    </label>
                    <input type="text"
                           class="form-control"
                           id="categoryName"
                           name="name"
                           value="${category.categoryName}"
                           placeholder="Nhập tên danh mục"
                           maxlength="255"
                           required>
                    <p class="help-text">Tối đa 255 ký tự. Tên danh mục phải là duy nhất.</p>
                </div>

                <div class="form-group">
                    <label class="form-label" for="content">
                        Mô tả
                    </label>
                    <textarea class="form-control"
                              id="content"
                              name="content"
                              rows="3"
                              maxlength="500"
                              placeholder="Nhập mô tả danh mục">${category.content}</textarea>
                    <p class="help-text">Tối đa 500 ký tự.</p>
                </div>

                <div class="form-group">
                    <label class="form-label" for="imageFile">
                        Hình ảnh danh mục
                    </label>
                    <div class="image-upload-container">
                        <div class="image-preview ${not empty category.imageUrl ? '' : 'empty'}" id="imagePreview">
                            <c:choose>
                                <c:when test="${not empty category.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/${category.imageUrl}" alt="Preview">
                                </c:when>
                                <c:otherwise>
                                    <span>Chưa chọn hình</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="file-input-wrapper">
                            <input type="file"
                                   id="imageFile"
                                   name="imageFile"
                                   accept="image/*"
                                   onchange="handleImageSelect(this)">
                            <span class="file-input-btn">
                                <i class="fas fa-upload"></i> Chọn hình ảnh
                            </span>
                        </div>
                        <input type="hidden" id="imageUrl" name="imageUrl" value="${category.imageUrl}">
                        <p class="help-text" id="uploadStatus">Chọn hình ảnh từ máy tính. Định dạng: JPG, PNG, GIF, WebP. Kích thước tối đa: 5MB.</p>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${isEdit ? 'Cập nhật' : 'Thêm danh mục'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    const categoryForm = document.getElementById('categoryForm');
    const categoryNameInput = document.getElementById('categoryName');
    const imageFileInput = document.getElementById('imageFile');
    const imageUrlInput = document.getElementById('imageUrl');
    const imagePreview = document.getElementById('imagePreview');
    const uploadStatus = document.getElementById('uploadStatus');
    let pendingImageFile = null;

    function handleImageSelect(input) {
        const file = input.files[0];
        if (!file) return;

        if (!file.type.startsWith('image/')) {
            uploadStatus.textContent = 'Chỉ chấp nhận file hình ảnh';
            uploadStatus.className = 'upload-status error';
            input.value = '';
            return;
        }

        if (file.size > 5 * 1024 * 1024) {
            uploadStatus.textContent = 'Kích thước file không được vượt quá 5MB';
            uploadStatus.className = 'upload-status error';
            input.value = '';
            return;
        }

        pendingImageFile = file;
        uploadStatus.textContent = 'Đang tải lên...';
        uploadStatus.className = 'upload-status';

        const formData = new FormData();
        formData.append('image', file);

        fetch('${pageContext.request.contextPath}/admin/categories/upload-image', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                imageUrlInput.value = data.imageUrl;
                imagePreview.innerHTML = '<img src="${pageContext.request.contextPath}/' + data.imageUrl + '" alt="Preview">';
                imagePreview.classList.remove('empty');
                uploadStatus.textContent = 'Tải lên thành công!';
                uploadStatus.className = 'upload-status success';
                pendingImageFile = null;
            } else {
                uploadStatus.textContent = data.message || 'Lỗi khi tải lên';
                uploadStatus.className = 'upload-status error';
                pendingImageFile = null;
                input.value = '';
            }
        })
        .catch(error => {
            uploadStatus.textContent = 'Lỗi kết nối: ' + error.message;
            uploadStatus.className = 'upload-status error';
            pendingImageFile = null;
            input.value = '';
        });
    }

    categoryForm.addEventListener('submit', function(e) {
        const name = categoryNameInput.value.trim();
        if (!name) {
            e.preventDefault();
            categoryNameInput.classList.add('is-invalid');
            categoryNameInput.focus();
        } else if (name.length > 255) {
            e.preventDefault();
            categoryNameInput.classList.add('is-invalid');
            categoryNameInput.focus();
        } else {
            categoryNameInput.classList.remove('is-invalid');
        }

        if (pendingImageFile) {
            e.preventDefault();
            uploadStatus.textContent = 'Vui lòng đợi hình ảnh đang được tải lên...';
            uploadStatus.className = 'upload-status error';
        }
    });

    categoryNameInput.addEventListener('input', function() {
        if (this.value.trim()) {
            this.classList.remove('is-invalid');
        }
    });
</script>
</body>
</html>
