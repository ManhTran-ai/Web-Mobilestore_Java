<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng #${user.id} - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .breadcrumb { display: flex; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb span { color: #888; }
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .detail-card { background: #fff; border-radius: 12px; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .detail-card h3 { font-size: 1rem; margin-bottom: 1rem; padding-bottom: 0.75rem; border-bottom: 1px solid #e5e5ea; }
        .detail-row { display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid #f0f0f0; gap: 1rem; }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: #888; font-size: 0.9rem; min-width: 140px; }
        .detail-value { font-weight: 500; text-align: right; word-break: break-word; }
        .role-badge, .status-badge { display: inline-block; padding: 0.35rem 0.7rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .role-badge.admin { background: #e8f4fd; color: #0071e3; }
        .role-badge.customer { background: #f0f0f5; color: #555; }
        .status-badge.active { background: #d4edda; color: #155724; }
        .status-badge.inactive { background: #fff3cd; color: #856404; }
        .status-badge.deleted { background: #f8d7da; color: #721c24; }
        @media (max-width: 900px) { .detail-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="users" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/users">Người dùng</a>
            <span>/</span>
            <span>Chi tiết #${user.id}</span>
        </div>

        <div class="page-header">
            <h1>${user.username}</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">← Danh sách</a>
                <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}" class="btn btn-primary">✏️ Sửa</a>
                <c:if test="${user.accountStatus != 'DELETED'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display:inline;"
                          onsubmit="return confirm('Xóa mềm tài khoản ${user.username}? Dữ liệu vẫn giữ trong database.');">
                        <input type="hidden" name="id" value="${user.id}">
                        <button type="submit" class="btn btn-danger">🗑 Xóa mềm</button>
                    </form>
                </c:if>
            </div>
        </div>

        <c:set var="accStatus" value="${not empty user.accountStatus ? user.accountStatus : 'ACTIVE'}"/>

        <div class="detail-grid">
            <div class="detail-card">
                <h3>Tài khoản</h3>
                <div class="detail-row"><span class="detail-label">ID</span><span class="detail-value">#${user.id}</span></div>
                <div class="detail-row"><span class="detail-label">Username</span><span class="detail-value">${user.username}</span></div>
                <div class="detail-row"><span class="detail-label">Vai trò</span>
                    <span class="detail-value"><span class="role-badge ${user.roleName == 'ADMIN' ? 'admin' : 'customer'}">${user.roleName}</span></span>
                </div>
                <div class="detail-row"><span class="detail-label">Trạng thái</span>
                    <span class="detail-value">
                        <span class="status-badge ${accStatus == 'ACTIVE' ? 'active' : accStatus == 'INACTIVE' ? 'inactive' : 'deleted'}">${accStatus}</span>
                    </span>
                </div>
                <c:if test="${not empty user.deletedAt}">
                    <div class="detail-row"><span class="detail-label">Ngày xóa mềm</span>
                        <span class="detail-value"><fmt:formatDate value="${user.deletedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                </c:if>
                <div class="detail-row"><span class="detail-label">Loại đăng nhập</span>
                    <span class="detail-value">${not empty user.oauthProvider ? user.oauthProvider : 'Email / Mật khẩu'}</span>
                </div>
            </div>

            <div class="detail-card">
                <h3>Liên hệ &amp; địa chỉ</h3>
                <div class="detail-row"><span class="detail-label">Email</span><span class="detail-value">${not empty user.email ? user.email : '—'}</span></div>
                <div class="detail-row"><span class="detail-label">Số điện thoại</span><span class="detail-value">${not empty user.customerPhone ? user.customerPhone : '—'}</span></div>
                <div class="detail-row"><span class="detail-label">Địa chỉ giao hàng</span><span class="detail-value">${not empty user.shippingAddress ? user.shippingAddress : '—'}</span></div>
                <div class="detail-row"><span class="detail-label">Quận / Huyện (ID)</span><span class="detail-value">${user.districtId != null ? user.districtId : '—'}</span></div>
                <div class="detail-row"><span class="detail-label">Mã phường/xã</span><span class="detail-value">${not empty user.wardCode ? user.wardCode : '—'}</span></div>
                <div class="detail-row"><span class="detail-label">Ghi chú</span><span class="detail-value">${not empty user.note ? user.note : '—'}</span></div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
