<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Trang quản lý</title>
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
            margin-bottom: 1.5rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .page-header p {
            color: #666;
            font-size: 0.95rem;
        }

        .quick-metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .metric-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 1.25rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #ececf0;
        }

        .metric-label {
            color: #666;
            font-size: 0.85rem;
            margin-bottom: 0.35rem;
        }

        .metric-value {
            font-size: 1.9rem;
            font-weight: 600;
            line-height: 1.2;
        }

        .metric-subtext {
            margin-top: 0.25rem;
            font-size: 0.85rem;
            color: #8a8a8a;
        }

        .metric-users .metric-value { color: #0071e3; }
        .metric-orders .metric-value { color: #ff9500; }
        .metric-revenue .metric-value { color: #34c759; }

        .revenue-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(170px, 1fr));
            gap: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .revenue-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #ececf0;
        }

        .revenue-card .title {
            font-size: 0.82rem;
            color: #777;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .revenue-card .amount {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1a1a1a;
            line-height: 1.3;
        }

        .analytics-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .panel {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid #ececf0;
            overflow: hidden;
        }

        .panel-header {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid #ececf0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .panel-header h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .panel-header span {
            font-size: 0.85rem;
            color: #8a8a8a;
        }

        .chart-wrapper {
            padding: 1.25rem;
            min-height: 260px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        .chart-bars {
            height: 190px;
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 0.75rem;
            align-items: end;
        }

        .bar-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            height: 100%;
        }

        .bar-fill {
            width: 100%;
            max-width: 44px;
            background: linear-gradient(180deg, #0077ed 0%, #0059b3 100%);
            border-radius: 8px 8px 0 0;
            min-height: 8px;
            transition: all 0.25s;
        }

        .bar-fill:hover {
            filter: brightness(1.08);
        }

        .bar-label {
            margin-top: 0.4rem;
            font-size: 0.72rem;
            color: #707070;
        }

        .order-status-list {
            list-style: none;
            padding: 1rem 1.25rem 1.15rem;
            display: grid;
            gap: 0.6rem;
        }

        .order-status-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.55rem 0.6rem;
            border-radius: 8px;
            background: #f7f7fa;
            border: 1px solid #ececf0;
            font-size: 0.92rem;
        }

        .status-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }

        .dot.pending { background: #ff9500; }
        .dot.processing { background: #5856d6; }
        .dot.shipped { background: #30b0c7; }
        .dot.completed { background: #34c759; }
        .dot.cancelled { background: #ff3b30; }

        .status-value {
            font-weight: 600;
        }

        .dashboard-note {
            background: #eef5ff;
            border: 1px solid #d8e7ff;
            color: #275d9f;
            border-radius: 10px;
            padding: 0.85rem 1rem;
            font-size: 0.9rem;
        }

        @media (max-width: 1280px) {
            .revenue-grid {
                grid-template-columns: repeat(3, 1fr);
            }

            .analytics-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 900px) {
            .quick-metrics {
                grid-template-columns: 1fr;
            }

            .revenue-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
                padding: 1.25rem;
            }

            .revenue-grid {
                grid-template-columns: 1fr;
            }

            .chart-bars {
                gap: 0.45rem;
            }

            .bar-fill {
                max-width: 38px;
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
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
                    <a href="${pageContext.request.contextPath}/admin/sliders">
                        Slider Images
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Dashboard quản trị</h1>
                <p>Tổng quan nhanh dữ liệu kinh doanh theo thời gian thực (giao diện giai đoạn 1)</p>
            </div>
        </div>

        <section class="quick-metrics">
            <article class="metric-card metric-users">
                <div class="metric-label">Người dùng mới</div>
                <div class="metric-value">${newUsersEstimated}</div>
                <div class="metric-subtext">Ước tính trong tháng hiện tại</div>
            </article>
            <article class="metric-card metric-orders">
                <div class="metric-label">Đơn hàng mới</div>
                <div class="metric-value">${newOrdersToday}</div>
                <div class="metric-subtext">Đơn phát sinh hôm nay</div>
            </article>
            <article class="metric-card metric-revenue">
                <div class="metric-label">Doanh thu hôm nay</div>
                <div class="metric-value">
                    <fmt:formatNumber value="${revenueToday}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                </div>
                <div class="metric-subtext">Trên tổng ${totalOrders} đơn hàng</div>
            </article>
        </section>

        <section class="revenue-grid">
            <article class="revenue-card">
                <div class="title">Ngày</div>
                <div class="amount"><fmt:formatNumber value="${revenueToday}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
            </article>
            <article class="revenue-card">
                <div class="title">Tuần</div>
                <div class="amount"><fmt:formatNumber value="${revenueWeek}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
            </article>
            <article class="revenue-card">
                <div class="title">Tháng</div>
                <div class="amount"><fmt:formatNumber value="${revenueMonth}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
            </article>
            <article class="revenue-card">
                <div class="title">Quý</div>
                <div class="amount"><fmt:formatNumber value="${revenueQuarter}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
            </article>
            <article class="revenue-card">
                <div class="title">Năm</div>
                <div class="amount"><fmt:formatNumber value="${revenueYear}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
            </article>
        </section>

        <section class="analytics-grid">
            <section class="panel">
                <div class="panel-header">
                    <h3>Biểu đồ doanh thu 6 tháng gần nhất</h3>
                    <span>Đơn vị: VND</span>
                </div>
                <div class="chart-wrapper">
                    <c:set var="maxValue" value="1" />
                    <c:forEach var="v" items="${chartValues}">
                        <c:if test="${v > maxValue}">
                            <c:set var="maxValue" value="${v}" />
                        </c:if>
                    </c:forEach>

                    <div class="chart-bars">
                        <c:forEach var="value" items="${chartValues}" varStatus="loop">
                            <div class="bar-item" title="${chartLabels[loop.index]} - ${value}">
                                <div class="bar-fill" style="height: ${((value / maxValue) * 100) < 8 ? 8 : ((value / maxValue) * 100)}%;"></div>
                                <div class="bar-label">${chartLabels[loop.index]}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </section>

            <section class="panel">
                <div class="panel-header">
                    <h3>Tình trạng đơn hàng</h3>
                    <span>Cập nhật gần nhất</span>
                </div>
                <ul class="order-status-list">
                    <li class="order-status-item">
                        <span class="status-tag"><span class="dot pending"></span> PENDING</span>
                        <span class="status-value">${pendingCount}</span>
                    </li>
                    <li class="order-status-item">
                        <span class="status-tag"><span class="dot processing"></span> PROCESSING</span>
                        <span class="status-value">${processingCount}</span>
                    </li>
                    <li class="order-status-item">
                        <span class="status-tag"><span class="dot shipped"></span> SHIPPED</span>
                        <span class="status-value">${shippedCount}</span>
                    </li>
                    <li class="order-status-item">
                        <span class="status-tag"><span class="dot completed"></span> COMPLETED</span>
                        <span class="status-value">${completedCount}</span>
                    </li>
                    <li class="order-status-item">
                        <span class="status-tag"><span class="dot cancelled"></span> CANCELLED</span>
                        <span class="status-value">${cancelledCount}</span>
                    </li>
                </ul>
            </section>
        </section>

        <div class="dashboard-note">
            Ghi chú: phần này đang ưu tiên giao diện. Với dữ liệu người dùng mới, hệ thống đang dùng số ước tính vì bảng users hiện chưa có trường thời gian tạo tài khoản.
        </div>
    </main>
</div>
</body>
</html>
