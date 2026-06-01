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
            <form action="${pageContext.request.contextPath}/admin/categories/${isEdit ? 'edit' : 'add'}"
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
                    <label class="form-label" for="imageUrl">
                        Đường dẫn hình ảnh
                    </label>
                    <input type="text"
                           class="form-control"
                           id="imageUrl"
                           name="imageUrl"
                           value="${category.imageUrl}"
                           placeholder="images/categories/example.png"
                           maxlength="255">
                    <p class="help-text">Ví dụ: images/categories/iphone.png. Hình ảnh đặt trong thư mục src/main/webapp/images/categories/</p>
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
    });

    categoryNameInput.addEventListener('input', function() {
        if (this.value.trim()) {
            this.classList.remove('is-invalid');
        }
    });
</script>
</body>
</html>
