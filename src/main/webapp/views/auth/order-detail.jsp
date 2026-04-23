<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${userOrder.orderId}</title>
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

        .order-grid {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .order-grid {
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .card-body {
            padding: 20px 24px;
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
        }

        .meta-value.bold {
            font-weight: 600;
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

        .address-block {
            font-size: 0.95rem;
            color: #6e6e73;
            line-height: 1.6;
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
        }

        .btn-back:hover {
            background: #f4f5f7;
        }

        .payment-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 10px;
            background: #e8f5e9;
            color: #2e7d32;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .payment-badge.vnpay {
            background: #e3f2fd;
            color: #1565c0;
        }

        .payment-badge.cod {
            background: #fff8e1;
            color: #f57f17;
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
            Đơn hàng #${userOrder.orderId}
        </h1>

        <div class="order-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Sản phẩm đã đặt</span>
                    <c:if test="${not empty userOrder.details}">
                        <span style="font-size:0.8rem;color:#86868b;">${userOrder.details.size()} sản phẩm</span>
                    </c:if>
                </div>
                <ul class="product-list">
                    <c:choose>
                        <c:when test="${empty userOrder.details}">
                            <li class="product-item" style="justify-content:center;color:#86868b;font-size:0.9rem;grid-template-columns:1fr;">
                                Không có thông tin sản phẩm
                            </li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${userOrder.details}">
                                <li class="product-item">
                                    <div class="product-thumb">
                                        <div class="placeholder">📱</div>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name">${item.product != null ? item.product.productName : 'Sản phẩm'}</div>
                                        <c:if test="${item.variant != null}">
                                            <div class="product-variant">${item.variant.color} · ${item.variant.storage}</div>
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

            <div style="display:grid;gap:20px;">
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">Thông tin đơn hàng</span>
                    </div>
                    <div class="card-body">
                        <div class="order-meta">
                            <div class="meta-row">
                                <span class="meta-label">Mã đơn</span>
                                <span class="meta-value bold">#${userOrder.orderId}</span>
                            </div>
                            <div class="meta-row">
                                <span class="meta-label">Ngày đặt</span>
                                <span class="meta-value">
                                            <fmt:formatDate value="${userOrder.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="meta-row">
                                <span class="meta-label">Trạng thái</span>
                                <span class="meta-value">
                                    <c:choose>
                                        <c:when test="${userOrder.orderStatus == 'PENDING'}">
                                            <span class="status-badge pending">Chờ xác nhận</span>
                                        </c:when>
                                        <c:when test="${userOrder.orderStatus == 'PROCESSING'}">
                                            <span class="status-badge processing">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${userOrder.orderStatus == 'SHIPPED'}">
                                            <span class="status-badge shipped">Đang giao hàng</span>
                                        </c:when>
                                        <c:when test="${userOrder.orderStatus == 'DELIVERED'}">
                                            <span class="status-badge delivered">Đã giao hàng</span>
                                        </c:when>
                                        <c:when test="${userOrder.orderStatus == 'CANCELLED'}">
                                            <span class="status-badge cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge pending">${userOrder.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="meta-row">
                                <span class="meta-label">Thanh toán</span>
                                <span class="meta-value">
                                    <c:choose>
                                        <c:when test="${userOrder.paymentMethod == 'VNPAY'}">
                                            <span class="payment-badge vnpay">VNPay</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="payment-badge cod">Tiền mặt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <span class="card-title">Địa chỉ giao hàng</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty userOrder.shippingAddress}">
                                <p class="address-block">${userOrder.shippingAddress}</p>
                            </c:when>
                            <c:otherwise>
                                <p style="color:#86868b;font-size:0.9rem;">Chưa có thông tin địa chỉ</p>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty userOrder.customerPhone}">
                            <p style="margin-top:10px;font-size:0.85rem;color:#6e6e73;">
                                <strong>Điện thoại:</strong> ${userOrder.customerPhone}
                            </p>
                        </c:if>
                        <c:if test="${not empty userOrder.note}">
                            <p style="margin-top:6px;font-size:0.85rem;color:#6e6e73;">
                                <strong>Ghi chú:</strong> ${userOrder.note}
                            </p>
                        </c:if>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <span class="card-title">Tổng cộng</span>
                    </div>
                    <div class="card-body">
                        <div class="summary-row">
                            <span class="summary-label">Tạm tính</span>
                            <span class="summary-value">
                                <fmt:formatNumber value="${userOrder.totalAmount - (userOrder.shippingCost != null ? userOrder.shippingCost : 0)}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Phí vận chuyển</span>
                            <span class="summary-value">
                                <fmt:formatNumber value="${userOrder.shippingCost != null ? userOrder.shippingCost : 0}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">Thành tiền</span>
                            <span class="summary-value">
                                <fmt:formatNumber value="${userOrder.totalAmount != null ? userOrder.totalAmount : 0}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty userOrder.trackingNumber}">
                    <a href="${pageContext.request.contextPath}/order-tracking?id=${userOrder.orderId}" class="btn btn-back" style="width:100%;justify-content:center;gap:8px;">
                        <span style="font-size:1.1rem;">🚚</span> Theo dõi đơn hàng
                    </a>
                </c:if>

                <a href="${pageContext.request.contextPath}/profile?tab=orders" class="btn btn-back">
                    ← Quay lại danh sách
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
