<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi đơn hàng #${trackingOrder.orderId}</title>
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
            height: 72px;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .container {
            max-width: 960px;
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

        .page {
            max-width: 960px;
            margin: 0 auto;
            padding: 32px 24px 64px;
        }

        .page-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-title a {
            color: #6e6e73;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 400;
            transition: color 0.2s;
        }

        .page-title a:hover {
            color: #1a1a1a;
        }

        .tracking-layout {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .tracking-layout {
                grid-template-columns: 1fr;
            }
        }

        .card {
            background: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e5e5;
        }

        .card-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .card-body {
            padding: 24px;
        }

        .timeline {
            position: relative;
            padding-left: 32px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 11px;
            top: 8px;
            bottom: 8px;
            width: 2px;
            background: #e5e5e5;
        }

        .timeline-item {
            position: relative;
            padding-bottom: 28px;
        }

        .timeline-item:last-child {
            padding-bottom: 0;
        }

        .timeline-dot {
            position: absolute;
            left: -28px;
            top: 4px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #d0d0d0;
            border: 2px solid #ffffff;
            z-index: 1;
        }

        .timeline-dot.active {
            background: #34c759;
            box-shadow: 0 0 0 4px rgba(52, 199, 89, 0.2);
        }

        .timeline-dot.current {
            background: #007aff;
            box-shadow: 0 0 0 4px rgba(0, 122, 255, 0.2);
        }

        .timeline-dot.pending {
            background: #d0d0d0;
        }

        .timeline-time {
            font-size: 0.8rem;
            color: #86868b;
            margin-bottom: 2px;
        }

        .timeline-status {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 2px;
        }

        .timeline-desc {
            font-size: 0.9rem;
            color: #6e6e73;
            line-height: 1.5;
        }

        .empty-timeline {
            text-align: center;
            padding: 40px 20px;
            color: #86868b;
        }

        .empty-timeline-icon {
            font-size: 3rem;
            margin-bottom: 12px;
            opacity: 0.4;
        }

        .empty-timeline-text {
            font-size: 0.95rem;
            margin-bottom: 8px;
            color: #6e6e73;
        }

        .empty-timeline-sub {
            font-size: 0.85rem;
            color: #86868b;
        }

        .order-meta {
            display: grid;
            gap: 16px;
        }

        .meta-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
        }

        .meta-label {
            font-size: 0.9rem;
            color: #86868b;
            flex-shrink: 0;
        }

        .meta-value {
            font-size: 0.9rem;
            color: #1a1a1a;
            text-align: right;
            word-break: break-word;
        }

        .meta-value.bold {
            font-weight: 600;
        }

        .tracking-number-box {
            background: #f9f9fb;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            padding: 12px 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tracking-icon {
            width: 36px;
            height: 36px;
            background: #007aff;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1.1rem;
        }

        .tracking-info {
            min-width: 0;
        }

        .tracking-label {
            font-size: 0.8rem;
            color: #86868b;
        }

        .tracking-code {
            font-size: 0.9rem;
            font-weight: 600;
            color: #1a1a1a;
            font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
        }

        .no-tracking {
            background: #fff9e6;
            border: 1px solid #ffe680;
            border-radius: 8px;
            padding: 14px 16px;
            font-size: 0.9rem;
            color: #856404;
            line-height: 1.5;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.processing {
            background: #cce5ff;
            color: #004085;
        }

        .status-badge.shipped {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-badge.delivered, .status-badge.completed {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 14px 20px;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-back {
            background: #ffffff;
            color: #1a1a1a;
            border: 1px solid #e5e5e5;
            margin-top: 4px;
        }

        .btn-back:hover {
            background: #f4f5f7;
        }

        .btn-primary {
            background: #007aff;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #0056b3;
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
                            <a href="${pageContext.request.contextPath}/profile" class="user-avatar" title="${sessionScope.user.username}">👤</a>
                            <a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                        </c:otherwise>
                    </c:choose>
                </nav>
            </div>
        </div>
    </header>

    <section class="page">
        <h1 class="page-title">
            <a href="${pageContext.request.contextPath}/profile?tab=orders">Đơn hàng của tôi</a>
            <span>/</span>
            Theo dõi đơn hàng #${trackingOrder.orderId}
        </h1>

        <div class="tracking-layout">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Hành trình đơn hàng</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty shippingHistory}">
                            <div class="timeline">
                                <c:forEach var="step" items="${shippingHistory}" varStatus="loop">
                                    <div class="timeline-item">
                                        <div class="timeline-dot ${loop.first ? 'current' : ''} ${loop.index == 1 ? 'active' : ''} ${loop.index > 1 ? 'pending' : ''}"></div>
                                        <div class="timeline-time">
                                            <fmt:formatDate value="${step.updatedDate}" pattern="HH:mm - dd/MM/yyyy"/>
                                        </div>
                                        <div class="timeline-status">${step.statusName}</div>
                                        <c:if test="${not empty step.statusDescription}">
                                            <div class="timeline-desc">${step.statusDescription}</div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-timeline">
                                <div class="empty-timeline-icon">📦</div>
                                <div class="empty-timeline-text">Chưa có thông tin vận chuyển</div>
                                <div class="empty-timeline-sub">
                                    <c:choose>
                                        <c:when test="${empty trackingOrder.trackingNumber}">
                                            Mã vận đơn chưa được cập nhật. Vui lòng chờ cửa hàng xác nhận đơn hàng.
                                        </c:when>
                                        <c:otherwise>
                                            Không tìm thấy lịch sử vận chuyển cho mã vận đơn này.
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div style="display:grid;gap:20px;">
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">Mã vận đơn</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty trackingOrder.trackingNumber}">
                                <div class="tracking-number-box">
                                    <div class="tracking-icon">🚚</div>
                                    <div class="tracking-info">
                                        <div class="tracking-label">Mã GHN</div>
                                        <div class="tracking-code">${trackingOrder.trackingNumber}</div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-tracking">
                                    Mã vận đơn chưa được cập nhật. Mã sẽ được cung cấp sau khi đơn hàng được xác nhận và chuyển cho đơn vị vận chuyển.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <span class="card-title">Thông tin đơn hàng</span>
                    </div>
                    <div class="card-body">
                        <div class="order-meta">
                            <div class="meta-row">
                                <span class="meta-label">Mã đơn</span>
                                <span class="meta-value bold">#${trackingOrder.orderId}</span>
                            </div>
                            <div class="meta-row">
                                <span class="meta-label">Ngày đặt</span>
                                <span class="meta-value">
                                    <fmt:formatDate value="${trackingOrder.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="meta-row">
                                <span class="meta-label">Trạng thái</span>
                                <span class="meta-value">
                                    <c:choose>
                                        <c:when test="${trackingOrder.orderStatus == 'PENDING'}">
                                            <span class="status-badge pending">Chờ xác nhận</span>
                                        </c:when>
                                        <c:when test="${trackingOrder.orderStatus == 'PROCESSING'}">
                                            <span class="status-badge processing">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${trackingOrder.orderStatus == 'SHIPPED'}">
                                            <span class="status-badge shipped">Đang giao hàng</span>
                                        </c:when>
                                        <c:when test="${trackingOrder.orderStatus == 'DELIVERED'}">
                                            <span class="status-badge delivered">Đã giao hàng</span>
                                        </c:when>
                                        <c:when test="${trackingOrder.orderStatus == 'CANCELLED'}">
                                            <span class="status-badge cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge pending">${trackingOrder.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <c:if test="${not empty trackingOrder.shippingAddress}">
                                <div class="meta-row" style="flex-direction:column;align-items:flex-start;gap:4px;">
                                    <span class="meta-label">Địa chỉ giao</span>
                                    <span class="meta-value">${trackingOrder.shippingAddress}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty trackingOrder.customerPhone}">
                                <div class="meta-row">
                                    <span class="meta-label">Điện thoại</span>
                                    <span class="meta-value">${trackingOrder.customerPhone}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/my-orders?id=${trackingOrder.orderId}" class="btn btn-primary" style="justify-content:center;">
                    Xem chi tiết đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/profile?tab=orders" class="btn btn-back" style="justify-content:center;">
                    Quay lại danh sách
                </a>
            </div>
        </div>
    </section>

    <script>
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
    </script>
</body>
</html>
