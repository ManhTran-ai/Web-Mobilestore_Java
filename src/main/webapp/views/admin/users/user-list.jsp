<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Trang quản lý</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #1a1a1a; background-color: #f5f5f7; }
        .admin-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1a1a1a; color: #ffffff; padding: 2rem 0; position: fixed; height: 100vh; overflow-y: auto; }
        .sidebar-header { padding: 0 1.5rem 2rem; border-bottom: 1px solid #333; margin-bottom: 1rem; }
        .sidebar-header h2 { font-size: 1.25rem; font-weight: 600; }
        .sidebar-header span { font-size: 0.875rem; color: #888; }
        .sidebar-nav { list-style: none; }
        .sidebar-nav li { margin: 0.25rem 0; }
        .sidebar-nav a { display: flex; align-items: center; padding: 0.875rem 1.5rem; color: #ccc; text-decoration: none; transition: all 0.2s; font-size: 0.95rem; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background: #333; color: #fff; }
        .sidebar-nav a.active { border-left: 3px solid #0071e3; }
        .main-content { flex: 1; margin-left: 260px; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem; }
        .page-header h1 { font-size: 1.75rem; font-weight: 600; }
        .header-actions { display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; }
        .btn { display: inline-flex; align-items: center; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 0.95rem; font-weight: 500; text-decoration: none; cursor: pointer; transition: all 0.2s; border: none; font-family: inherit; }
        .btn-primary { background: #0071e3 !important; color: #fff !important; }
        .btn-primary:hover { background: #0077ed !important; }
        .btn-danger { background: #ff3b30 !important; color: #fff !important; }
        .btn-danger:hover { background: #ff453a !important; }
        .btn-secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn-secondary:hover { background: #d1d1d6 !important; }
        .btn-sm { padding: 0.5rem 1rem; font-size: 0.875rem; }
        .search-box { position: relative; }
        .search-box input { padding: 0.75rem 1rem 0.75rem 2.5rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 0.95rem; width: 280px; }
        .search-box input:focus { outline: none; border-color: #0071e3; }
        .search-box::before { content: '🔍'; position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%); }
        .filter-bar { display: flex; flex-wrap: wrap; gap: 1rem; align-items: center; margin-bottom: 1.5rem; padding: 1rem 1.25rem; background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
        .filter-group { display: flex; align-items: center; gap: 0.5rem; }
        .filter-group label { font-size: 0.875rem; color: #666; font-weight: 500; white-space: nowrap; }
        .filter-select { padding: 0.6rem 2rem 0.6rem 0.75rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 0.9rem; background: #fff; cursor: pointer; min-width: 140px; }
        .filter-select:focus { outline: none; border-color: #0071e3; }
        .btn-reset-filter { padding: 0.6rem 1rem; font-size: 0.875rem; background: transparent; color: #0071e3; border: 1px solid #0071e3; border-radius: 8px; cursor: pointer; }
        .btn-reset-filter:hover { background: #f0f7ff; }
        .alert { padding: 1rem 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-success { background: #d1f2eb; color: #0d6848; border: 1px solid #a3e4d7; }
        .alert-error { background: #fdecea; color: #c62828; border: 1px solid #f5c6cb; }
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: #fff; border-radius: 12px; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .stat-card .label { font-size: 0.85rem; color: #888; margin-bottom: 0.5rem; }
        .stat-card .value { font-size: 1.75rem; font-weight: 600; }
        .stat-card.primary .value { color: #0071e3; }
        .stat-card.success .value { color: #34c759; }
        .stat-card.warning .value { color: #ff9500; }
        .stat-card.danger .value { color: #ff3b30; }
        .table-container { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .table-header { padding: 1rem 1.5rem; border-bottom: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }
        .table-header h3 { font-size: 1rem; font-weight: 600; }
        .table-info { font-size: 0.9rem; color: #888; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid #e5e5ea; }
        .data-table th { background: #f5f5f7; font-weight: 600; color: #666; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .data-table tbody tr:hover { background: #fafafa; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .user-id { font-weight: 600; color: #0071e3; }
        .user-name { font-weight: 500; }
        .user-email { color: #666; font-size: 0.9rem; }
        .role-badge, .status-badge, .auth-badge { display: inline-block; padding: 0.35rem 0.7rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; }
        .role-badge.admin { background: #e8f4fd; color: #0071e3; }
        .role-badge.inventory-manager { background: #f3e8ff; color: #7c3aed; }
        .role-badge.customer { background: #f0f0f5; color: #555; }
        .status-badge.active { background: #d4edda; color: #155724; }
        .status-badge.inactive { background: #fff3cd; color: #856404; }
        .status-badge.deleted { background: #f8d7da; color: #721c24; }
        .auth-badge.local { background: #e5e5ea; color: #333; }
        .auth-badge.oauth { background: #fce8e6; color: #c5221f; }
        .actions { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .empty-state { text-align: center; padding: 4rem 2rem; color: #888; }
        .empty-state .icon { font-size: 4rem; margin-bottom: 1rem; }
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: none; align-items: center; justify-content: center; z-index: 1000; }
        .modal-overlay.active { display: flex; }
        .modal { background: #fff; border-radius: 16px; padding: 2rem; max-width: 420px; width: 90%; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .modal h3 { margin-bottom: 0.5rem; }
        .modal p { color: #666; margin-bottom: 1.5rem; }
        .modal-actions { display: flex; gap: 1rem; justify-content: center; }
        .row-hidden { display: none !important; }
        @media (max-width: 1200px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; }
            .stats-row { grid-template-columns: 1fr; }
            .search-box input { width: 100%; }
        }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="users" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Người dùng</h1>
            <div class="header-actions">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm username, email, SĐT...">
                </div>
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">+ Thêm người dùng</a>
            </div>
        </div>

        <c:if test="${param.success == 'created'}"><div class="alert alert-success">✓ Thêm người dùng thành công!</div></c:if>
        <c:if test="${param.success == 'updated'}"><div class="alert alert-success">✓ Cập nhật thành công!</div></c:if>
        <c:if test="${param.success == 'deleted'}"><div class="alert alert-success">✓ Đã xóa mềm người dùng (dữ liệu vẫn lưu trong DB).</div></c:if>
        <c:if test="${not empty param.error}"><div class="alert alert-error">✕ Có lỗi xảy ra. Vui lòng thử lại.</div></c:if>

        <div class="filter-bar">
            <div class="filter-group">
                <label for="filterRole">Vai trò:</label>
                <select id="filterRole" class="filter-select">
                    <option value="">Tất cả</option>
                    <option value="ADMIN">Admin</option>
                    <option value="INVENTORY_MANAGER">Quản lý kho</option>
                    <option value="CUSTOMER">Khách hàng</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="filterStatus">Trạng thái:</label>
                <select id="filterStatus" class="filter-select">
                    <option value="">Tất cả</option>
                    <option value="ACTIVE">Hoạt động</option>
                    <option value="INACTIVE">Ngưng hoạt động</option>
                    <option value="DELETED">Đã xóa</option>
                </select>
            </div>
            <button type="button" class="btn-reset-filter" id="resetFilters">Xóa bộ lọc</button>
        </div>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng người dùng</div>
                <div class="value" id="statTotal">0</div>
            </div>
            <div class="stat-card success">
                <div class="label">Đang hoạt động</div>
                <div class="value" id="statActive">0</div>
            </div>
            <div class="stat-card warning">
                <div class="label">Ngưng hoạt động</div>
                <div class="value" id="statInactive">0</div>
            </div>
            <div class="stat-card danger">
                <div class="label">Đã xóa (mềm)</div>
                <div class="value" id="statDeleted">0</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Danh sách người dùng</h3>
                <span class="table-info">Hiển thị <span id="displayCount">0</span> / <span id="totalCount">0</span></span>
            </div>
            <c:choose>
                <c:when test="${empty users}">
                    <div class="empty-state">
                        <div class="icon">👥</div>
                        <h3>Chưa có người dùng</h3>
                        <p>Thêm tài khoản mới hoặc chờ khách đăng ký.</p>
                        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary" style="margin-top:1rem;">+ Thêm người dùng</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="usersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tài khoản</th>
                            <th>Email / SĐT</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Loại đăng nhập</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="u" items="${users}">
                            <c:set var="accStatus" value="${not empty u.accountStatus ? u.accountStatus : 'ACTIVE'}"/>
                            <c:set var="searchText" value="${u.username} ${u.email} ${u.customerPhone}"/>
                            <tr class="user-row"
                                data-id="${u.id}"
                                data-role="${u.roleName}"
                                data-status="${accStatus}"
                                data-search="${searchText}">
                                <td class="user-id">#${u.id}</td>
                                <td>
                                    <div class="user-name">${u.username}</div>
                                </td>
                                <td>
                                    <div class="user-email">${not empty u.email ? u.email : '—'}</div>
                                    <c:if test="${not empty u.customerPhone}">
                                        <div class="user-email">${u.customerPhone}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="role-badge ${
                                        u.roleName == 'ADMIN' ? 'admin' :
                                        u.roleName == 'INVENTORY_MANAGER' ? 'inventory-manager' :
                                        'customer'
                                    }">${u.roleName}</span>
                                </td>
                                <td>
                                    <span class="status-badge ${accStatus == 'ACTIVE' ? 'active' : accStatus == 'INACTIVE' ? 'inactive' : 'deleted'}">
                                        <c:choose>
                                            <c:when test="${accStatus == 'ACTIVE'}">Hoạt động</c:when>
                                            <c:when test="${accStatus == 'INACTIVE'}">Ngưng HĐ</c:when>
                                            <c:otherwise>Đã xóa</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty u.oauthProvider}">
                                            <span class="auth-badge oauth">${u.oauthProvider}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="auth-badge local">Email / MK</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/users/view?id=${u.id}" class="btn btn-secondary btn-sm">👁 Xem</a>
                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                    <c:if test="${accStatus != 'DELETED'}">
                                        <button type="button" class="btn btn-danger btn-sm delete-btn"
                                                data-id="${u.id}" data-username="${u.username}">🗑 Xóa</button>
                                    </c:if>
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
        <div style="font-size:3rem;margin-bottom:1rem;">⚠️</div>
        <h3>Xác nhận xóa mềm</h3>
        <p>Bạn có chắc muốn xóa tài khoản <strong id="modalUsername"></strong>?</p>
        <p style="font-size:0.85rem;color:#666;">Tài khoản sẽ chuyển sang trạng thái <strong>Đã xóa</strong> nhưng dữ liệu vẫn giữ trong database.</p>
        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/users/delete">
            <input type="hidden" name="id" id="deleteUserId">
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" id="cancelDelete">Hủy</button>
                <button type="submit" class="btn btn-danger">Xóa mềm</button>
            </div>
        </form>
    </div>
</div>

<script>
(function () {
    const searchInput = document.getElementById('searchInput');
    const filterRole = document.getElementById('filterRole');
    const filterStatus = document.getElementById('filterStatus');
    const resetBtn = document.getElementById('resetFilters');
    const rows = document.querySelectorAll('.user-row');
    const displayCount = document.getElementById('displayCount');
    const totalCount = document.getElementById('totalCount');
    const statTotal = document.getElementById('statTotal');
    const statActive = document.getElementById('statActive');
    const statInactive = document.getElementById('statInactive');
    const statDeleted = document.getElementById('statDeleted');

    if (!rows.length) return;

    totalCount.textContent = rows.length;
    updateStats();

    function normalize(s) {
        return (s || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    }

    function applyFilters() {
        const q = normalize(searchInput.value.trim());
        const role = filterRole.value;
        const status = filterStatus.value;
        let visible = 0;

        rows.forEach(function (row) {
            const matchSearch = !q || normalize(row.dataset.search).includes(q);
            const matchRole = !role || row.dataset.role === role;
            const matchStatus = !status || row.dataset.status === status;
            const show = matchSearch && matchRole && matchStatus;
            row.classList.toggle('row-hidden', !show);
            if (show) visible++;
        });

        if (displayCount) displayCount.textContent = visible;
    }

    function updateStats() {
        let active = 0, inactive = 0, deleted = 0;
        rows.forEach(function (row) {
            const s = row.dataset.status;
            if (s === 'ACTIVE') active++;
            else if (s === 'INACTIVE') inactive++;
            else if (s === 'DELETED') deleted++;
        });
        if (statTotal) statTotal.textContent = rows.length;
        if (statActive) statActive.textContent = active;
        if (statInactive) statInactive.textContent = inactive;
        if (statDeleted) statDeleted.textContent = deleted;
    }

    searchInput.addEventListener('input', applyFilters);
    filterRole.addEventListener('change', applyFilters);
    filterStatus.addEventListener('change', applyFilters);
    resetBtn.addEventListener('click', function () {
        searchInput.value = '';
        filterRole.value = '';
        filterStatus.value = '';
        applyFilters();
    });

    applyFilters();

    const modal = document.getElementById('deleteModal');
    const deleteForm = document.getElementById('deleteForm');
    const deleteUserId = document.getElementById('deleteUserId');
    const modalUsername = document.getElementById('modalUsername');

    document.querySelectorAll('.delete-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            deleteUserId.value = btn.dataset.id;
            modalUsername.textContent = btn.dataset.username;
            modal.classList.add('active');
        });
    });

    document.getElementById('cancelDelete').addEventListener('click', function () {
        modal.classList.remove('active');
    });

    modal.addEventListener('click', function (e) {
        if (e.target === modal) modal.classList.remove('active');
    });
})();
</script>
</body>
</html>
