<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .status-badge.pending { background: #fff3cd; color: #856404; }
        .status-badge.processing { background: #cce5ff; color: #004085; }
        .status-badge.shipped { background: #d1ecf1; color: #0c5460; }
        .status-badge.completed { background: #d4edda; color: #155724; }
        .status-badge.cancelled { background: #f8d7da; color: #721c24; }

        .order-id { font-weight: 600; color: #0071e3; }
        .order-customer { font-weight: 500; }
        .order-date { color: #666; font-size: 0.9rem; }
        .order-total { font-weight: 600; color: #1a1a1a; }
        .actions { display: flex; gap: 0.5rem; }
        .table-footer { padding: 1rem 1.5rem; border-top: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }

        @media (max-width: 1200px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="orders" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

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
