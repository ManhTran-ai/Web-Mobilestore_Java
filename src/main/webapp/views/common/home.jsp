<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.Set" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Mobile Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slider.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home-categories.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero {
            background: #ffffff;
            padding: 0;
            position: relative;
            overflow: hidden;
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
    </style>
</head>
<c:set var="activePage" value="home" scope="request"/>
<body>
<jsp:include page="/views/common/header.jsp"/>

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
            <c:choose>
                <c:when test="${not empty sliderImages}">
                    <c:forEach var="slider" items="${sliderImages}">
                        <div class="carousel-slide">
                            <img src="${pageContext.request.contextPath}/${slider.imageUrl}" alt="Slider"/>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="carousel-slide">
                        <img src="${pageContext.request.contextPath}/images/iPhone.png" alt="iPhone"/>
                    </div>
                    <div class="carousel-slide">
                        <img src="${pageContext.request.contextPath}/images/Macbook.png" alt="Macbook"/>
                    </div>
                    <div class="carousel-slide">
                        <img src="${pageContext.request.contextPath}/images/iPad.png" alt="iPad"/>
                    </div>
                    <div class="carousel-slide">
                        <img src="${pageContext.request.contextPath}/images/Apple_Watch.png" alt="Apple Watch"/>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <button class="carousel-nav prev" id="carouselPrev">&#10094;</button>
        <button class="carousel-nav next" id="carouselNext">&#10095;</button>
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

<c:if test="${not empty saleProducts}">
    <section style="padding: 3rem 0; background:#ffffff; border-bottom: 1px solid #f5f5f7;">
        <div class="container">
            <h2 style="text-align:center; margin-bottom:1.25rem;">Ưu đãi đặc biệt</h2>
            <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap:1.5rem;">
                <c:forEach var="p" items="${saleProducts}">
                    <div class="product-card">
                        <span class="sale-badge" style="position: absolute; top: 10px; right: 10px; z-index: 1;">-${p.discount}%</span>
                        <c:set var="isLiked" value="false"/>
                        <c:if test="${not empty likedProductIds and likedProductIds.contains(p.productId)}">
                            <c:set var="isLiked" value="true"/>
                        </c:if>
                        <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${p.productId}" title="Thêm vào yêu thích" style="top: 40px;">&#9829;</div>
                        <a href="${pageContext.request.contextPath}/products/view?id=${p.productId}" style="text-decoration:none; color:inherit; display:block;">
                            <div style="height:160px; display:flex; align-items:center; justify-content:center; overflow:hidden; margin-bottom:0.75rem;">
                                <c:choose>
                                    <c:when test="${not empty p.displayImage}">
                                        <img src="${pageContext.request.contextPath}/${p.displayImage}" alt="${p.productName}" style="max-width:100%; max-height:100%; object-fit:contain;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#888;">&#128241;</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="font-weight:600; margin-bottom:0.25rem; font-size:1rem; line-height:1.3;">${p.productName}</div>
                            <div style="color:#666; font-size:0.9rem; margin-bottom:0.25rem;">${p.manufacturer}</div>
                            <div class="price-container">
                                <span class="sale-price" style="color:#0071e3; font-weight:700;">
                                    <fmt:formatNumber value="${p.displayPrice}" type="number" groupingUsed="true"/>₫
                                </span>
                                <span class="original-price">
                                    <fmt:formatNumber value="${p.displayOriginalPrice}" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>
                            <c:if test="${p.totalStock == 0}">
                                <div style="font-size:0.9rem; color:#888; margin-top:0.5rem;">Hết hàng</div>
                            </c:if>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</c:if>

<section style="padding: 3rem 0; background:#ffffff;">
    <div class="container">
        <h2 style="text-align:center; margin-bottom:1.25rem;">Sản phẩm mới</h2>
        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap:1.5rem;">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <c:set var="isLiked" value="false"/>
                    <c:if test="${not empty likedProductIds and likedProductIds.contains(product.productId)}">
                        <c:set var="isLiked" value="true"/>
                    </c:if>
                    <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${product.productId}" title="Thêm vào yêu thích">&#9829;</div>
                    <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}" style="text-decoration:none; color:inherit; display:block;">
                        <div style="height:160px; display:flex; align-items:center; justify-content:center; overflow:hidden; margin-bottom:0.75rem;">
                            <c:choose>
                                <c:when test="${not empty product.displayImage}">
                                    <img src="${pageContext.request.contextPath}/${product.displayImage}" alt="${product.productName}" style="max-width:100%; max-height:100%; object-fit:contain;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#888;">&#128241;</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-weight:600; margin-bottom:0.25rem; font-size:1rem; line-height:1.3;">${product.productName}</div>
                        <div style="color:#666; font-size:0.9rem; margin-bottom:0.25rem;">${product.manufacturer}</div>
                        <div style="font-weight:700; font-size:1.1rem; color:#0071e3;">
                            <fmt:formatNumber value="${product.displayPrice}" type="number" groupingUsed="true"/>₫
                        </div>
                        <c:if test="${product.totalStock == 0}">
                            <div style="font-size:0.9rem; color:#888; margin-top:0.5rem;">Hết hàng</div>
                        </c:if>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<jsp:include page="/views/common/footer.jsp"/>

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
        document.querySelectorAll('.wishlist-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const productId = this.getAttribute('data-id');
                const currentBtn = this;
                fetch('${pageContext.request.contextPath}/api/toggle-like', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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
                            setTimeout(() => { window.location.href = '${pageContext.request.contextPath}/login'; }, 1500);
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
                    throw new Error(txt || 'Lỗi khi thêm vào giỏ');
                }
                return res.json().catch(() => null);
            }).then(json => {
                if (json && json.count !== undefined) {
                    const el = document.getElementById('cartCount');
                    if (el) el.textContent = json.count;
                }
                showToast('Đã thêm vào giỏ hàng');
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
