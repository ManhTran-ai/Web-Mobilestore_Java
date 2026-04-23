<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background: #f4f5f7;
            color: #1a1a1a;
            line-height: 1.6;
            min-height: 100vh;
        }

        .header {
            background: #1a1a1a;
            border-bottom: none;
            height: 72px;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .container {
            max-width: 1120px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 100%;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 600;
            color: #ffffff;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            height: 72px;
            text-decoration: none;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav a {
            color: #ffffff;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 400;
            transition: opacity 0.2s;
            display: inline-flex;
            align-items: center;
            height: 72px;
            line-height: normal;
        }

        .nav a:hover {
            opacity: 0.7;
        }

        .user-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .user-pill:hover {
            background: rgba(255, 255, 255, 0.15);
            opacity: 1;
        }

        .user-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.35);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
        }

        .user-name {
            font-weight: 600;
        }

        .page {
            max-width: 1120px;
            margin: 0 auto;
            padding: 32px 24px 64px;
        }

        .profile-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 900px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }
        }

        .sidebar {
            position: sticky;
            top: 96px;
        }

        .user-card {
            background: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            padding: 24px;
            text-align: center;
        }

        .user-avatar-large {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: #f4f5f7;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 12px;
        }

        .user-greeting {
            font-size: 0.9rem;
            color: #6e6e73;
            margin-bottom: 4px;
        }

        .user-display-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 2px;
        }

        .user-email {
            font-size: 0.9rem;
            color: #6e6e73;
            margin-bottom: 16px;
        }

        .user-menu {
            list-style: none;
            border-top: 1px solid #e5e5e5;
            padding-top: 12px;
            margin-top: 4px;
        }

        .user-menu li {
            margin-bottom: 2px;
        }

        .user-menu a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 8px;
            color: #1a1a1a;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 400;
            transition: background-color 0.2s;
        }

        .user-menu a:hover {
            background: #f4f5f7;
        }

        .user-menu a.active {
            background: #f4f5f7;
            color: #1a1a1a;
            font-weight: 600;
        }

        .main-content {
            min-width: 0;
        }

        .section-card {
            background: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
        }

        .section-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e5e5;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .tab-nav {
            display: flex;
            gap: 4px;
            padding: 0 24px;
            border-bottom: 1px solid #e5e5e5;
            background: #ffffff;
        }

        .tab-btn {
            border: none;
            background: transparent;
            padding: 14px 16px;
            font-size: 0.95rem;
            font-weight: 400;
            color: #6e6e73;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            margin-bottom: -1px;
            transition: all 0.2s;
        }

        .tab-btn:hover {
            color: #1a1a1a;
        }

        .tab-btn.active {
            color: #1a1a1a;
            border-bottom-color: #1a1a1a;
            font-weight: 600;
        }

        .tab-btn .badge-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 20px;
            height: 20px;
            padding: 0 6px;
            background: #e5e5e5;
            color: #6e6e73;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .tab-btn.active .badge-count {
            background: #1a1a1a;
            color: #fff;
        }

        .tab-panel {
            display: none;
            padding: 24px;
        }

        .tab-panel.active {
            display: block;
        }

        .status-message {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-message.success {
            background: #f0fdf4;
            color: #065f46;
            border: 1px solid #bbf7d0;
        }

        .status-message.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #1a1a1a;
            font-weight: 500;
            font-size: 0.95rem;
        }

        input, textarea {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: border-color 0.2s;
            background: #ffffff;
            color: #1a1a1a;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #1a1a1a;
        }

        input::placeholder, textarea::placeholder {
            color: #86868b;
        }

        textarea {
            resize: vertical;
            min-height: 90px;
        }

        select {
            width: 100%;
            padding: 14px 36px 14px 16px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: border-color 0.2s;
            background: #ffffff;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%236e6e73' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            color: #1a1a1a;
        }

        select:focus {
            outline: none;
            border-color: #1a1a1a;
        }

        select:disabled {
            background-color: #f4f5f7;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }

        .note-text {
            color: #86868b;
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .actions {
            margin-top: 28px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn {
            border: none;
            padding: 14px 24px;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #1a1a1a;
            color: #fff;
        }

        .btn-primary:hover {
            background: #333;
            transform: translateY(-1px);
        }

        .btn-ghost {
            background: #ffffff;
            color: #1a1a1a;
            border: 1px solid #e5e5e5;
        }

        .btn-ghost:hover {
            background: #f4f5f7;
        }

        .order-list {
            display: grid;
            gap: 12px;
        }

        .order-card {
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.2s;
        }

        .order-card:hover {
            border-color: #1a1a1a;
        }

        .order-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            background: #ffffff;
            cursor: pointer;
        }

        .order-card-header:hover {
            background: #f4f5f7;
        }

        .order-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .order-id {
            font-weight: 600;
            font-size: 0.95rem;
            color: #1a1a1a;
        }

        .order-date {
            font-size: 0.9rem;
            color: #86868b;
        }

        .order-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .order-total {
            font-weight: 600;
            font-size: 0.95rem;
            color: #1a1a1a;
        }

        .order-status-inline {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .order-status-inline.pending {
            background: #fff3cd;
            color: #856404;
        }

        .order-status-inline.processing {
            background: #cce5ff;
            color: #004085;
        }

        .order-status-inline.shipped {
            background: #d1ecf1;
            color: #0c5460;
        }

        .order-status-inline.delivered, .order-status-inline.completed {
            background: #d4edda;
            color: #155724;
        }

        .order-status-inline.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .order-card-body {
            display: none;
            padding: 16px 20px;
            border-top: 1px solid #e5e5e5;
        }

        .order-card-body.open {
            display: block;
        }

        .order-products {
            display: grid;
            gap: 8px;
            margin-bottom: 12px;
        }

        .order-product {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.95rem;
        }

        .order-product-name {
            color: #6e6e73;
        }

        .order-product-price {
            font-weight: 500;
            color: #1a1a1a;
        }

        .order-actions {
            display: flex;
            justify-content: flex-end;
        }

        .btn-detail {
            background: #1a1a1a;
            color: #fff;
            font-size: 0.9rem;
            padding: 10px 20px;
        }

        .btn-detail:hover {
            background: #333;
        }

        .expand-icon {
            transition: transform 0.2s;
            color: #86868b;
            font-size: 0.8rem;
        }

        .expand-icon.open {
            transform: rotate(180deg);
        }

        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: #86868b;
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 12px;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #6e6e73;
            margin-bottom: 6px;
        }

        .empty-desc {
            font-size: 0.9rem;
        }

        .empty-action {
            margin-top: 16px;
        }

        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
        }

        .product-card {
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
            background: #ffffff;
            transition: all 0.2s;
        }

        .product-card:hover {
            border-color: #1a1a1a;
        }

        .product-thumb {
            background: #f4f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
            height: 160px;
        }

        .product-thumb img {
            max-width: 100%;
            max-height: 140px;
            object-fit: contain;
        }

        .product-body {
            padding: 14px;
        }

        .product-name {
            font-weight: 500;
            font-size: 0.95rem;
            color: #1a1a1a;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .product-meta {
            font-size: 0.9rem;
            color: #86868b;
            margin-bottom: 8px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .price {
            font-weight: 600;
            font-size: 0.95rem;
            color: #1a1a1a;
        }

        .discount {
            color: #c0392b;
            font-weight: 500;
            font-size: 0.85rem;
        }

        .fav-actions {
            margin-top: 10px;
            display: flex;
            justify-content: flex-end;
        }

        .btn-remove {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            font-size: 0.85rem;
            padding: 8px 14px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-remove:hover {
            background: #fecaca;
        }

        #toast-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .toast {
            background: #1a1a1a;
            color: #fff;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            opacity: 0;
            transform: translateY(12px);
            transition: all 0.25s ease;
            max-width: 360px;
        }

        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/" class="logo">Mobile Store</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    <a href="${pageContext.request.contextPath}/products">Sản Phẩm</a>
                    <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/products">Trang Quản Lý</a>
                            </c:if>
                            <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                                <span class="user-avatar">👤</span>
                                <span class="user-name">${sessionScope.user.username}</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" style="color:#fff; font-weight:600;">Đăng Ký</a>
                            <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </div>
        </div>
    </header>

    <section class="page">
        <div class="profile-layout">
            <aside class="sidebar">
                <div class="user-card">
                    <div class="user-avatar-large">👤</div>
                    <div class="user-greeting">Xin chào</div>
                    <div class="user-display-name">${profileUser.username}</div>
                    <div class="user-email">${profileUser.email != null ? profileUser.email : 'Chưa cập nhật email'}</div>
                    <ul class="user-menu">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="menu-link" data-menu="profile">
                                Hồ sơ cá nhân
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/profile?tab=orders" class="menu-link" data-menu="orders">
                                Đơn hàng của tôi
                                <c:if test="${not empty userOrders}">
                                    <span style="margin-left:auto;font-size:0.85rem;color:#86868b;">${userOrders.size()}</span>
                                </c:if>
                            </a>
                        </li>
                    </ul>
                </div>
            </aside>

            <div class="main-content">
                <div class="section-card">
                    <div class="section-header">
                        <h1 class="section-title">Thông tin tài khoản</h1>
                    </div>

                    <nav class="tab-nav">
                        <button type="button" class="tab-btn active" data-tab="info">Thông tin chung</button>
                        <button type="button" class="tab-btn" data-tab="orders">Đơn hàng</button>
                            <c:if test="${not empty userOrders}">
                                <span class="badge-count">${userOrders.size()}</span>
                            </c:if>
                        </button>
                        <button type="button" class="tab-btn" data-tab="favorites">Yêu thích</button>
                            <c:if test="${not empty favoriteProducts}">
                                <span class="badge-count">${favoriteProducts.size()}</span>
                            </c:if>
                        </button>
                    </nav>

                    <c:if test="${not empty successMessage}">
                        <div class="status-message success">✓ ${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="status-message error">✕ ${errorMessage}</div>
                    </c:if>

                    <div id="tab-info" class="tab-panel active">
                        <form method="post" action="${pageContext.request.contextPath}/profile">
                            <input type="hidden" name="action" value="updateProfile"/>
                            <div class="form-grid">
                                <div>
                                    <label for="username">Họ và tên</label>
                                    <input type="text" id="username" name="username" value="${profileUser.username}"
                                           required minlength="3" maxlength="120"/>
                                </div>
                                <div>
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="${profileUser.email}"
                                           placeholder="email@domain.com"/>
                                </div>
                                <div>
                                    <label for="customerPhone">Số điện thoại</label>
                                    <input type="text" id="customerPhone" name="customerPhone"
                                           value="${profileUser.customerPhone}" placeholder="Nhập số điện thoại"/>
                                </div>
                                <div>
                                    <label for="provinceId">Tỉnh / Thành phố</label>
                                    <select id="provinceId" name="provinceId">
                                        <option value="">-- Chọn Tỉnh / Thành phố --</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="districtId">Quận / Huyện</label>
                                    <select id="districtId" name="districtIdSelect" disabled>
                                        <option value="">-- Chọn Quận / Huyện --</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="wardCode">Phường / Xã</label>
                                    <select id="wardCode" name="wardCodeSelect" disabled>
                                        <option value="">-- Chọn Phường / Xã --</option>
                                    </select>
                                </div>
                                <div style="grid-column:1/-1;">
                                    <label for="shippingAddress">Địa chỉ chi tiết</label>
                                    <textarea id="shippingAddress" name="shippingAddress"
                                              placeholder="Số nhà, tên đường (không bắt buộc)">${profileUser.shippingAddress}</textarea>
                                </div>
                                <div style="grid-column:1/-1;">
                                    <label for="note">Ghi chú</label>
                                    <textarea id="note" name="note"
                                              placeholder="Thông tin thêm để hỗ trợ giao hàng">${profileUser.note}</textarea>
                                </div>
                                <input type="hidden" id="districtIdHidden" name="districtId" value="${profileUser.districtId}"/>
                                <input type="hidden" id="wardCodeHiddenField" name="wardCode" value="${profileUser.wardCode}"/>
                                <div>
                                    <label for="newPassword">Mật khẩu mới</label>
                                    <input type="password" id="newPassword" name="newPassword"
                                           placeholder="Để trống nếu không đổi" minlength="6"/>
                                    <div class="note-text">Tối thiểu 6 ký tự. Chỉ cần nhập khi muốn đổi mật khẩu.</div>
                                </div>
                                <div>
                                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                           placeholder="Nhập lại mật khẩu mới" minlength="6"/>
                                </div>
                            </div>

                            <div class="actions">
                                <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
                                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/">Về trang chủ</a>
                            </div>
                        </form>
                    </div>

                    <div id="tab-orders" class="tab-panel">
                        <c:choose>
                            <c:when test="${empty userOrders}">
                                <div class="empty-state">
                                    <div class="empty-icon">📦</div>
                                    <div class="empty-title">Chưa có đơn hàng nào</div>
                                    <div class="empty-desc">Bắt đầu mua sắm để xem đơn hàng tại đây</div>
                                    <div class="empty-action">
                                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Khám phá sản phẩm</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="order-list">
                                    <c:forEach var="order" items="${userOrders}">
                                        <div class="order-card">
                                            <div class="order-card-header" onclick="toggleOrder(this)">
                                                <div class="order-left">
                                                    <div>
                                                        <div class="order-id">Đơn hàng #${order.orderId}</div>
                                                        <div class="order-date">
                                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="order-right">
                                                    <div class="order-total">
                                                        <fmt:formatNumber value="${order.totalAmount != null ? order.totalAmount : 0}" type="number" groupingUsed="true"/> đ
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'PENDING'}">
                                                            <span class="order-status-inline pending">Chờ xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'PROCESSING'}">
                                                            <span class="order-status-inline processing">Đang xử lý</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'SHIPPED'}">
                                                            <span class="order-status-inline shipped">Đang giao</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'DELIVERED'}">
                                                            <span class="order-status-inline delivered">Đã giao</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'CANCELLED'}">
                                                            <span class="order-status-inline cancelled">Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="order-status-inline pending">${order.orderStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="expand-icon">▼</span>
                                                </div>
                                            </div>
                                            <div class="order-card-body">
                                                <c:if test="${not empty order.details}">
                                                    <div class="order-products">
                                                        <c:forEach var="item" items="${order.details}">
                                                            <div class="order-product">
                                                                <span class="order-product-name">
                                                                    ${item.product != null ? item.product.productName : 'Sản phẩm'}
                                                                    <c:if test="${item.variant != null}">
                                                                        · ${item.variant.color} · ${item.variant.storage}
                                                                    </c:if>
                                                                    × ${item.quantity}
                                                                </span>
                                                                <span class="order-product-price">
                                                                    <fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true"/> đ
                                                                </span>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                                <div class="order-actions">
                                                    <a href="${pageContext.request.contextPath}/my-orders?id=${order.orderId}" class="btn btn-detail">
                                                        Xem chi tiết →
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div id="tab-favorites" class="tab-panel">
                        <c:choose>
                            <c:when test="${empty favoriteProducts}">
                                <div class="empty-state">
                                    <div class="empty-icon">❤️</div>
                                    <div class="empty-title">Chưa có sản phẩm yêu thích</div>
                                    <div class="empty-desc">Lưu lại những sản phẩm bạn thích để mua sau</div>
                                    <div class="empty-action">
                                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Khám phá sản phẩm</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="favorites-grid">
                                    <c:forEach var="product" items="${favoriteProducts}">
                                        <div class="product-card">
                                            <div class="product-thumb">
                                                <img src="${pageContext.request.contextPath}/${product.displayImage}"
                                                     alt="${product.productName}"
                                                     onerror="this.style.display='none'"/>
                                            </div>
                                            <div class="product-body">
                                                <div class="product-name">${product.productName}</div>
                                                <div class="product-meta">${product.manufacturer} · ${product.productCondition}</div>
                                                <div class="price-row">
                                                    <span class="price">
                                                        <fmt:formatNumber value="${product.displayPrice}" type="currency"
                                                                          currencySymbol="" groupingUsed="true"/> đ
                                                    </span>
                                                    <c:if test="${product.discount > 0}">
                                                        <span class="discount">-${product.discount}%</span>
                                                    </c:if>
                                                </div>
                                                <div class="fav-actions">
                                                    <form method="post" action="${pageContext.request.contextPath}/profile">
                                                        <input type="hidden" name="action" value="removeFavorite"/>
                                                        <input type="hidden" name="productId" value="${product.productId}"/>
                                                        <button type="submit" class="btn-remove">Xóa</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div id="toast-container"></div>

    <c:if test="${not empty successMessage}">
        <div id="serverSuccessMessage" style="display:none;"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div id="serverErrorMessage" style="display:none;"><c:out value="${errorMessage}"/></div>
    </c:if>

    <script>
        function toggleOrder(header) {
            const body = header.nextElementSibling;
            const icon = header.querySelector('.expand-icon');
            body.classList.toggle('open');
            icon.classList.toggle('open');
        }

        function showToast(message) {
            const container = document.getElementById('toast-container');
            if (!container) return;
            const toast = document.createElement('div');
            toast.className = 'toast';
            toast.textContent = message;
            container.appendChild(toast);
            setTimeout(() => toast.classList.add('show'), 10);
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 250);
            }, 3000);
        }

        const activeTab = '${activeTab}' || 'info';
        const tabButtons = document.querySelectorAll('.tab-btn');
        const panels = {
            info: document.getElementById('tab-info'),
            orders: document.getElementById('tab-orders'),
            favorites: document.getElementById('tab-favorites')
        };

        function setTab(tab) {
            tabButtons.forEach(btn => {
                btn.classList.toggle('active', btn.dataset.tab === tab);
            });
            Object.keys(panels).forEach(key => {
                if (panels[key]) panels[key].classList.toggle('active', key === tab);
            });
            document.querySelectorAll('.menu-link').forEach(link => {
                link.classList.toggle('active', link.dataset.menu === tab);
            });
        }

        tabButtons.forEach(btn => {
            btn.addEventListener('click', () => setTab(btn.dataset.tab));
        });

        setTab(activeTab === 'favorites' ? 'favorites' : activeTab === 'orders' ? 'orders' : 'info');

        const serverSuccessEl = document.getElementById('serverSuccessMessage');
        if (serverSuccessEl && serverSuccessEl.textContent.trim()) {
            showToast(serverSuccessEl.textContent.trim());
        }
        const serverErrorEl = document.getElementById('serverErrorMessage');
        if (serverErrorEl && serverErrorEl.textContent.trim()) {
            showToast(serverErrorEl.textContent.trim());
        }

        function refreshCartCount() {
            fetch('${pageContext.request.contextPath}/cart/count')
                .then(r => r.json())
                .then(data => {
                    const el = document.getElementById('cartCount');
                    if (el && data.count !== undefined) {
                        el.textContent = data.count;
                    }
                }).catch(() => {});
        }
        refreshCartCount();

        const ctx = '${pageContext.request.contextPath}';

        const provinceSel = document.getElementById('provinceId');
        const districtSel = document.getElementById('districtId');
        const wardSel = document.getElementById('wardCode');
        const hiddenDistrict = document.getElementById('districtIdHidden');
        const hiddenWard = document.getElementById('wardCodeHiddenField');

        const savedDistrictId = '${profileUser.districtId}';
        const savedWardCode = '${profileUser.wardCode}';

        async function loadProvinces() {
            const res = await fetch(ctx + '/api/ghn/provinces');
            const json = await res.json();
            if (json.success) {
                json.data.forEach(p => {
                    const opt = document.createElement('option');
                    opt.value = p.ProvinceID;
                    opt.textContent = p.NameExtension
                        ? p.NameExtension.find(n => n && n.trim()) || p.NameExtension[0] || p.ProvinceName
                        : p.ProvinceName;
                    provinceSel.appendChild(opt);
                });
                if (savedDistrictId) {
                    await resolveAndPrefill(savedDistrictId, savedWardCode);
                }
            }
        }

        async function resolveAndPrefill(districtId, wardCode) {
            for (const opt of provinceSel.options) {
                if (!opt.value) continue;
                const dRes = await fetch(ctx + '/api/ghn/districts?province_id=' + opt.value);
                const dJson = await dRes.json();
                if (dJson.success) {
                    const found = dJson.data.find(d => String(d.DistrictID) === String(districtId));
                    if (found) {
                        provinceSel.value = opt.value;
                        await loadDistrictsByProvince(opt.value, districtId, wardCode);
                        return;
                    }
                }
            }
        }

        async function loadDistrictsByProvince(provinceId, preselectId, preselectWard) {
            districtSel.innerHTML = '<option value="">-- Đang tải... --</option>';
            districtSel.disabled = true;
            wardSel.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';
            wardSel.disabled = true;

            if (!provinceId) {
                districtSel.innerHTML = '<option value="">-- Chọn Tỉnh trước --</option>';
                return;
            }

            const res = await fetch(ctx + '/api/ghn/districts?province_id=' + provinceId);
            const json = await res.json();
            districtSel.innerHTML = '<option value="">-- Chọn Quận / Huyện --</option>';

            if (json.success) {
                json.data.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d.DistrictID;
                    opt.textContent = d.NameExtension
                        ? d.NameExtension.find(n => n && n.trim()) || d.DistrictName
                        : d.DistrictName;
                    districtSel.appendChild(opt);
                });
                districtSel.disabled = false;

                if (preselectId) {
                    districtSel.value = preselectId;
                    await loadWardsByDistrict(preselectId, preselectWard);
                }
            }
        }

        async function loadWardsByDistrict(districtId, preselectCode) {
            wardSel.innerHTML = '<option value="">-- Đang tải... --</option>';
            wardSel.disabled = true;

            if (!districtId) {
                wardSel.innerHTML = '<option value="">-- Chọn Quận trước --</option>';
                return;
            }

            const res = await fetch(ctx + '/api/ghn/wards?district_id=' + districtId);
            const json = await res.json();
            wardSel.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';

            if (json.success) {
                json.data.forEach(w => {
                    const opt = document.createElement('option');
                    opt.value = w.WardCode;
                    opt.textContent = w.NameExtension
                        ? w.NameExtension.find(n => n && n.trim()) || w.WardName
                        : w.WardName;
                    wardSel.appendChild(opt);
                });
                wardSel.disabled = false;

                if (preselectCode) {
                    wardSel.value = preselectCode;
                    hiddenDistrict.value = districtId;
                    hiddenWard.value = preselectCode;
                }
            }
        }

        provinceSel.addEventListener('change', () => {
            loadDistrictsByProvince(provinceSel.value, null, null);
        });

        districtSel.addEventListener('change', () => {
            loadWardsByDistrict(districtSel.value, null);
            hiddenDistrict.value = districtSel.value || '';
            hiddenWard.value = '';
        });

        wardSel.addEventListener('change', () => {
            hiddenDistrict.value = districtSel.value || '';
            hiddenWard.value = wardSel.value || '';
        });

        loadProvinces();
    </script>
</body>
</html>
