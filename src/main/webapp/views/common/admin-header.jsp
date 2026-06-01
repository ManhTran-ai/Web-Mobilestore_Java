<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
            <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" ${activeMenu == 'dashboard' ? 'class="active"' : ''}>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/products" ${activeMenu == 'products' ? 'class="active"' : ''}>
                        Sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders" ${activeMenu == 'orders' ? 'class="active"' : ''}>
                        Đơn hàng
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/sliders" ${activeMenu == 'sliders' ? 'class="active"' : ''}>
                        Slider Images
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/categories" ${activeMenu == 'categories' ? 'class="active"' : ''}>
                        Danh mục
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/reviews" ${activeMenu == 'reviews' ? 'class="active"' : ''}>
                        Đánh giá
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users" ${activeMenu == 'users' ? 'class="active"' : ''}>
                        Người dùng
                    </a>
                </li>
            </c:if>
            <c:if test="${sessionScope.user.roleName == 'ADMIN' || sessionScope.user.roleName == 'INVENTORY_MANAGER'}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/inventory" ${activeMenu == 'inventory' ? 'class="active"' : ''}>
                        Quản Lý Kho
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</aside>

