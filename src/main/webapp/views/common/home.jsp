<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Mobile Store</title>
    <style>
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #ffffff;
        }

        .header {
            background: #1a1a1a;
            border-bottom: none;
            height: 72px;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .container {
            max-width: 976px;
            margin: 0 auto;
            padding: 0 24px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 100%;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 600;
            color: #ffffff;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            height: 72px;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav a {
            color: #ffffff;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 400;
            transition: opacity 0.2s;
            display: inline-flex;
            align-items: center;
            height: 72px;
            line-height: normal;
        }

        .nav a:hover {
            opacity: 0.7;
        }

        .user-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 10px;
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

        .hero {
            background: #ffffff;
            padding: 0;
            position: relative;
            overflow: hidden;
        }

        .carousel-container {
            position: relative;
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            overflow: hidden;
        }

        .carousel-slides {
            display: flex;
            transition: transform 0.6s ease-in-out;
            will-change: transform;
            position: relative;
        }

        .carousel-slide {
            min-width: 100%;
            width: 100%;
            flex: 0 0 100%;
            flex-shrink: 0;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ffffff;
            padding: 4rem 2rem;
        }

        .carousel-slide img {
            max-width: 100%;
            height: auto;
            max-height: 600px;
            object-fit: contain;
        }

        .carousel-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(26, 26, 26, 0.7);
            color: #ffffff;
            border: none;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s;
            z-index: 10;
        }

        .carousel-nav:hover {
            background: rgba(26, 26, 26, 0.9);
        }

        .carousel-nav.prev {
            left: 24px;
        }

        .carousel-nav.next {
            right: 24px;
        }

        .carousel-dots {
            display: flex;
            justify-content: center;
            gap: 12px;
            padding: 2rem 0;
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
        }

        .carousel-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(26, 26, 26, 0.3);
            border: none;
            cursor: pointer;
            transition: background 0.3s, transform 0.3s;
        }

        .carousel-dot.active {
            background: #1a1a1a;
            transform: scale(1.2);
        }

        .hero-content {
            text-align: center;
            padding: 3rem 0;
        }

        .hero-content h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #1a1a1a;
            font-weight: 600;
            letter-spacing: -1px;
        }

        .hero-content p {
            font-size: 1.1rem;
            margin-bottom: 2.5rem;
            color: #666;
            font-weight: 400;
        }

        .btn {
            display: inline-block;
            padding: 14px 32px;
            background: #1a1a1a !important;
            color: #ffffff !important;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            transition: background-color 0.2s, transform 0.2s;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background: #333 !important;
            transform: translateY(-1px);
        }

        .features {
            padding: 5rem 0;
            background: #ffffff;
        }

        .features h2 {
            text-align: center;
            margin-bottom: 3rem;
            font-size: 2rem;
            font-weight: 600;
            color: #1a1a1a;
            letter-spacing: -0.5px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            text-align: center;
            padding: 2.5rem 2rem;
            border-radius: 12px;
            border: 1px solid #e5e5e5;
            background: #ffffff;
            transition: border-color 0.2s, transform 0.2s;
        }

        .feature-card:hover {
            border-color: #1a1a1a;
            transform: translateY(-2px);
        }

        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1.25rem;
        }

        .feature-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
            color: #1a1a1a;
            font-weight: 600;
        }

        .feature-card p {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .footer {
            background: #ffffff;
            color: #666;
            text-align: center;
            padding: 3rem 0;
            margin-top: 4rem;
            border-top: 1px solid #e5e5e5;
        }

        .footer p {
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .flash-message {
            max-width: 1200px;
            margin: 20px auto;
            padding: 14px 20px;
            background: #f0f9ff;
            color: #065f46;
            border: 1px solid #bae6fd;
            border-radius: 8px;
            font-size: 0.95rem;
        }

        .sale-products {
            padding: 3rem 0;
            background: #ffffff;
        }

        .price-container {
            display: flex;
            align-items: baseline;
            gap: 8px;
            margin-top: 4px;
        }

        .sale-price {
            font-weight: 600;
            font-size: 1.1rem;
            color: #000000;
        }

        .original-price {
            font-size: 0.9rem;
            color: #86868b;
            text-decoration: line-through;
            font-weight: 400;
        }

        .sale-badge {
            background: #000;
            color: #fff;
            font-size: 0.75rem;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
        }

        .product-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slider.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home-categories.css">
</head>
<body>
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
                            <a href="${pageContext.request.contextPath}/admin/products" style="color: #0071e3;">Trang
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

<c:if test="${not empty sessionScope.flashSuccess}">
    <div class="flash-message">
            ${sessionScope.flashSuccess}
    </div>
    <c:remove var="flashSuccess" scope="session"/>
</c:if>

<section class="hero">
    <div class="hero-content">
        <div class="container">
            <h1>Chào Mừng Đến Mobile Store</h1>
            <p>Nơi bạn tìm thấy những chiếc điện thoại tốt nhất với giá cả hợp lý</p>
            <a href="${pageContext.request.contextPath}/products" class="btn">Xem Sản Phẩm</a>
        </div>
    </div>
    <div class="carousel-container">
        <div class="carousel-slides" id="carouselSlides">
            <div class="carousel-slide">
                <img src="${pageContext.request.contextPath}/images/iPhone.png"/>
            </div>
            <div class="carousel-slide">
                <img src="${pageContext.request.contextPath}/images/macbook.png"/>
            </div>
            <div class="carousel-slide">
                <img src="${pageContext.request.contextPath}/images/iPad.png"/>
            </div>
            <div class="carousel-slide">
                <img src="${pageContext.request.contextPath}/images/Apple_Watch.png"/>
            </div>
        </div>

        <div class="carousel-dots" id="carouselDots"></div>
    </div>
</section>

<script src="${pageContext.request.contextPath}/assets/js/slider.js"></script>

<section class="categories">
    <div class="container">
        <h2 style="text-align:center; margin-bottom:1.25rem;">Khám Phá Sản Phẩm</h2>
        <div class="categories-grid">
            <a class="category-tile" href="${pageContext.request.contextPath}/products?category=1">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/images/iPhone.png" alt="iPhone">
                </div>
                <div class="category-meta">
                    <h3>iPhone</h3>
                    <p>Tuyệt tác công nghệ và nhiếp ảnh</p>
                </div>
            </a>

            <a class="category-tile" href="${pageContext.request.contextPath}/products?category=2">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/images/Macbook.png" alt="Macbook">
                </div>
                <div class="category-meta">
                    <h3>Macbook</h3>
                    <p>Đỉnh cao hiệu năng và sáng tạo</p>
                </div>
            </a>

            <a class="category-tile" href="${pageContext.request.contextPath}/products?category=3">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/images/Apple_Watch.png" alt="Apple Watch">
                </div>
                <div class="category-meta">
                    <h3>Apple Watch</h3>
                    <p>Người đồng hành cho sức khỏe</p>
                </div>
            </a>

            <a class="category-tile" href="${pageContext.request.contextPath}/products?category=4">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/images/iPad.png" alt="iPad">
                </div>
                <div class="category-meta">
                    <h3>iPad</h3>
                    <p>Đa năng, mỏng nhẹ và mạnh mẽ</p>
                </div>
            </a>
        </div>
    </div>
</section>
<section class="sale-products" style="padding: 3rem 0; background:#ffffff; border-bottom: 1px solid #f5f5f7;">
    <c:if test="${not empty saleProducts}">
        <div class="container">
            <h2 style="text-align:center; margin-bottom:1.25rem;">Ưu đãi đặc biệt</h2>
            <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap:1.5rem;">
                <c:forEach var="p" items="${saleProducts}">
                    <div class="product-card"
                         style="border:1px solid #e5e5ea; border-radius:12px; padding:1rem; text-align:left; background:#fff; position: relative;">
                        <span class="sale-badge"
                              style="position: absolute; top: 10px; right: 10px; z-index: 1;">-${p.discount}%</span>
                        
                        <c:set var="isLiked" value="false" />
                        <c:if test="${not empty likedProductIds and likedProductIds.contains(p.productId)}">
                            <c:set var="isLiked" value="true" />
                        </c:if>
                        <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${p.productId}" title="Thêm vào yêu thích" style="top: 40px;">
                            &hearts;
                        </div>

                        <a href="${pageContext.request.contextPath}/products/view?id=${p.productId}"
                           style="text-decoration:none; color:inherit;">
                            <div style="height:160px; display:flex; align-items:center; justify-content:center; overflow:hidden; margin-bottom:0.75rem;">
                                <c:choose>
                                    <c:when test="${not empty p.displayImage}">
                                        <img src="${pageContext.request.contextPath}/${p.displayImage}" alt="${p.productName}"
                                             style="max-width:100%; max-height:100%; object-fit:contain;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#888;">
                                            &#128241;
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="font-weight:600; margin-bottom:0.25rem; font-size:1rem; line-height:1.3;">${p.productName}</div>
                            <div style="color:#666; font-size:0.9rem; margin-bottom:0.25rem;">${p.manufacturer}</div>

                            <div class="price-container">
                                <span class="sale-price" style="color:#0071e3; font-weight:700;">
                                    <fmt:formatNumber value="${p.displayPrice}" type="number"
                                                      groupingUsed="true"/>₫
                                </span>
                                <span class="original-price"
                                      style="color:#86868b; text-decoration:line-through; font-size:0.85rem; margin-left:5px;">
                                    <fmt:formatNumber value="${p.displayOriginalPrice}" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>

                            <div style="font-size:0.9rem; color:#888; margin-top:0.5rem;">
                                <c:choose>
                                    <c:when test="${p.totalStock == 0}">Hết hàng</c:when>
                                </c:choose>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</section>
<section class="products" style="padding: 3rem 0; background:#ffffff;">
    <div class="container">
        <h2 style="text-align:center; margin-bottom:1.25rem;">Sản phẩm mới</h2>
        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap:1.5rem;">
            <c:forEach var="product" items="${products}">
                <div style="border:1px solid #e5e5ea; border-radius:12px; padding:1rem; text-align:left; background:#ffffff; position: relative;">
                    <c:set var="isLiked" value="false" />
                    <c:if test="${not empty likedProductIds and likedProductIds.contains(product.productId)}">
                        <c:set var="isLiked" value="true" />
                    </c:if>
                    <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${product.productId}" title="Thêm vào yêu thích">
                        &hearts;
                    </div>
                    <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}"
                       style="text-decoration:none; color:inherit;">
                        <div style="height:160px; display:flex; align-items:center; justify-content:center; overflow:hidden; margin-bottom:0.75rem;">
                            <c:choose>
                                <c:when test="${not empty product.displayImage}">
                                    <img src="${pageContext.request.contextPath}/${product.displayImage}"
                                         alt="${product.productName}"
                                         style="max-width:100%; max-height:100%; object-fit:contain;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#888;">
                                        &#128241;
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-weight:600; margin-bottom:0.25rem; font-size:1rem; line-height:1.3;">${product.productName}</div>
                        <div style="color:#666; font-size:0.9rem; margin-bottom:0.25rem;">${product.manufacturer}</div>
                        <div style="font-weight:700; font-size:1.1rem; color:#0071e3; margin-bottom:0.5rem; display:flex; align-items:center;">
                            <fmt:formatNumber value="${product.displayPrice}" type="number"
                                              groupingUsed="true"/>₫
                        </div>
                        <div style="font-size:0.9rem; color:#888; margin-bottom:0.75rem;">
                            <c:choose>
                                <c:when test="${product.totalStock == 0}">Hết hàng</c:when>
                            </c:choose>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

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
                <div class="mt-3">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Chính sách hỗ trợ</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="policy.jsp?type=warranty" class="text-secondary text-decoration-none">Chính
                        sách bảo hành</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=return" class="text-secondary text-decoration-none">Chính
                        sách đổi trả</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=shipping" class="text-secondary text-decoration-none">Chính
                        sách vận chuyển</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=privacy" class="text-secondary text-decoration-none">Bảo
                        mật thông tin</a></li>
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
            }).catch(() => {
        });
    }

    document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const productId = this.getAttribute('data-id');
            const stock = parseInt(this.getAttribute('data-stock') || '0', 10);
            if (stock <= 0) {
                showToast('Sản phẩm đã hết hàng');
                return;
            }

            fetch('${pageContext.request.contextPath}/cart?action=add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                credentials: 'same-origin',
                body: 'productId=' + encodeURIComponent(productId) + '&quantity=1'
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
                    try {
                        msg = JSON.parse(txt).message || txt || msg;
                    } catch (e) {
                        msg = txt || msg;
                    }
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

