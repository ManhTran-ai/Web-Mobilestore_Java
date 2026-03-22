<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Mobile Store</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial;
            background: #fff;
            color: #1a1a1a;
        }

        .container {
            max-width: 976px;
            margin: 0 auto;
            padding: 0 24px;
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

        .product-detail {
            padding: 2rem 0;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: start;
        }

        .product-image {
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 2rem;
            background: #fff;
            text-align: center;
        }

        .product-image img {
            max-width: 100%;
            height: 400px;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }

        .product-image .no-image {
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 4rem;
        }

        .product-info {
            padding-top: 1rem;
        }

        .product-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
        }

        .product-manufacturer {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 1rem;
        }

        .product-condition {
            display: inline-block;
            background: #e5e5ea;
            color: #1a1a1a;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
        }


        .product-stock {
            font-size: 1rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .product-stock.in-stock {
            color: #28a745;
        }

        .product-stock.out-of-stock {
            color: #dc3545;
        }

        .product-description {
            background: #f8f9fa;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .product-description h3 {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #1a1a1a;
        }

        .product-description p {
            line-height: 1.6;
            color: #333;
        }

        .actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            background: #000000;
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.2s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn:hover {
            opacity: 0.8;
        }

        .btn.secondary {
            background: #e5e5ea;
            color: #1a1a1a;
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            opacity: 1;
        }
        .btn.add-to-cart-btn {
            background: #000000;
            color: #e5e5ea;
        }


        @media (max-width: 768px) {
            .container {
                padding: 0 12px;
            }

            .product-detail {
                grid-template-columns: 1fr;
                gap: 2rem;
            }

            .product-title {
                font-size: 1.5rem;
            }


            .actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                text-align: center;
            }

            .related-grid {
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
                gap: 0.75rem;
            }

            .related-card {
                padding: 0.5rem;
            }

            .related-card img {
                height: 80px;
                margin-bottom: 0.25rem;
            }

            .related-card .name {
                font-size: 0.75rem;
            }

            .related-card .manufacturer {
                font-size: 0.65rem;
                margin-bottom: 0.25rem;
            }

            .related-card .price {
                font-size: 0.75rem;
            }
        }

        .related-products {
            margin-top: 4rem;
            padding-top: 2rem;
            border-top: 1px solid #e5e5ea;
        }

        .related-products h2 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #1a1a1a;
        }

        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 1rem;
        }

        .related-card {
            border: 1px solid #e5e5ea;
            border-radius: 8px;
            padding: 0.75rem;
            background: #fff;
            transition: box-shadow 0.2s;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .related-card:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .related-card img {
            width: 100%;
            height: 90px;
            object-fit: contain;
            display: block;
            margin-bottom: 0.5rem;
        }

        .related-card .name {
            font-weight: 600;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
            line-height: 1.3;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .related-card .manufacturer {
            color: #666;
            font-size: 0.7rem;
            margin-bottom: 0.5rem;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .related-card .price {
            font-weight: 600;
            color: #000;
            font-size: 0.8rem;
        }

        .price-wrapper {
            margin-bottom: 1.5rem;
            padding: 1rem 0;
            border-top: 1px solid #f5f5f7;
            border-bottom: 1px solid #f5f5f7;
        }

        .product-price-new {
            font-size: 2.5rem;
            font-weight: 700;
            color: #000;
            display: block;
            line-height: 1;
        }

        .price-old-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
        }

        .product-price-old {
            font-size: 1.2rem;
            color: #86868b;
            text-decoration: line-through;
        }

        .old-price{
            color: #86868b;
            text-decoration: line-through;
        }

        .discount-tag {
            background: #000;
            color: #fff;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .save-amount {
            font-size: 0.95rem;
            color: #1d1d1f;
            margin-top: 8px;
            font-style: italic;
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
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang
                                Quản Lý</a>
                        </c:if>
                        <span style="color:#ccc;">Xin chào, ${sessionScope.user.username}</span>
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

<main class="container">
    <div class="product-detail">
        <div class="product-image">
            <c:choose>
                <c:when test="${not empty product.image}">
                    <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}">
                </c:when>
                <c:otherwise>
                    <div class="no-image">📱</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="product-info">
            <h1 class="product-title">${product.productName}</h1>
            <div class="product-manufacturer">${product.manufacturer}</div>
            <div class="product-condition">${product.productCondition}</div>
            <div class="price-wrapper">
                <c:choose>
                    <c:when test="${product.discount > 0}">
            <span class="product-price-new">
                <fmt:formatNumber value="${product.price * (100 - product.discount) / 100}" type="number" groupingUsed="true"/>₫
            </span>

                        <div class="price-old-group">
                <span class="product-price-old">
                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
                </span>
                            <span class="discount-tag">Giảm ${product.discount}%</span>
                        </div>

                        <div class="save-amount">
                            (Tiết kiệm: <fmt:formatNumber value="${product.price * product.discount / 100}" type="number"/>₫)
                        </div>
                    </c:when>
                    <c:otherwise>
            <span class="product-price-new" style="color: #1d1d1f;">
                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
            </span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="product-stock ${product.quantityInStock > 0 ? 'in-stock' : 'out-of-stock'}">
                <c:choose>
                    <c:when test="${product.quantityInStock == 0}">Hết hàng</c:when>
                    <c:otherwise>Còn lại: ${product.quantityInStock} sản phẩm</c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty product.productInfo}">
                <div class="product-description">
                    <h3>Mô tả sản phẩm</h3>
                    <p>${product.productInfo}</p>
                </div>
            </c:if>

            <div class="actions">
                <button class="btn add-to-cart-btn"
                        data-id="${product.productId}"
                        data-stock="${product.quantityInStock}"
                        ${product.quantityInStock == 0 ? 'disabled' : ''}>
                    <c:choose>
                        <c:when test="${product.quantityInStock == 0}">Hết hàng</c:when>
                        <c:otherwise>Thêm vào giỏ hàng</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/products" class="btn secondary">Xem thêm sản phẩm</a>
            </div>
        </div>
    </div>

    <c:if test="${not empty relatedProducts}">
        <div class="related-products">
            <h2>Sản phẩm liên quan</h2>
            <div class="related-grid">
                <c:forEach var="relatedProduct" items="${relatedProducts}">
                    <a href="${pageContext.request.contextPath}/products/view?id=${relatedProduct.productId}"
                       class="related-card">
                        <c:choose>
                            <c:when test="${not empty relatedProduct.image}">
                                <img src="${pageContext.request.contextPath}/${relatedProduct.image}"
                                     alt="${relatedProduct.productName}">
                            </c:when>
                            <c:otherwise>
                                <div style="height:120px; display:flex; align-items:center; justify-content:center; color:#888; font-size:2rem;">
                                    📱
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="name">${relatedProduct.productName}</div>
                        <div class="manufacturer">${relatedProduct.manufacturer}</div>
                        <div class="product-info-price">
                            <c:choose>
                                <c:when test="${relatedProduct.discount > 0}">
                                    <div class="current-price">
                                        <fmt:formatNumber value="${relatedProduct.price * (100 - relatedProduct.discount) / 100}" type="number"/>₫
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 8px; margin-top: 2px;">
                <span class="old-price">
                    <fmt:formatNumber value="${relatedProduct.price}" type="number"/>₫
                </span>
                                        <span class="discount-tag">-${relatedProduct.discount}%</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="current-price">
                                        <fmt:formatNumber value="${relatedProduct.price}" type="number"/>₫
                                    </div>
                                    <div style="height: 21px;"></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>
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
                <div class="mt-3">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Chính sách hỗ trợ</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="policy.jsp?type=warranty" class="text-secondary text-decoration-none">Chính sách bảo hành</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=return" class="text-secondary text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=shipping" class="text-secondary text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=privacy" class="text-secondary text-decoration-none">Bảo mật thông tin</a></li>
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

<script>
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
                    const elh = document.getElementById('cartCountHeader');
                    if (el) el.textContent = json.count;
                    if (elh) elh.textContent = json.count;
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
