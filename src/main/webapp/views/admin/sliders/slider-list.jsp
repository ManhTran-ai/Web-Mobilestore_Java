<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Slider Images - Trang quản lý</title>
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

        .header-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary {
            background: #0071e3 !important;
            color: #ffffff !important;
        }

        .btn-primary:hover {
            background: #0077ed !important;
        }

        .btn-danger {
            background: #ff3b30 !important;
            color: #ffffff !important;
        }

        .btn-danger:hover {
            background: #ff453a !important;
        }

        .btn-secondary {
            background: #e5e5ea !important;
            color: #1a1a1a !important;
        }

        .btn-secondary:hover {
            background: #d1d1d6 !important;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background: #d1f2eb;
            color: #0d6848;
            border: 1px solid #a3e4d7;
        }

        .alert-error {
            background: #fdecea;
            color: #c62828;
            border: 1px solid #f5c6cb;
        }

        .alert .close-btn {
            margin-left: auto;
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
            opacity: 0.5;
            transition: opacity 0.2s;
        }

        .alert .close-btn:hover {
            opacity: 1;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .stat-card .label {
            font-size: 0.85rem;
            color: #888;
            margin-bottom: 0.5rem;
        }

        .stat-card .value {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .stat-card.primary .value {
            color: #0071e3;
        }

        .stat-card.success .value {
            color: #34c759;
        }

        .stat-card.warning .value {
            color: #ff9500;
        }

        .table-container {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e5ea;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 1rem 1.25rem;
            text-align: left;
            border-bottom: 1px solid #e5e5ea;
        }

        .data-table th {
            background: #f5f5f7;
            font-weight: 600;
            color: #666;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table tbody tr {
            transition: background 0.2s;
        }

        .data-table tbody tr:hover {
            background: #fafafa;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .slider-image {
            width: 120px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            background: #f5f5f7;
        }

        .slider-image-placeholder {
            width: 120px;
            height: 60px;
            border-radius: 8px;
            background: #f5f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 1.5rem;
        }

        .slider-url {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 0.85rem;
            color: #666;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 26px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.3s;
            border-radius: 26px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
        }

        .toggle-switch input:checked + .toggle-slider {
            background-color: #34c759;
        }

        .toggle-switch input:checked + .toggle-slider:before {
            transform: translateX(22px);
        }

        .actions {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #888;
        }

        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: #666;
        }

        .table-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid #e5e5ea;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-info {
            font-size: 0.9rem;
            color: #888;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal {
            background: #ffffff;
            border-radius: 16px;
            padding: 2rem;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalIn 0.3s ease;
        }

        @keyframes modalIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .modal-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .modal-icon.warning {
            color: #ff3b30;
        }

        .modal h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
        }

        .modal p {
            color: #666;
            margin-bottom: 1.5rem;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .modal-actions .btn {
            min-width: 120px;
        }

        .table-info-count {
            font-size: 0.9rem;
            color: #888;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .data-table {
                font-size: 0.875rem;
            }

            .data-table th,
            .data-table td {
                padding: 0.75rem;
            }

            .slider-image {
                width: 80px;
                height: 40px;
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        Dashboard
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
                        <div class="icon">&#127909;</div>
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
                                    <div class="slider-image-placeholder" style="display:none;">&#127909;</div>
                                </td>
                                <td>
                                    <div class="slider-url" title="${slider.imageUrl}">${slider.imageUrl}</div>
                                </td>
                                <td>
                                    <label class="toggle-switch">
                                        <input type="checkbox"
                                               ${slider.isActive ? 'checked' : ''}
                                               onchange="toggleActive(${slider.id}, this.checked)">
                                        <span class="toggle-slider"></span>
                                    </label>
                                    <span style="margin-left: 8px; font-size: 0.85rem; color: ${slider.isActive ? '#34c759' : '#ff9500'};">
                                            ${slider.isActive ? 'Hiển thị' : 'Đã ẩn'}
                                        </span>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/sliders/edit?id=${slider.id}"
                                       class="btn btn-secondary btn-sm"
                                       title="Sửa slider">
                                        &#9998; Sửa
                                    </a>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${slider.id}"
                                            title="Xóa slider">
                                        &#128465; Xóa
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
        <div class="modal-icon warning">&#9888;</div>
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

    function toggleActive(id, isActive) {
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
