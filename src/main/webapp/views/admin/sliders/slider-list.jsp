<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Slider - Trang quản lý</title>
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

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
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
            color: #888;
        }

        .slider-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .slider-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .slider-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .slider-image-container {
            position: relative;
            width: 100%;
            height: 180px;
            overflow: hidden;
        }

        .slider-image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .slider-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .slider-badge.active {
            background: #d1f2eb;
            color: #0d6848;
        }

        .slider-badge.inactive {
            background: #fdecea;
            color: #c62828;
        }

        .slider-info {
            padding: 1rem;
        }

        .slider-info .slider-id {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 0.25rem;
        }

        .slider-info .slider-url {
            font-size: 0.8rem;
            color: #888;
            word-break: break-all;
            margin-bottom: 0.75rem;
        }

        .slider-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 1rem;
            border-top: 1px solid #e5e5ea;
            background: #fafafa;
        }

        .toggle-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .toggle-label {
            font-size: 0.85rem;
            color: #666;
            font-weight: 500;
        }

        .toggle-switch {
            position: relative;
            width: 44px;
            height: 24px;
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
            border-radius: 24px;
        }

        .toggle-slider::before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }

        .toggle-switch input:checked + .toggle-slider {
            background-color: #34c759;
        }

        .toggle-switch input:checked + .toggle-slider::before {
            transform: translateX(20px);
        }

        .toggle-switch input:disabled + .toggle-slider {
            opacity: 0.5;
            cursor: not-allowed;
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

        .empty-state p {
            margin-bottom: 1.5rem;
        }

        .add-slider-card {
            background: #ffffff;
            border: 2px dashed #d1d1d6;
            border-radius: 12px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 320px;
            cursor: pointer;
            transition: all 0.2s;
            color: #888;
        }

        .add-slider-card:hover {
            border-color: #0071e3;
            color: #0071e3;
            background: #f0f7ff;
        }

        .add-slider-card .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .add-slider-card span {
            font-size: 1rem;
            font-weight: 500;
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
            max-width: 500px;
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

        .upload-form-container {
            background: #ffffff;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .upload-form-container h3 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #1a1a1a;
        }

        .upload-form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }

        .form-group {
            flex: 1;
            min-width: 250px;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #666;
            margin-bottom: 0.5rem;
        }

        .form-group input[type="file"] {
            width: 100%;
            padding: 0.625rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 0.9rem;
            background: #fafafa;
        }

        .form-group input[type="file"]:focus {
            outline: none;
            border-color: #0071e3;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.25rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #0071e3;
        }

        .checkbox-group label {
            margin-bottom: 0;
            cursor: pointer;
        }

        .preview-container {
            margin-top: 1rem;
            display: none;
        }

        .preview-container img {
            max-width: 200px;
            max-height: 120px;
            border-radius: 8px;
            border: 1px solid #e5e5ea;
        }

        .preview-container.visible {
            display: block;
        }

        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
            margin-right: 0.5rem;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .toast {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: slideIn 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .toast.success {
            background: #d1f2eb;
            color: #0d6848;
            border: 1px solid #a3e4d7;
        }

        .toast.error {
            background: #fdecea;
            color: #c62828;
            border: 1px solid #f5c6cb;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @media (max-width: 1200px) {
            .stats-row {
                grid-template-columns: repeat(3, 1fr);
            }
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

            .slider-grid {
                grid-template-columns: 1fr;
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
                    <a href="${pageContext.request.contextPath}/admin/products" ${activeMenu == 'products' ? 'class="active"' : ''}>
                        Sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" ${activeMenu == 'orders' ? 'class="active"' : ''}>
                        Đơn hàng
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/sliders" class="active">
                        Slider
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Slider</h1>
            <div class="header-actions">
            </div>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10003;</span> Thêm slider thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10003;</span> Xóa slider thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'upload_failed'}">
            <div class="alert alert-error">
                <span>&#10007;</span> Upload ảnh thất bại. Vui lòng kiểm tra file.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'no_image'}">
            <div class="alert alert-error">
                <span>&#10007;</span> Vui lòng chọn file ảnh.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'save_failed'}">
            <div class="alert alert-error">
                <span>&#10007;</span> Không thể lưu slider. Vui lòng thử lại.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'delete_failed'}">
            <div class="alert alert-error">
                <span>&#10007;</span> Không thể xóa slider. Vui lòng thử lại.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'not_found'}">
            <div class="alert alert-error">
                <span>&#10007;</span> Không tìm thấy slider.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng slider</div>
                <div class="value">${totalSliders}</div>
            </div>
            <div class="stat-card success">
                <div class="label">Đang hiển thị</div>
                <div class="value">${activeSliders}</div>
            </div>
            <div class="stat-card warning">
                <div class="label">Đang ẩn</div>
                <div class="value">${hiddenSliders}</div>
            </div>
        </div>

        <div class="upload-form-container">
            <h3>Thêm Slider Mới</h3>
            <form method="POST" action="${pageContext.request.contextPath}/admin/sliders/add"
                  enctype="multipart/form-data" class="upload-form" id="uploadForm">
                <div class="form-group">
                    <label for="sliderImage">Chọn hình ảnh</label>
                    <input type="file" id="sliderImage" name="image" accept="image/*" required>
                    <div class="preview-container" id="previewContainer">
                        <img id="previewImage" src="" alt="Preview">
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="isActive" name="isActive" value="1" checked>
                        <label for="isActive">Hiển thị ngay sau khi tải lên</label>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    + Thêm Slider
                </button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty sliders}">
                <div class="slider-grid">
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <div class="icon">&#128444;</div>
                        <h3>Chưa có slider nào</h3>
                        <p>Thêm slider đầu tiên bằng form bên trên</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="slider-grid" id="sliderGrid">
                    <c:forEach var="slider" items="${sliders}">
                        <div class="slider-card" data-id="${slider.id}">
                            <div class="slider-image-container">
                                <img src="${pageContext.request.contextPath}/${slider.imageUrl}"
                                     alt="Slider ${slider.id}"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="product-image-placeholder" style="display:none; align-items:center; justify-content:center; width:100%; height:180px; background:#f5f5f7; border-radius:0; color:#888; font-size:2rem;">&#128444;</div>
                                <span class="slider-badge ${slider.isActive ? 'active' : 'inactive'}">
                                        ${slider.isActive ? 'Hiển thị' : 'Đã ẩn'}
                                    </span>
                            </div>
                            <div class="slider-info">
                                <div class="slider-id">ID: ${slider.id}</div>
                                <div class="slider-url">${slider.imageUrl}</div>
                            </div>
                            <div class="slider-actions">
                                <div class="toggle-container">
                                    <label class="toggle-switch">
                                        <input type="checkbox"
                                               class="toggle-input"
                                               data-id="${slider.id}"
                                               ${slider.isActive ? 'checked' : ''}>
                                        <span class="toggle-slider"></span>
                                    </label>
                                    <span class="toggle-label">
                                            ${slider.isActive ? 'Bật' : 'Tắt'}
                                        </span>
                                </div>
                                <button type="button"
                                        class="btn btn-danger btn-sm delete-slider-btn"
                                        data-id="${slider.id}">
                                    &#128465; Xóa
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-icon warning">&#9888;</div>
        <h3>Xác nhận xóa slider</h3>
        <p>Bạn có chắc chắn muốn xóa slider này?<br>Hành động này không thể hoàn tác!</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
            <form id="deleteForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">
                    Xóa slider
                </button>
            </form>
        </div>
    </div>
</div>

<div class="toast-container" id="toastContainer"></div>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Preview image before upload
    const fileInput = document.getElementById('sliderImage');
    const previewContainer = document.getElementById('previewContainer');
    const previewImage = document.getElementById('previewImage');

    if (fileInput) {
        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    previewContainer.classList.add('visible');
                };
                reader.readAsDataURL(file);
            } else {
                previewContainer.classList.remove('visible');
            }
        });
    }

    // Toggle active/inactive
    document.querySelectorAll('.toggle-input').forEach(function(toggle) {
        toggle.addEventListener('change', function() {
            const id = this.dataset.id;
            const toggleLabel = this.closest('.toggle-container').querySelector('.toggle-label');
            const card = this.closest('.slider-card');
            const badge = card.querySelector('.slider-badge');
            const sliderContainer = document.getElementById('sliderGrid');

            this.disabled = true;

            fetch(contextPath + '/admin/sliders/toggle?id=' + id, {
                method: 'POST'
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    const isActive = data.isActive;

                    // Update toggle
                    toggle.checked = isActive;
                    toggle.disabled = false;
                    toggleLabel.textContent = isActive ? 'Bật' : 'Tắt';

                    // Update badge
                    badge.className = 'slider-badge ' + (isActive ? 'active' : 'inactive');
                    badge.textContent = isActive ? 'Hiển thị' : 'Đã ẩn';

                    // Update stats
                    updateStats(isActive);

                    // Show toast
                    showToast(isActive ? 'Đã bật hiển thị slider' : 'Đã ẩn slider', 'success');
                } else {
                    toggle.checked = !toggle.checked;
                    toggle.disabled = false;
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(function(err) {
                toggle.checked = !toggle.checked;
                toggle.disabled = false;
                showToast('Có lỗi xảy ra: ' + err.message, 'error');
            });
        });
    });

    function updateStats(isNowActive) {
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach(function(card) {
            const label = card.querySelector('.label');
            const value = card.querySelector('.value');
            if (label && value) {
                if (label.textContent === 'Đang hiển thị') {
                    let current = parseInt(value.textContent) || 0;
                    value.textContent = isNowActive ? current + 1 : Math.max(0, current - 1);
                } else if (label.textContent === 'Đang ẩn') {
                    let current = parseInt(value.textContent) || 0;
                    value.textContent = isNowActive ? Math.max(0, current - 1) : current + 1;
                }
            }
        });
    }

    // Delete modal
    const deleteModal = document.getElementById('deleteModal');
    const deleteForm = document.getElementById('deleteForm');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    document.querySelectorAll('.delete-slider-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const id = this.dataset.id;
            deleteForm.action = contextPath + '/admin/sliders/delete?confirm=true&id=' + id;
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

    // Toast notification
    function showToast(message, type) {
        const container = document.getElementById('toastContainer');
        const toast = document.createElement('div');
        toast.className = 'toast ' + type;
        toast.innerHTML = (type === 'success' ? '&#10003; ' : '&#10007; ') + message;
        container.appendChild(toast);

        setTimeout(function() {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(100%)';
            toast.style.transition = 'opacity 0.5s, transform 0.5s';
            setTimeout(function() {
                if (toast.parentElement) {
                    toast.parentElement.removeChild(toast);
                }
            }, 500);
        }, 3000);
    }

    // Auto-dismiss alerts
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-success');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() { alert.style.display = 'none'; }, 500);
        });
    }, 5000);

    // Submit button loading state
    const uploadForm = document.getElementById('uploadForm');
    const submitBtn = document.getElementById('submitBtn');
    if (uploadForm && submitBtn) {
        uploadForm.addEventListener('submit', function() {
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="loading-spinner"></span> Đang tải lên...';
        });
    }
</script>
</body>
</html>
