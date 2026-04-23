<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận đơn hàng - Mobile Store</title>
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
            max-width: 800px;
            margin: 0 auto;
            padding: 48px 24px 80px;
        }

        .success-banner {
            text-align: center;
            margin-bottom: 40px;
        }

        .success-icon {
            width: 72px;
            height: 72px;
            background: #d4edda;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .success-icon svg {
            width: 36px;
            height: 36px;
            color: #155724;
        }

        .success-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
            letter-spacing: -0.3px;
        }

        .success-subtitle {
            font-size: 1rem;
            color: #6e6e73;
            max-width: 480px;
            margin: 0 auto;
        }

        .order-card {
            background: #ffffff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .order-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e5e5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-card-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .order-card-body {
            padding: 20px 24px;
        }

        .order-id-display {
            text-align: center;
            padding: 24px;
        }

        .order-id-label {
            font-size: 0.85rem;
            color: #86868b;
            margin-bottom: 4px;
        }

        .order-id-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.5px;
        }

        .order-meta {
            display: grid;
            gap: 14px;
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

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .product-list {
            list-style: none;
            display: grid;
            gap: 1px;
            background: #e5e5e5;
        }

        .product-item {
            background: #ffffff;
            padding: 16px 24px;
            display: grid;
            grid-template-columns: 56px 1fr auto;
            gap: 14px;
            align-items: center;
        }

        .product-thumb {
            width: 56px;
            height: 56px;
            border-radius: 8px;
            background: #f4f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-thumb img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .product-thumb .placeholder {
            font-size: 1.5rem;
            opacity: 0.3;
        }

        .product-info {
            min-width: 0;
        }

        .product-name {
            font-size: 0.95rem;
            font-weight: 500;
            color: #1a1a1a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .product-variant {
            font-size: 0.9rem;
            color: #86868b;
            margin-top: 2px;
        }

        .product-qty {
            font-size: 0.9rem;
            color: #6e6e73;
            margin-top: 2px;
        }

        .product-price {
            text-align: right;
            flex-shrink: 0;
        }

        .price-main {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .price-unit {
            font-size: 0.85rem;
            color: #86868b;
            display: block;
            margin-top: 2px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
        }

        .summary-row:not(:last-child) {
            border-bottom: 1px solid #e5e5e5;
        }

        .summary-row.total {
            border-top: 2px solid #e5e5e5;
            margin-top: 4px;
            padding-top: 16px;
        }

        .summary-label {
            font-size: 0.9rem;
            color: #6e6e73;
        }

        .summary-value {
            font-size: 0.9rem;
            font-weight: 500;
            color: #1a1a1a;
        }

        .summary-row.total .summary-label {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .summary-row.total .summary-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #c0392b;
        }

        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .btn {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px 20px;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #1a1a1a;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #333333;
        }

        .btn-secondary {
            background: #ffffff;
            color: #1a1a1a;
            border: 1px solid #e5e5e5;
        }

        .btn-secondary:hover {
            background: #f4f5f7;
        }

        .address-block {
            font-size: 0.95rem;
            color: #6e6e73;
            line-height: 1.6;
        }

        .payment-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 10px;
            background: #fff8e1;
            color: #f57f17;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .payment-badge.vnpay {
            background: #e3f2fd;
            color: #1565c0;
        }

        @media (max-width: 640px) {
            .page {
                padding: 32px 16px 64px;
            }

            .btn-row {
                flex-direction: column;
            }

            .product-item {
                grid-template-columns: 48px 1fr auto;
                padding: 12px 16px;
                gap: 10px;
            }

            .product-thumb {
                width: 48px;
                height: 48px;
            }
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
                            <a href="${pageContext.request.contextPath}/profile" class="user-avatar" title="${sessionScope.user.username}">U</a>
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
        <div class="success-banner">
            <div class="success-icon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                </svg>
            </div>
            <h1 class="success-title">Đặt hàng thành công!</h1>
            <p class="success-subtitle">Cảm ơn bạn đã đặt hàng tại Mobile Store. Đơn hàng của bạn đang được xử lý và sẽ được giao trong thời gian sớm nhất.</p>
        </div>

        <div class="order-card">
            <div class="order-id-display">
                <div class="order-id-label">Mã đơn hàng</div>
                <div class="order-id-value">#${confirmedOrder.orderId}</div>
            </div>
        </div>

        <div class="order-card">
            <div class="order-card-header">
                <span class="order-card-title">Thông tin đơn hàng</span>
                <c:choose>
                    <c:when test="${confirmedOrder.orderStatus == 'PENDING'}">
                        <span class="status-badge pending">Chờ xác nhận</span>
                    </c:when>
                    <c:when test="${confirmedOrder.orderStatus == 'PROCESSING'}">
                        <span class="status-badge pending" style="background:#cce5ff;color:#004085;">Đang xử lý</span>
                    </c:when>
                    <c:when test="${confirmedOrder.orderStatus == 'SHIPPED'}">
                        <span class="status-badge pending" style="background:#d1ecf1;color:#0c5460;">Đang giao hàng</span>
                    </c:when>
                    <c:when test="${confirmedOrder.orderStatus == 'DELIVERED'}">
                        <span class="status-badge pending" style="background:#d4edda;color:#155724;">Đã giao hàng</span>
                    </c:when>
                    <c:when test="${confirmedOrder.orderStatus == 'CANCELLED'}">
                        <span class="status-badge pending" style="background:#f8d7da;color:#721c24;">Đã hủy</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge pending">${confirmedOrder.orderStatus}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="order-card-body">
                <div class="order-meta">
                    <div class="meta-row">
                        <span class="meta-label">Ngày đặt</span>
                        <span class="meta-value bold">
                            <%= com.mobilestore.util.DateFormatUtil.formatDateTime(request.getAttribute("confirmedOrder")) %>
                        </span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">Thanh toán</span>
                        <span class="meta-value">
                            <c:choose>
                                <c:when test="${confirmedOrder.paymentMethod == 'VNPAY'}">
                                    <span class="payment-badge vnpay">VNPay</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="payment-badge">Tiền mặt</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <c:if test="${not empty confirmedOrder.shippingAddress}">
                        <div class="meta-row" style="flex-direction:column;align-items:flex-start;gap:4px;">
                            <span class="meta-label">Địa chỉ giao hàng</span>
                            <span class="meta-value">${confirmedOrder.shippingAddress}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty confirmedOrder.customerPhone}">
                        <div class="meta-row">
                            <span class="meta-label">Số điện thoại</span>
                            <span class="meta-value">${confirmedOrder.customerPhone}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty confirmedOrder.note}">
                        <div class="meta-row" style="flex-direction:column;align-items:flex-start;gap:4px;">
                            <span class="meta-label">Ghi chú</span>
                            <span class="meta-value">${confirmedOrder.note}</span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="order-card">
            <div class="order-card-header">
                <span class="order-card-title">Sản phẩm đã đặt</span>
                <c:if test="${not empty confirmedOrder.details}">
                    <span style="font-size:0.8rem;color:#86868b;">${confirmedOrder.details.size()} sản phẩm</span>
                </c:if>
            </div>
            <ul class="product-list">
                <c:choose>
                    <c:when test="${empty confirmedOrder.details}">
                        <li class="product-item" style="justify-content:center;color:#86868b;font-size:0.9rem;grid-template-columns:1fr;">
                            Không có thông tin sản phẩm
                        </li>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${confirmedOrder.details}">
                            <li class="product-item">
                                <div class="product-thumb">
                                    <div class="placeholder">M</div>
                                </div>
                                <div class="product-info">
                                    <div class="product-name">${item.product != null ? item.product.productName : 'Sản phẩm'}</div>
                                    <c:if test="${item.variant != null}">
                                        <div class="product-variant">${item.variant.color} / ${item.variant.storage}</div>
                                    </c:if>
                                    <div class="product-qty">Số lượng: ${item.quantity}</div>
                                </div>
                                <div class="product-price">
                                    <span class="price-main">
                                        <fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true"/> đ
                                    </span>
                                    <span class="price-unit">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ x ${item.quantity}
                                    </span>
                                </div>
                            </li>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <div class="order-card">
            <div class="order-card-header">
                <span class="order-card-title">Tổng cộng</span>
            </div>
            <div class="order-card-body">
                <div class="summary-row">
                    <span class="summary-label">Tạm tính</span>
                    <span class="summary-value">
                        <fmt:formatNumber value="${(confirmedOrder.totalAmount != null ? confirmedOrder.totalAmount : 0) - (confirmedOrder.shippingCost != null ? confirmedOrder.shippingCost : 0)}" type="number" groupingUsed="true"/> đ
                    </span>
                </div>
                <div class="summary-row">
                    <span class="summary-label">Phí vận chuyển</span>
                    <span class="summary-value">
                        <c:choose>
                            <c:when test="${confirmedOrder.shippingCost != null && confirmedOrder.shippingCost > 0}">
                                <fmt:formatNumber value="${confirmedOrder.shippingCost}" type="number" groupingUsed="true"/> đ
                            </c:when>
                            <c:otherwise>Miễn phí</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="summary-row total">
                    <span class="summary-label">Thành tiền</span>
                    <span class="summary-value">
                        <fmt:formatNumber value="${confirmedOrder.totalAmount != null ? confirmedOrder.totalAmount : 0}" type="number" groupingUsed="true"/> đ
                    </span>
                </div>
            </div>
        </div>

        <div class="btn-row">
            <a href="${pageContext.request.contextPath}/profile?tab=orders" class="btn btn-primary">
                Xem đơn hàng của tôi
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                Quay trở lại trang chủ
            </a>
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
