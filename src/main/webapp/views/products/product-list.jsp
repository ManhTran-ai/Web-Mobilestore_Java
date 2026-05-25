<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sản phẩm - Mobile Store</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; background: #fff; color: #1a1a1a; }
        .container { max-width: 976px; margin: 0 auto; padding: 0 24px; }
        .shop-container { max-width: 1280px; }
        .shop-layout { display: flex; gap: 1.25rem; align-items: flex-start; }
        .filter-sidebar { width: 248px; flex-shrink: 0; position: sticky; top: 88px; }
        .filter-panel {
            background: #fff;
            border: 1px solid #e5e5ea;
            border-radius: 10px;
            padding: 0.9rem 1rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
        }
        .filter-panel-title {
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 0.65rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e5e5ea;
        }
        .filter-section { margin-bottom: 0.75rem; }
        .filter-section:last-of-type { margin-bottom: 0; }
        .filter-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #666;
            margin-bottom: 0.35rem;
        }
        .filter-input {
            width: 100%;
            padding: 0.5rem 0.65rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            font-size: 0.88rem;
            font-family: inherit;
            transition: border-color 0.2s;
        }
        .filter-input:focus {
            outline: none;
            border-color: #1a1a1a;
        }
        .category-list {
            list-style: none;
            max-height: 160px;
            overflow-y: auto;
            padding-right: 2px;
        }
        .category-list::-webkit-scrollbar { width: 3px; }
        .category-list::-webkit-scrollbar-thumb { background: #d1d1d6; border-radius: 3px; }
        .category-item {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.28rem 0;
            cursor: pointer;
            font-size: 0.86rem;
            color: #333;
            line-height: 1.3;
        }
        .category-item input { accent-color: #1a1a1a; width: 14px; height: 14px; flex-shrink: 0; }
        .category-item:hover { color: #000; }
        .price-range-list { max-height: none; overflow: visible; }
        .price-custom-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.35rem;
            margin-top: 0.4rem;
        }
        .price-custom-row input {
            padding: 0.45rem 0.5rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            font-size: 0.8rem;
            width: 100%;
        }
        .price-hint { font-size: 0.72rem; color: #999; margin-top: 0.25rem; line-height: 1.3; }
        .filter-checkbox {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.45rem 0.55rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            background: #fafafa;
            cursor: pointer;
            font-size: 0.86rem;
        }
        .filter-checkbox input { width: 15px; height: 15px; accent-color: #1a1a1a; }
        .filter-actions {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            margin-top: 0.75rem;
            padding-top: 0.75rem;
            border-top: 1px solid #e5e5ea;
        }
        .filter-actions .btn {
            width: 100%;
            text-align: center;
            justify-content: center;
            padding: 0.55rem 0.75rem;
            font-size: 0.88rem;
        }
        .filter-actions .btn-clear {
            background: transparent !important;
            color: #666 !important;
            border: 1px solid #e5e5ea;
        }
        .filter-actions .btn-clear:hover { background: #f5f5f7 !important; color: #1a1a1a !important; }
        .shop-main { flex: 1; min-width: 0; }
        .results-bar {
            margin-bottom: 1.25rem;
            padding: 0.85rem 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #666;
            line-height: 1.5;
        }
        .results-bar strong { color: #1a1a1a; }
        .results-count { font-size: 0.95rem; color: #888; margin-bottom: 1rem; }
        .active-tags { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.5rem; }
        .active-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            background: #fff;
            border: 1px solid #e5e5ea;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #333;
        }
        .shop-main .grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        .header { background: #1a1a1a; height: 72px; padding: 0; position: sticky; top: 0; z-index: 100; }
        .header-content { display: flex; justify-content: space-between; align-items: center; height: 100%; }
        .logo { font-size: 1.5rem; font-weight: 600; color: #fff; letter-spacing: -0.5px; display: flex; align-items: center; height: 72px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #fff; text-decoration: none; font-size: 0.95rem; font-weight: 400; transition: opacity 0.2s; display: inline-flex; align-items: center; height: 72px; line-height: normal; }
        .nav a:hover { opacity: 0.7; }
        .user-pill { display: inline-flex; align-items: center; gap: 8px; padding: 8px 10px; }
        .user-pill:hover { background: rgba(255,255,255,0.15); }
        .user-avatar { width: 26px; height: 26px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.35); display: inline-flex; align-items: center; justify-content: center; font-size: 13px; }
        .user-name { font-weight: 600; }
        .page-title { padding: 2rem 0; }
        .grid { display: grid; gap: 1.5rem; }
        .card {
            border: 1px solid #e5e5ea;
            border-radius: 14px;
            padding: 1.25rem;
            background: #fff;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .card:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }
        .card img {
            width: 100%;
            height: 220px;
            object-fit: contain;
            display: block;
            margin-bottom: 0.75rem;
        }
        .card .name {
            font-weight: 600;
            font-size: 1.05rem;
            line-height: 1.35;
            margin-bottom: 0.35rem;
        }
        .card .manufacturer { color: #666; font-size: 0.95rem; margin-bottom: 0.65rem; }
        .card .product-info-price { margin-bottom: 0.5rem; }
        .pagination { display: flex; justify-content: center; gap: 0.5rem; margin: 1.5rem 0; }
        .current-price { font-size: 1.25rem; font-weight: 700; color: #1a1a1a; }
        .current-price.sale { color: #ff3b30; }
        .discount-tag { background: #000; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 0.95rem; font-weight: 600; }
        .old-price { font-size: 1rem; color: #86868b; text-decoration: line-through; }
        .btn { display: inline-block; padding: 0.65rem 1rem; border-radius: 8px; background: #000 !important; color: #fff !important; text-decoration: none; font-size: 0.95rem; }
        .btn.secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn.add-to-cart-btn {
            width: 100%;
            text-align: center;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            background: #000 !important;
            color: #fff !important;
        }
        .variant-selector { margin: 0.5rem 0; }
        .variant-selector select {
            width: 100%;
            padding: 0.55rem 0.65rem;
            border: 1px solid #e5e5ea;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .card-stock { color: #888; font-size: 0.95rem; }
        .wishlist-btn {
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #eee;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 20px;
            color: #ccc;
            transition: all 0.3s ease;
            z-index: 10;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .wishlist-btn:hover {
            transform: scale(1.1);
            color: #ff3b30;
        }
        .wishlist-btn.active {
            color: #ff3b30;
        }
        #toast-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .toast {
            background: #000 !important;
            background-color: #000 !important;
            color: #fff !important;
            --bs-toast-bg: #000;
            --bs-toast-color: #fff;
            --bs-toast-border-color: transparent;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-size: 14px;
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s ease;
        }
        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }
        @media (max-width: 1100px) {
            .shop-main .grid { grid-template-columns: repeat(2, 1fr); }
            .card img { height: 200px; }
        }
        @media (max-width: 992px) {
            .shop-layout { flex-direction: column; }
            .filter-sidebar { width: 100%; position: static; }
            .category-list { max-height: 160px; }
        }
        @media (max-width: 768px) {
            .container { padding: 0 12px; }
            .shop-main .grid { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
            .card { padding: 1rem; }
            .card img { height: 160px; }
            .card .name { font-size: 0.95rem; }
        }
        @media (max-width: 480px) {
            .shop-main .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">Mobile Store</div>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/products" style="color:#fff; font-weight:600;">Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang Quản Lý</a>
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

<main class="container shop-container">
    <div class="page-title"><h1>Danh sách sản phẩm</h1></div>

    <div class="shop-layout">
        <aside class="filter-sidebar">
            <form method="GET" action="${pageContext.request.contextPath}/products" class="filter-panel">
                <div class="filter-panel-title">
                    <span>Bộ lọc</span>
                </div>

                <div class="filter-section">
                    <label class="filter-label" for="search">Tìm kiếm</label>
                    <input type="text" id="search" name="search" class="filter-input"
                           value="${searchKeyword}" placeholder="Tên sản phẩm, hãng...">
                </div>

                <div class="filter-section">
                    <span class="filter-label">Danh mục</span>
                    <ul class="category-list">
                        <li>
                            <label class="category-item">
                                <input type="radio" name="category" value=""
                                       ${empty selectedCategory ? 'checked' : ''}>
                                <span>Tất cả danh mục</span>
                            </label>
                        </li>
                        <c:forEach var="category" items="${categories}">
                            <li>
                                <label class="category-item">
                                    <input type="radio" name="category" value="${category.categoryId}"
                                           ${selectedCategory == category.categoryId ? 'checked' : ''}>
                                    <span>${category.categoryName}</span>
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <div class="filter-section">
                    <span class="filter-label">Khoảng giá</span>
                    <ul class="category-list price-range-list">
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value=""
                                       ${empty selectedPriceRange ? 'checked' : ''}>
                                <span>Tất cả mức giá</span>
                            </label>
                        </li>
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value="under_5m"
                                       ${selectedPriceRange == 'under_5m' ? 'checked' : ''}>
                                <span>Dưới 5 triệu</span>
                            </label>
                        </li>
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value="5_10m"
                                       ${selectedPriceRange == '5_10m' ? 'checked' : ''}>
                                <span>5 - 10 triệu</span>
                            </label>
                        </li>
                    </ul>
                    <div class="price-custom-row">
                        <input type="number" name="minPrice" min="0" step="1000"
                               value="${minPriceInput}" placeholder="Từ">
                        <input type="number" name="maxPrice" min="0" step="1000"
                               value="${maxPriceInput}" placeholder="Đến">
                    </div>
                    <p class="price-hint">Nhập giá (VNĐ) nếu cần lọc chi tiết hơn.</p>
                </div>

                <div class="filter-section">
                    <label class="filter-checkbox" for="favoritesOnly">
                        <input id="favoritesOnly" type="checkbox" name="favorites" value="1"
                               ${favoritesOnly ? 'checked' : ''}>
                        <span>Chỉ xem yêu thích</span>
                    </label>
                </div>

                <div class="filter-actions">
                    <button type="submit" class="btn">Áp dụng bộ lọc</button>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-clear">Xóa bộ lọc</a>
                </div>
            </form>
        </aside>

        <div class="shop-main">
            <p class="results-count">Hiển thị <strong>${totalItems}</strong> sản phẩm</p>

            <c:if test="${favoritesOnly and favoritesRequiresLogin}">
                <div class="results-bar">
                    Vui lòng <a href="${pageContext.request.contextPath}/login" style="color:#000; font-weight:600;">đăng nhập</a> để xem sản phẩm yêu thích.
                </div>
            </c:if>

            <c:if test="${favoritesOnly or not empty searchKeyword or not empty selectedCategory or not empty priceRangeLabel}">
                <div class="results-bar">
                    <span>Đang lọc:</span>
                    <div class="active-tags">
                        <c:if test="${favoritesOnly}">
                            <span class="active-tag">Yêu thích</span>
                        </c:if>
                        <c:if test="${not empty searchKeyword}">
                            <span class="active-tag">"${searchKeyword}"</span>
                        </c:if>
                        <c:if test="${not empty selectedCategory}">
                            <c:forEach var="category" items="${categories}">
                                <c:if test="${category.categoryId == selectedCategory}">
                                    <span class="active-tag">${category.categoryName}</span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty priceRangeLabel}">
                            <span class="active-tag">${priceRangeLabel}</span>
                        </c:if>
                    </div>
                </div>
            </c:if>

    <div class="grid">
        <c:forEach var="product" items="${products}">
            <div class="card" data-product-id="${product.productId}" style="position: relative;">
                <c:set var="isLiked" value="false" />
                <c:if test="${not empty likedProductIds and likedProductIds.contains(product.productId)}">
                    <c:set var="isLiked" value="true" />
                </c:if>
                <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${product.productId}" title="Thêm vào yêu thích">
                    &hearts;
                </div>
                <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}"
                   style="text-decoration:none; color:inherit; display:block;">
                    <c:choose>
                        <c:when test="${not empty product.displayImage}">
                            <img src="${pageContext.request.contextPath}/${product.displayImage}" alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <div style="height:220px; display:flex; align-items:center; justify-content:center; color:#888; font-size:3rem;">📱</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="name">${product.productName}</div>
                    <div class="manufacturer">${product.manufacturer}</div>
                    <div class="product-info-price">
                        <c:choose>
                            <c:when test="${product.discount > 0}">
                                <div class="current-price">
                                    <fmt:formatNumber value="${product.displayOriginalPrice * (100 - product.discount) / 100}"
                                                      type="number"/>₫
                                </div>
                                <div style="display: flex; align-items: center; gap: 8px; margin-top: 2px;">
                <span class="old-price">
                    <fmt:formatNumber value="${product.displayOriginalPrice}" type="number"/>₫
                </span>
                                    <span class="discount-tag">-${product.discount}%</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="current-price">
                                    <fmt:formatNumber value="${product.displayPrice}" type="number"/>₫
                                </div>
                                <div style="height: 21px;"></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-stock">
                        <c:choose>
                            <c:when test="${product.totalStock == 0}">Hết hàng</c:when>
                            <c:otherwise>Tồn kho: ${product.totalStock}</c:otherwise>
                        </c:choose>
                    </div>
                </a>
                <div class="variant-selector" style="margin-top:8px;">
                    <select class="variant-select" data-product-id="${product.productId}">
                        <c:forEach var="v" items="${product.variants}">
                            <option value="${v.variantId}"
                                    data-price="${v.price}"
                                    data-stock="${v.quantityInStock}"
                                    data-image="${v.variantImage}">
                                    ${v.color} / ${v.storage} - <fmt:formatNumber value="${v.price}" type="number"/>₫
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div style="margin-top:8px;">
                    <button class="btn add-to-cart-btn add-btn"
                            data-product-id="${product.productId}"
                        ${product.totalStock == 0 ? 'disabled' : ''}>
                            ${product.totalStock == 0 ? 'Hết hàng' : 'Chọn mua'}
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty products}">
        <div style="padding: 2rem 0; text-align: center; color: #666;">
            <c:choose>
                <c:when test="${favoritesOnly}">Bạn chưa có sản phẩm yêu thích nào.</c:when>
                <c:otherwise>Không có sản phẩm phù hợp.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage - 1}${filterQuery}">« Trước</a>
            </c:if>
            <c:forEach var="p" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${p == currentPage}">
                        <span class="btn secondary">${p}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/products?page=${p}${filterQuery}">${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage + 1}${filterQuery}">Tiếp »</a>
            </c:if>
        </div>
    </c:if>

        </div>
    </div>
</main>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<footer class="text-light pt-5 pb-3 mt-5" style="background-color: #000000;">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Mobile Store</h5>
                <p><i class="fas fa-map-marker-alt me-2"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
                <p><i class="fas fa-phone-alt me-2"></i> Hotline: 1800.1234</p>
                <p><i class="fas fa-envelope me-2"></i> support@mobilestore.com</p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Chính sách hỗ trợ</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách bảo hành</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Bảo mật thông tin</a></li>
                </ul>
            </div>
        </div>
        <hr class="my-4 border-secondary">
        <div class="row align-items-center">
            <div class="col-md-12 text-center">
                <p class="mb-0 text-secondary">&copy; 2026 Mobile Store. Thiết kế bởi Sinh viên IT.</p>
            </div>
        </div>
    </div>
</footer>

<div id="toast-container"></div>
<script>
    const isFavoritesFilter = ${favoritesOnly};

    function showToast(message) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast';
        toast.textContent = message;
        container.appendChild(toast);
        
        setTimeout(() => toast.classList.add('show'), 10);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    document.addEventListener('DOMContentLoaded', () => {
        const wishlistBtns = document.querySelectorAll('.wishlist-btn');
        wishlistBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                const productId = this.getAttribute('data-id');
                const currentBtn = this;
                
                fetch('${pageContext.request.contextPath}/api/toggle-like', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        if (data.action === 'liked') {
                            currentBtn.classList.add('active');
                        } else {
                            currentBtn.classList.remove('active');
                            if (isFavoritesFilter) {
                                const card = currentBtn.closest('.card');
                                if (card) card.remove();
                            }
                        }
                        showToast(data.message);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!');
                        if (data.message && data.message.includes('đăng nhập')) {
                            setTimeout(() => {
                                window.location.href = '${pageContext.request.contextPath}/login';
                            }, 1500);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Không thể kết nối đến máy chủ.');
                });
            });
        });
    });

    function refreshCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(r => r.json())
            .then(data => {
                const el = document.getElementById('cartCount');
                if (el) el.textContent = data.count;
            }).catch(() => {});
    }

    document.querySelectorAll('.add-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const card = this.closest('.card');
            const select = card.querySelector('.variant-select');
            if (!select) {
                showToast('Không có phiên bản nào cho sản phẩm này');
                return;
            }
            const variantId = select.value;
            const selectedOption = select.options[select.selectedIndex];
            const stock = parseInt(selectedOption.getAttribute('data-stock') || '0', 10);

            if (stock <= 0) {
                showToast('Phiên bản đã hết hàng');
                return;
            }

            fetch('${pageContext.request.contextPath}/cart?action=add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                credentials: 'same-origin',
                body: 'variantId=' + encodeURIComponent(variantId) + '&quantity=1'
            }).then(async res => {
                if (res.status === 401) {
                    const json = await res.json().catch(() => null);
                    if (json && json.redirect) {
                        window.location.href = json.redirect;
                        return;
                    }
                    throw new Error('Vui lòng đăng nhập để tiếp tục');
                }
                if (!res.ok) {
                    const txt = await res.text().catch(() => null);
                    let msg = 'Lỗi khi thêm vào giỏ';
                    try { msg = JSON.parse(txt).message || txt || msg; } catch (e) { msg = txt || msg; }
                    throw new Error(msg);
                }
                return res.json().catch(() => null);
            }).then(json => {
                if (json && json.count !== undefined) {
                    const el = document.getElementById('cartCount');
                    if (el) el.textContent = json.count;
                    showToast('Đã thêm vào giỏ hàng');
                } else {
                    refreshCartCount();
                    showToast('Đã thêm vào giỏ hàng');
                }
            }).catch(err => {
                console.error('Add to cart failed', err);
                alert(err.message || 'Lỗi khi thêm vào giỏ');
            });
        });
    });
    refreshCartCount();
</script>
</body>
</html>
