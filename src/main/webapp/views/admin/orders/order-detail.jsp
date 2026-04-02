<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderId} - Trang quản lý</title>
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

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .breadcrumb a {
            color: #0071e3;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb span {
            color: #888;
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

        .order-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 1.5rem;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #e5e5ea;
        }

        .order-id {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0071e3;
        }

        .order-date {
            color: #666;
            font-size: 0.95rem;
            margin-top: 0.25rem;
        }

        .order-status-select {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .order-status-select select {
            padding: 0.75rem 1rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 0.95rem;
            background: #ffffff;
            cursor: pointer;
            min-width: 160px;
        }

        .order-status-select select:focus {
            outline: none;
            border-color: #0071e3;
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
            background: #0071e3;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #0077ed;
        }

        .btn-secondary {
            background: #e5e5ea;
            color: #1a1a1a;
        }

        .btn-secondary:hover {
            background: #d1d1d6;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .info-item {
            margin-bottom: 1rem;
        }

        .info-label {
            font-size: 0.85rem;
            color: #888;
            margin-bottom: 0.25rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-size: 1rem;
            color: #1a1a1a;
            font-weight: 500;
        }

        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
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

        .status-badge.completed {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.cancelled {
            background: #f8d7da;
            color: #721c24;
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

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .product-image {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border-radius: 8px;
            background: #f5f5f7;
        }

        .product-name {
            font-weight: 500;
            color: #1a1a1a;
        }

        .product-manufacturer {
            font-size: 0.85rem;
            color: #888;
        }

        .price {
            font-weight: 600;
        }

        .right {
            text-align: right;
        }

        .total-row {
            background: #f5f5f7;
        }

        .total-row td {
            font-weight: 600;
            font-size: 1.1rem;
            padding: 1.25rem;
        }

        .total-amount {
            color: #0071e3;
            font-size: 1.25rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e5e5ea;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }

        .alert-success {
            background: #d1f2eb;
            color: #0d6848;
            border: 1px solid #a3e4d7;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .order-header {
                flex-direction: column;
                gap: 1rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
                justify-content: center;
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
                    <a href="${pageContext.request.contextPath}/admin/products">
                        Sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="active">
                        Đơn hàng
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a>
            <span>/</span>
            <span>Chi tiết đơn hàng #${order.orderId}</span>
        </div>

        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                <span>✓</span> Cập nhật trạng thái thành công!
            </div>
        </c:if>

        <div class="page-header">
            <div>
                <h1>Chi tiết đơn hàng #${order.orderId}</h1>
            </div>
        </div>

        <div class="order-card">
            <div class="order-header">
                <div>
                    <div class="order-id">Đơn hàng #${order.orderId}</div>
                    <div class="order-date">Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                </div>
                <span class="status-badge ${order.orderStatus == 'PENDING' ? 'pending' : order.orderStatus == 'PROCESSING' ? 'processing' : order.orderStatus == 'SHIPPED' ? 'shipped' : order.orderStatus == 'COMPLETED' ? 'completed' : 'cancelled'}">
                    ${order.orderStatus}
                </span>
            </div>

            <div class="info-grid">
                <div>
                    <div class="info-item">
                        <div class="info-label">Khách hàng</div>
                        <div class="info-value">${order.user != null ? order.user.username : 'Khách'}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value">${order.user != null && order.user.email != null ? order.user.email : 'Chưa cập nhật'}</div>
                    </div>
                </div>
                <div>
                    <div class="info-item">
                        <div class="info-label">Ngày đặt hàng</div>
                        <div class="info-value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Trạng thái thanh toán</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'PAID'}">
                                    <span style="color: #28a745;">Đã thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #ffc107;">Chờ thanh toán</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/orders/update" class="order-status-select">
                <input type="hidden" name="id" value="${order.orderId}" />
                <label for="status" style="font-weight: 500;">Cập nhật trạng thái:</label>
                <select name="status" id="status">
                    <option value="PENDING" ${order.orderStatus=='PENDING' ? 'selected' : ''}>PENDING - Chờ xử lý</option>
                    <option value="PROCESSING" ${order.orderStatus=='PROCESSING' ? 'selected' : ''}>PROCESSING - Đang xử lý</option>
                    <option value="SHIPPED" ${order.orderStatus=='SHIPPED' ? 'selected' : ''}>SHIPPED - Đang giao hàng</option>
                    <option value="COMPLETED" ${order.orderStatus=='COMPLETED' ? 'selected' : ''}>COMPLETED - Hoàn thành</option>
                    <option value="CANCELLED" ${order.orderStatus=='CANCELLED' ? 'selected' : ''}>CANCELLED - Đã hủy</option>
                </select>
                <button type="submit" class="btn btn-primary">Cập nhật</button>
            </form>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Chi tiết sản phẩm</h3>
            </div>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th class="right">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="d" items="${order.details}">
                    <tr>
                        <td>
                            <div class="product-info">
                                <c:choose>
                                    <c:when test="${not empty d.variant.variantImage}">
                                        <img src="${pageContext.request.contextPath}/${d.variant.variantImage}" alt="${d.product.productName}" class="product-image">
                                    </c:when>
                                    <c:when test="${not empty d.product.displayImage}">
                                        <img src="${pageContext.request.contextPath}/${d.product.displayImage}" alt="${d.product.productName}" class="product-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-image" style="display:flex;align-items:center;justify-content:center;font-size:1.5rem;">&#128241;</div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="product-name">${d.product.productName}</div>
                                    <div class="product-manufacturer">${d.product.manufacturer}</div>
                                    <c:if test="${not empty d.variant.color || not empty d.variant.storage}">
                                        <div style="font-size:0.8rem; color:#888;">${d.variant.color}${not empty d.variant.color && not empty d.variant.storage ? ' / ' : ''}${d.variant.storage}</div>
                                    </c:if>
                                </div>
                            </div>
                        </td>
                        <td class="price"><fmt:formatNumber value="${d.price}" type="number" groupingUsed="true"/>₫</td>
                        <td>${d.quantity}</td>
                        <td class="right price"><fmt:formatNumber value="${d.price * d.quantity}" type="number" groupingUsed="true"/>₫</td>
                    </tr>
                </c:forEach>
                <tr class="total-row">
                    <td colspan="3" class="right">Tổng cộng:</td>
                    <td class="right total-amount"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>₫</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">
                ← Quay lại danh sách
            </a>
        </div>
    </main>
</div>
</body>
</html>

