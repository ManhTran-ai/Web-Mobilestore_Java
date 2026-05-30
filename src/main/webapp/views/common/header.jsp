<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-layout.css">
<header class="header">
    <div class="container">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">Mobile Store</a>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/" ${activePage == 'home' ? 'style="font-weight:600;"' : ''}>Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/products" ${activePage == 'products' ? 'style="font-weight:600;"' : ''}>Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart" ${activePage == 'cart' ? 'style="font-weight:600;"' : ''}>Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/inventory" style="color:#0071e3;">Trang Quản Lý</a>
                        </c:if>
                        <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                            <span class="user-avatar">👤</span>
                            <span class="user-name">${sessionScope.user.username}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/register">Đăng Ký</a>
                        <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </div>
</header>
