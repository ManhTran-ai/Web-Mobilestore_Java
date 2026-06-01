<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Slider Images - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .slider-image { width: 120px; height: 60px; object-fit: cover; border-radius: 8px; background: #f5f5f7; }
        .slider-image-placeholder { width: 120px; height: 60px; border-radius: 8px; background: #f5f5f7; display: flex; align-items: center; justify-content: center; color: #888; font-size: 1.5rem; }
        .slider-url { max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-size: 0.85rem; color: #666; }
        .status-badge { margin-left: 8px; font-size: 0.85rem; }
        .status-badge.status-active { color: #34c759; }
        .status-badge.status-inactive { color: #ff9500; }
        .actions { display: flex; gap: 0.5rem; }
        .table-footer { padding: 1rem 1.5rem; border-top: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }
        .table-info-count { font-size: 0.9rem; color: #888; }

        .toggle-switch { position: relative; display: inline-block; width: 48px; height: 26px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: 0.3s; border-radius: 26px; }
        .toggle-slider:before { position: absolute; content: ""; height: 20px; width: 20px; left: 3px; bottom: 3px; background-color: white; transition: 0.3s; border-radius: 50%; }
        .toggle-switch input:checked + .toggle-slider { background-color: #34c759; }
        .toggle-switch input:checked + .toggle-slider:before { transform: translateX(22px); }

        @media (max-width: 768px) {
            .slider-image { width: 80px; height: 40px; }
        }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="sliders" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Slider Images</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/admin/sliders/add" class="btn btn-primary">
                    + Thêm Slider
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Thêm slider thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Cập nhật slider thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Xóa slider thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'toggled'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Cập nhật trạng thái thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'not_found'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không tìm thấy slider.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_id'}">
            <div class="alert alert-error">
                <span>&#10008;</span> ID slider không hợp lệ.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'delete_failed'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không thể xóa slider.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng Slider</div>
                <div class="value">${sliders.size()}</div>
            </div>
            <div class="stat-card success">
                <div class="label">Đang hiển thị</div>
                <div class="value">${activeCount}</div>
            </div>
            <div class="stat-card warning">
                <div class="label">Đã ẩn</div>
                <div class="value">${inactiveCount}</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Danh sách Slider</h3>
                <span class="table-info-count">Hiển thị ${sliders.size()} slider</span>
            </div>
            <c:choose>
                <c:when test="${empty sliders}">
                    <div class="empty-state">
                        <div class="icon">🎬</div>
                        <h3>Chưa có slider nào</h3>
                        <p>Bắt đầu bằng cách thêm slider đầu tiên cho trang chủ</p>
                        <a href="${pageContext.request.contextPath}/admin/sliders/add" class="btn btn-primary">
                            + Thêm Slider đầu tiên
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="slidersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>URL</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="slider" items="${sliders}">
                            <tr data-slider-id="${slider.id}">
                                <td>${slider.id}</td>
                                <td>
                                    <img src="${pageContext.request.contextPath}/${slider.imageUrl}"
                                         alt="Slider ${slider.id}"
                                         class="slider-image"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    <div class="slider-image-placeholder" style="display:none;">🎬</div>
                                </td>
                                <td>
                                    <div class="slider-url" title="${slider.imageUrl}">${slider.imageUrl}</div>
                                </td>
                                <td>
                                    <label class="toggle-switch">
                                        <input type="checkbox"
                                               <c:if test="${slider.isActive}">checked</c:if>
                                               data-slider-id="${slider.id}"
                                               onchange="toggleActive(this)">
                                        <span class="toggle-slider"></span>
                                    </label>
                                    <span class="status-badge ${slider.isActive ? 'status-active' : 'status-inactive'}">
                                        ${slider.isActive ? 'Hiển thị' : 'Đã ẩn'}
                                    </span>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/sliders/edit?id=${slider.id}"
                                       class="btn btn-secondary btn-sm"
                                       title="Sửa slider">
                                        ✏️ Sửa
                                    </a>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${slider.id}"
                                            title="Xóa slider">
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
        <h3>Xác nhận xóa Slider</h3>
        <p>Bạn có chắc chắn muốn xóa slider này?</p>
        <p style="font-size: 0.85rem; color: #ff3b30;">Hành động này không thể hoàn tác!</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
            <form id="deleteForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-danger">Xóa Slider</button>
            </form>
        </div>
    </div>
</div>

<script>
    const deleteModal = document.getElementById('deleteModal');
    const deleteForm = document.getElementById('deleteForm');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const sliderId = this.dataset.id;
            deleteForm.action = '${pageContext.request.contextPath}/admin/sliders/delete?id=' + sliderId;
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

    function toggleActive(checkbox) {
        const id = checkbox.dataset.sliderId;
        window.location.href = '${pageContext.request.contextPath}/admin/sliders/toggle?id=' + id;
    }

    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-success');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.style.display = 'none', 500);
        });
    }, 5000);
</script>
</body>
</html>
