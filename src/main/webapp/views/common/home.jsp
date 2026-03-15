<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Mobile Store</title>
    <style>
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
            background: #1a1a1a;
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            transition: background-color 0.2s, transform 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background: #333;
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
                                <a href="${pageContext.request.contextPath}/admin/products" style="color: #0071e3;">Trang Quản Lý</a>
                            </c:if>
                            <span style="color: #888;">Xin chào, ${sessionScope.user.username}</span>
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
                    <img src="${pageContext.request.contextPath}/images/img_1.png" alt="iPhone 15 Pro" />
                </div>
                <div class="carousel-slide">
                    <img src="${pageContext.request.contextPath}/images/img_2.png" alt="iPhone 15 Pro" />
                </div>
                <div class="carousel-slide">
                    <img src="${pageContext.request.contextPath}/images/img_3.png" alt="iPhone 14 Pro" />
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
                        <img src="${pageContext.request.contextPath}/images/img_1.png" alt="iPhone">
                    </div>
                    <div class="category-meta">
                        <h3>iPhone</h3>
                        <p>Thiết kế, camera, hiệu năng</p>
                    </div>
                </a>
                <a class="category-tile" href="${pageContext.request.contextPath}/products?category=2">
                    <div class="category-image">
                        <img src="${pageContext.request.contextPath}/images/img_2.png" alt="Macbook">
                    </div>
                    <div class="category-meta">
                        <h3>Macbook</h3>
                        <p>Hiệu năng cho công việc và sáng tạo</p>
                    </div>
                </a>
                <a class="category-tile" href="${pageContext.request.contextPath}/products?category=3">
                    <div class="category-image">
                        <img src="${pageContext.request.contextPath}/images/img_3.png" alt="Dell Laptop">
                    </div>
                    <div class="category-meta">
                        <h3>Dell Laptop</h3>
                        <p>Đa dụng cho doanh nghiệp và học tập</p>
                    </div>
                </a>
                <a class="category-tile" href="${pageContext.request.contextPath}/products?category=4">
                    <div class="category-image">
                        <img src="${pageContext.request.contextPath}/images/img_1.png" alt="iPad">
                    </div>
                    <div class="category-meta">
                        <h3>iPad</h3>
                        <p>Màn hình đa nhiệm, sáng tạo nội dung</p>
                    </div>
                </a>
                <a class="category-tile" href="${pageContext.request.contextPath}/products?category=5">
                    <div class="category-image">
                        <img src="${pageContext.request.contextPath}/images/img_2.png" alt="Samsung">
                    </div>
                    <div class="category-meta">
                        <h3>Samsung</h3>
                        <p>Đổi mới công nghệ và camera</p>
                    </div>
                </a>
                <a class="category-tile" href="${pageContext.request.contextPath}/products?category=6">
                    <div class="category-image">
                        <img src="${pageContext.request.contextPath}/images/img_3.png" alt="Xiaomi">
                    </div>
                    <div class="category-meta">
                        <h3>Xiaomi</h3>
                        <p>Giá trị tốt với tính năng đa dạng</p>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <section class="features">
        <div class="container">
            <h2>Tại Sao Chọn Chúng Tôi?</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🚀</div>
                    <h3>Giao Hàng Nhanh</h3>
                    <p>Giao hàng trong vòng 24h tại TP.HCM</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">💎</div>
                    <h3>Chất Lượng Cao</h3>
                    <p>Sản phẩm chính hãng, bảo hành đầy đủ</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">💰</div>
                    <h3>Giá Cả Hợp Lý</h3>
                    <p>Giá tốt nhất thị trường với nhiều ưu đãi</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🛡️</div>
                    <h3>Bảo Hành Tốt</h3>
                    <p>Bảo hành chính hãng, hỗ trợ 24/7</p>
                </div>
            </div>
        </div>
    </section>
    
    <section class="products" style="padding: 3rem 0; background:#ffffff;">
        <div class="container">
            <h2 style="text-align:center; margin-bottom:1.25rem;">Sản phẩm mới</h2>
            <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:1.5rem;">
                <c:forEach var="product" items="${products}">
                    <div style="border:1px solid #e5e5ea; border-radius:12px; padding:1rem; text-align:left; background:#fff;">
                        <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}" style="text-decoration:none; color:inherit;">
                            <div style="height:160px; display:flex; align-items:center; justify-content:center; overflow:hidden; margin-bottom:0.75rem;">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}" style="max-width:100%; max-height:100%; object-fit:contain;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#888;">📱</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="font-weight:600; margin-bottom:0.25rem; font-size:1rem; line-height:1.3;">${product.productName}</div>
                            <div style="color:#666; font-size:0.9rem; margin-bottom:0.25rem;">${product.manufacturer}</div>
                            <div style="font-weight:700; font-size:1.1rem; color:#0071e3; margin-bottom:0.5rem; display:flex; align-items:center;">
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
                            </div>
                            <div style="font-size:0.9rem; color:#888; margin-bottom:0.75rem;">
                                <c:choose>
                                    <c:when test="${product.quantityInStock == 0}">Hết hàng</c:when>
                                    <c:otherwise>Tồn kho: ${product.quantityInStock}</c:otherwise>
                                </c:choose>
                            </div>
                            <button class="btn add-to-cart-btn" data-id="${product.productId}"
                                    data-stock="${product.quantityInStock}"
                                    style="width:100%; padding:0.5rem; font-size:0.9rem;">
                                Thêm vào giỏ
                            </button>
                        </a>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <div style="display:flex; justify-content:center; gap:0.5rem; margin-top:1.5rem;">
                    <c:if test="${currentPage > 1}">
                        <a class="btn" href="${pageContext.request.contextPath}/?page=${currentPage - 1}">« Trước</a>
                    </c:if>
                    <c:forEach var="p" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${p == currentPage}">
                                <span class="btn btn-secondary" style="background:#e5e5ea; color:#1a1a1a;">${p}</span>
                            </c:when>
                            <c:otherwise>
                                <a class="btn" href="${pageContext.request.contextPath}/?page=${p}">${p}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a class="btn" href="${pageContext.request.contextPath}/?page=${currentPage + 1}">Tiếp »</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 Mobile Store. Tất cả quyền được bảo lưu.</p>
            <p>Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM | Hotline: 0123-456-789</p>
        </div>
    </footer>

    <script>
        function refreshCartCount() {
            fetch('${pageContext.request.contextPath}/cart/count')
                .then(r => r.json())
                .then(data => {
                    const el = document.getElementById('cartCount');
                    if (el) el.textContent = data.count;
                }).catch(() => {});
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

        function showToast(message) {
            let t = document.getElementById('toastMessage');
            if (!t) {
                t = document.createElement('div');
                t.id = 'toastMessage';
                t.style.position = 'fixed';
                t.style.right = '16px';
                t.style.bottom = '16px';
                t.style.background = '#111';
                t.style.color = '#fff';
                t.style.padding = '10px 14px';
                t.style.borderRadius = '8px';
                t.style.zIndex = 9999;
                document.body.appendChild(t);
            }
            t.textContent = message;
            t.style.opacity = '1';
            setTimeout(() => {
                t.style.opacity = '0';
            }, 2000);
        }

        refreshCartCount();
    </script>
</body>
</html>

