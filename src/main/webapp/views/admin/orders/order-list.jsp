<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Trang quản lý</title>
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

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 0.95rem;
            width: 300px;
            transition: border-color 0.2s;
        }

        .search-box input:focus {
            outline: none;
            border-color: #0071e3;
        }

        .search-box::before {
            content: '🔍';
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1rem;
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

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
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

        .stat-card.danger .value {
            color: #ff3b30;
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

        .order-id {
            font-weight: 600;
            color: #0071e3;
        }

        .order-customer {
            font-weight: 500;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
        }

        .order-total {
            font-weight: 600;
            color: #1a1a1a;
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

        .modal-product-name {
            font-weight: 600;
            color: #1a1a1a;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .modal-actions .btn {
            min-width: 120px;
        }

        @media (max-width: 1200px) {
            .stats-row {
                grid-template-columns: repeat(2, 1fr);
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

            .search-box input {
                width: 100%;
            }

            .data-table {
                font-size: 0.875rem;
            }

            .data-table th,
            .data-table td {
                padding: 0.75rem;
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
            <div class="page-header">
                <h1>Quản lý Đơn hàng</h1>
                <div class="header-actions">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Tìm kiếm đơn hàng...">
                    </div>
                </div>
            </div>

            <c:if test="${param.success == 'updated'}">
                <div class="alert alert-success" id="alertSuccess">
                    <span>✓</span> Cập nhật trạng thái thành công!
                </div>
            </c:if>
            <c:if test="${param.success == 'deleted'}">
                <div class="alert alert-success" id="alertSuccess">
                    <span>✓</span> Xóa đơn hàng thành công!
                </div>
            </c:if>
            <c:if test="${param.error == 'delete_failed'}">
                <div class="alert alert-error">
                    <span>✕</span> Không thể xóa đơn hàng.
                </div>
            </c:if>

            <div class="stats-row">
                <div class="stat-card primary">
                    <div class="label">Tổng đơn hàng</div>
                    <div class="value" id="totalOrders">${orders.size()}</div>
                </div>
                <div class="stat-card warning">
                    <div class="label">Chờ xử lý</div>
                    <div class="value" id="pendingCount">0</div>
                </div>
                <div class="stat-card success">
                    <div class="label">Hoàn thành</div>
                    <div class="value" id="completedCount">0</div>
                </div>
                <div class="stat-card danger">
                    <div class="label">Đã hủy</div>
                    <div class="value" id="cancelledCount">0</div>
                </div>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <h3>Danh sách đơn hàng</h3>
                    <span class="table-info">Hiển thị <span id="displayCount">${orders.size()}</span> đơn hàng</span>
                </div>
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <div class="icon">📦</div>
                            <h3>Chưa có đơn hàng nào</h3>
                            <p>Đơn hàng sẽ xuất hiện khi khách hàng mua sản phẩm</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table" id="ordersTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr data-order-id="${o.orderId}" data-status="${o.orderStatus}">
                                        <td class="order-id">#${o.orderId}</td>
                                        <td class="order-customer">${o.user != null ? o.user.username : 'Khách'}</td>
                                        <td class="order-date"><fmt:formatDate value="${o.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td class="order-total"><fmt:formatNumber value="${o.totalAmount != null ? o.totalAmount : 0}" type="number" groupingUsed="true"/>₫</td>
                                        <td>
                                            <span class="status-badge ${o.orderStatus == 'PENDING' ? 'pending' : o.orderStatus == 'PROCESSING' ? 'processing' : o.orderStatus == 'SHIPPED' ? 'shipped' : o.orderStatus == 'COMPLETED' ? 'completed' : 'cancelled'}">
                                                ${o.orderStatus}
                                            </span>
                                        </td>
                                        <td class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/orders/view?id=${o.orderId}"
                                               class="btn btn-secondary btn-sm"
                                               title="Xem chi tiết">
                                                👁️ Xem
                                            </a>
                                            <button type="button"
                                                    class="btn btn-danger btn-sm delete-btn"
                                                    data-id="${o.orderId}"
                                                    data-customer="${o.user != null ? o.user.username : 'Khách'}"
                                                    title="Xóa đơn hàng">
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
            <h3>Xác nhận xóa đơn hàng</h3>
            <p>Bạn có chắc chắn muốn xóa đơn hàng #<span id="modalOrderId"></span>?</p>
            <p style="font-size: 0.85rem; color: #ff3b30;">Hành động này không thể hoàn tác!</p>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
                <form id="deleteForm" method="POST" style="display: inline;">
                    <button type="submit" class="btn btn-danger">Xóa đơn hàng</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const searchInput = document.getElementById('searchInput');
        const ordersTable = document.getElementById('ordersTable');
        const deleteModal = document.getElementById('deleteModal');
        const deleteForm = document.getElementById('deleteForm');
        const modalOrderId = document.getElementById('modalOrderId');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

        function calculateStats() {
            const rows = document.querySelectorAll('#ordersTable tbody tr');
            let pending = 0, completed = 0, cancelled = 0;

            rows.forEach(row => {
                const status = row.dataset.status;
                if (status === 'PENDING') {
                    pending++;
                } else if (status === 'COMPLETED') {
                    completed++;
                } else if (status === 'CANCELLED') {
                    cancelled++;
                }
            });

            document.getElementById('pendingCount').textContent = pending;
            document.getElementById('completedCount').textContent = completed;
            document.getElementById('cancelledCount').textContent = cancelled;
        }

        if (searchInput && ordersTable) {
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase().trim();
                const rows = ordersTable.querySelectorAll('tbody tr');
                let visibleCount = 0;

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();

                    if (text.includes(searchTerm)) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                document.getElementById('displayCount').textContent = visibleCount;
            });
        }

        document.querySelectorAll('.delete-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const orderId = this.dataset.id;
                const customer = this.dataset.customer;

                modalOrderId.textContent = orderId;
                deleteForm.action = '${pageContext.request.contextPath}/admin/orders/delete?id=' + orderId;
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
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.style.display = 'none', 500);
            });
        }, 5000);

        calculateStats();
    </script>
</body>
</html>

