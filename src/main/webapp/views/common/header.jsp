<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    .user-pill {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 10px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.08);
        color: #fff;
        text-decoration: none;
    }

    .user-pill:hover {
        background: rgba(255, 255, 255, 0.15);
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

    .user-name {
        font-weight: 600;
    }
</style>
<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">Mobile Store</div>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/products">Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang
                                Quản Lý</a>
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
