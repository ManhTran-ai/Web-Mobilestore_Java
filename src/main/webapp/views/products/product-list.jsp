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

        .page-title {
            padding: 2rem 0;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.25rem;
        }

        .card {
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1rem;
            background: #fff;
        }

        .card img {
            width: 100%;
            height: 160px;
            object-fit: contain;
            display: block;
            margin-bottom: 0.5rem;
        }

        .card .name {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .card .manufacturer {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .price {
            font-weight: 700;
            color: #000000;
            margin-bottom: 0.5rem;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin: 1.5rem 0;
        }

        .btn {
            display: inline-block;
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            background: #000000;
            color: #fff;
            text-decoration: none;
        }

        .btn.secondary {
            background: #e5e5ea;
            color: #1a1a1a;
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 12px;
            }
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
    <div class="page-title">
        <h1>Danh sách sản phẩm</h1>
    </div>

    <div style="margin-bottom: 2rem; padding: 1.5rem; background: #f8f9fa; border-radius: 12px;">
        <form method="GET" action="${pageContext.request.contextPath}/products" style="display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 200px;">
                <input type="text" name="search" value="${searchKeyword}"
                       placeholder="Tìm kiếm sản phẩm..."
                       style="width: 100%; padding: 0.75rem; border: 1px solid #e5e5ea; border-radius: 8px; font-size: 0.95rem;">
            </div>
            <div style="min-width: 150px;">
                <select name="category" style="width: 100%; padding: 0.75rem; border: 1px solid #e5e5ea; border-radius: 8px; font-size: 0.95rem;">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${selectedCategory == category.categoryId ? 'selected' : ''}>
                            ${category.categoryName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div style="display: flex; gap: 0.5rem;">
                <button type="submit" class="btn" style="padding: 0.75rem 1.5rem;">Tìm kiếm</button>
                <a href="${pageContext.request.contextPath}/products" class="btn secondary" style="padding: 0.75rem 1.5rem; text-decoration: none;">Xóa bộ lọc</a>
            </div>
        </form>
    </div>

    <c:if test="${not empty searchKeyword or not empty selectedCategory}">
        <div style="margin-bottom: 1rem; color: #666; font-size: 0.9rem;">
            <c:if test="${not empty searchKeyword}">
                Kết quả tìm kiếm cho: "<strong>${searchKeyword}</strong>"
            </c:if>
            <c:if test="${not empty selectedCategory and not empty searchKeyword}"> | </c:if>
            <c:if test="${not empty selectedCategory}">
                Danh mục: <strong>
                    <c:forEach var="category" items="${categories}">
                        <c:if test="${category.categoryId == selectedCategory}">${category.categoryName}</c:if>
                    </c:forEach>
                </strong>
            </c:if>
            - Tìm thấy <strong>${totalItems}</strong> sản phẩm
        </div>
    </c:if>

    <div class="grid">
        <c:forEach var="product" items="${products}">
            <div class="card">
                <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}"
                   style="text-decoration:none; color:inherit;">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <div style="height:160px; display:flex; align-items:center; justify-content:center; color:#888;">
                                📱
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="name">${product.productName}</div>
                    <div class="manufacturer">${product.manufacturer}</div>
                    <div class="price"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>₫
                    </div>
                    <div style="color:#888; font-size:0.9rem;">
                        <c:choose>
                            <c:when test="${product.quantityInStock == 0}">Hết hàng</c:when>
                            <c:otherwise>Tồn kho: ${product.quantityInStock}</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="margin-top:8px;">
                        <button class="btn add-to-cart-btn" data-id="${product.productId}"
                                data-stock="${product.quantityInStock}">Thêm vào giỏ
                        </button>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage - 1}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}">« Trước</a>
            </c:if>
            <c:forEach var="p" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${p == currentPage}">
                        <span class="btn secondary">${p}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/products?page=${p}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}">${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage + 1}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}">Tiếp »</a>
            </c:if>
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


