<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .table-footer { padding: 1rem 1.5rem; border-top: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }
        .table-info-count { font-size: 0.9rem; color: #888; }
        .actions { display: flex; gap: 0.5rem; }
        .form-card { background: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; margin-bottom: 2rem; }
        .form-group { margin-bottom: 1.5rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #1a1a1a; font-size: 0.95rem; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .form-control.is-invalid { border-color: #ff3b30; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e5e5ea; }
        .breadcrumb { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #888; }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="categories" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Danh mục</h1>
            <div class="header-actions">
                <button type="button" class="btn btn-primary" onclick="showAddForm()">
                    + Thêm Danh mục
                </button>
            </div>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Thêm danh mục thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Cập nhật danh mục thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Xóa danh mục thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'not_found'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không tìm thấy danh mục.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_id'}">
            <div class="alert alert-error">
                <span>&#10008;</span> ID danh mục không hợp lệ.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'delete_failed'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không thể xóa danh mục. Vui lòng kiểm tra rằng danh mục không còn sản phẩm liên kết.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>

        <div id="categoryFormSection" style="display: none;">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a>
                <span>/</span>
                <span id="formBreadcrumbText">Thêm Danh mục mới</span>
            </div>

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
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm danh mục'}
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="hideForm()">
                            Hủy bỏ
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng Danh mục</div>
                <div class="value">${categories.size()}</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Danh sách Danh mục</h3>
                <span class="table-info-count">Hiển thị ${categories.size()} danh mục</span>
            </div>
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="empty-state">
                        <div class="icon">📂</div>
                        <h3>Chưa có danh mục nào</h3>
                        <p>Bắt đầu bằng cách thêm danh mục đầu tiên</p>
                        <button type="button" class="btn btn-primary" onclick="showAddForm()">
                            + Thêm Danh mục đầu tiên
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên danh mục</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.categoryId}</td>
                                <td>${cat.categoryName}</td>
                                <td class="actions">
                                    <button type="button"
                                            class="btn btn-secondary btn-sm"
                                            onclick="showEditForm(${cat.categoryId}, '${cat.categoryName}')"
                                            title="Sửa danh mục">
                                        ✏️ Sửa
                                    </button>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${cat.categoryId}"
                                            title="Xóa danh mục">
                                        🗑️ Xóa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-icon warning">⚠️</div>
        <h3>Xác nhận xóa Danh mục</h3>
        <p>Bạn có chắc chắn muốn xóa danh mục này?</p>
        <p style="font-size: 0.85rem; color: #ff3b30;">Hành động này không thể hoàn tác!</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
            <form id="deleteForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-danger">Xóa Danh mục</button>
            </form>
        </div>
    </div>
</div>

<script>
    const formSection = document.getElementById('categoryFormSection');
    const formBreadcrumb = document.getElementById('formBreadcrumbText');
    const categoryNameInput = document.getElementById('categoryName');
    const categoryForm = document.getElementById('categoryForm');
    const deleteModal = document.getElementById('deleteModal');
    const deleteForm = document.getElementById('deleteForm');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    function showAddForm() {
        formBreadcrumb.textContent = 'Thêm Danh mục mới';
        categoryNameInput.value = '';
        categoryNameInput.classList.remove('is-invalid');
        categoryForm.action = '${pageContext.request.contextPath}/admin/categories/add';
        formSection.style.display = 'block';
        formSection.scrollIntoView({ behavior: 'smooth' });
    }

    function showEditForm(id, name) {
        formBreadcrumb.textContent = 'Sửa Danh mục';
        categoryNameInput.value = name;
        categoryNameInput.classList.remove('is-invalid');
        categoryForm.action = '${pageContext.request.contextPath}/admin/categories/edit?id=' + id;
        formSection.style.display = 'block';
        formSection.scrollIntoView({ behavior: 'smooth' });
    }

    function hideForm() {
        formSection.style.display = 'none';
    }

    categoryForm.addEventListener('submit', function(e) {
        const name = categoryNameInput.value.trim();
        if (!name) {
            e.preventDefault();
            categoryNameInput.classList.add('is-invalid');
            categoryNameInput.focus();
        } else {
            categoryNameInput.classList.remove('is-invalid');
        }
    });

    document.querySelectorAll('.delete-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const catId = this.dataset.id;
            deleteForm.action = '${pageContext.request.contextPath}/admin/categories/delete?confirm=true&id=' + catId;
            deleteModal.classList.add('active');
        });
    });

    cancelDeleteBtn.addEventListener('click', function() {
        deleteModal.classList.remove('active');
    });

    deleteModal.addEventListener('click', function(e) {
        if (e.target === deleteModal) {
            deleteModal.classList.remove('active');
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && deleteModal.classList.contains('active')) {
            deleteModal.classList.remove('active');
        }
    });

    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-success');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() { alert.style.display = 'none'; }, 500);
        });
    }, 5000);

    <c:if test="${isEdit}">
    document.addEventListener('DOMContentLoaded', function() {
        showEditForm(${category.categoryId}, '${category.categoryName}');
    });
    </c:if>
</script>
</body>
</html>
