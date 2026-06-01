<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa người dùng' : 'Thêm người dùng'} - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .breadcrumb { display: flex; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb span { color: #888; }
        .form-card { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; max-width: 640px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem 1.25rem; }
        .form-group { margin-bottom: 0.25rem; }
        .form-group.full { grid-column: 1 / -1; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.95rem; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; font-family: inherit; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .help-text { font-size: 0.85rem; color: #888; margin-top: 0.35rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e5e5ea; }
        @media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }
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
            <span>${isEdit ? 'Sửa' : 'Thêm mới'}</span>
        </div>

        <div class="page-header">
            <h1>${isEdit ? 'Sửa người dùng' : 'Thêm người dùng'}</h1>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">${errorMessage}</div>
        </c:if>

        <div class="form-card">
            <form method="post" action="${pageContext.request.contextPath}/admin/users/${isEdit ? 'update' : 'create'}">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${user.id}">
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="username">Username <span class="required">*</span></label>
                        <input class="form-control" type="text" id="username" name="username" required
                               value="${user.username}" ${isEdit && not empty user.oauthProvider ? 'readonly' : ''}>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input class="form-control" type="email" id="email" name="email" value="${user.email}">
                    </div>

                    <c:if test="${!isEdit}">
                        <div class="form-group">
                            <label class="form-label" for="password">Mật khẩu <span class="required">*</span></label>
                            <input class="form-control" type="password" id="password" name="password" required minlength="6">
                            <p class="help-text">Tối thiểu 6 ký tự (tài khoản đăng nhập thường).</p>
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label class="form-label" for="roleName">Vai trò <span class="required">*</span></label>
                        <select class="form-control" id="roleName" name="roleName" required>
                            <option value="CUSTOMER" ${user.roleName == 'CUSTOMER' ? 'selected' : ''}>Khách hàng (CUSTOMER)</option>
                            <option value="ADMIN" ${user.roleName == 'ADMIN' ? 'selected' : ''}>Quản trị (ADMIN)</option>
                            <option value="INVENTORY_MANAGER" ${user.roleName == 'INVENTORY_MANAGER' ? 'selected' : ''}>Quản lý kho (INVENTORY_MANAGER)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="accountStatus">Trạng thái <span class="required">*</span></label>
                        <select class="form-control" id="accountStatus" name="accountStatus" required>
                            <c:set var="st" value="${not empty user.accountStatus ? user.accountStatus : 'ACTIVE'}"/>
                            <option value="ACTIVE" ${st == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="INACTIVE" ${st == 'INACTIVE' ? 'selected' : ''}>Ngưng hoạt động</option>
                            <c:if test="${isEdit && st == 'DELETED'}">
                                <option value="DELETED" selected>Đã xóa (chỉ hiển thị, không khôi phục từ form)</option>
                            </c:if>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="customerPhone">Số điện thoại</label>
                        <input class="form-control" type="text" id="customerPhone" name="customerPhone" value="${user.customerPhone}">
                    </div>

                    <div class="form-group full">
                        <label class="form-label" for="shippingAddress">Địa chỉ giao hàng</label>
                        <input class="form-control" type="text" id="shippingAddress" name="shippingAddress" value="${user.shippingAddress}">
                    </div>

                    <div class="form-group full">
                        <label class="form-label" for="note">Ghi chú (admin)</label>
                        <textarea class="form-control" id="note" name="note" rows="3">${user.note}</textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">${isEdit ? 'Lưu thay đổi' : 'Tạo tài khoản'}</button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>
