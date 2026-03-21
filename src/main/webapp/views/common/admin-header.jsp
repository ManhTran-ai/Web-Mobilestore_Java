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
        </ul>
    </nav>
</aside>

