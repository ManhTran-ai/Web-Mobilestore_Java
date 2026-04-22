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
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem; }
        .card { border: 1px solid #e5e5ea; border-radius: 12px; padding: 1rem; background: #fff; }
        .card img { width: 100%; height: 160px; object-fit: contain; display: block; margin-bottom: 0.5rem; }
        .card .name { font-weight: 600; margin-bottom: 0.25rem; }
        .card .manufacturer { color: #666; font-size: 0.9rem; margin-bottom: 0.5rem; }
        .pagination { display: flex; justify-content: center; gap: 0.5rem; margin: 1.5rem 0; }
        .current-price { font-size: 1.1rem; font-weight: 700; color: #1a1a1a; }
        .current-price.sale { color: #ff3b30; }
        .discount-tag { background: #000; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 0.9rem; font-weight: 600; }
        .old-price { font-size: 1.2rem; color: #86868b; text-decoration: line-through; }
        .btn { display: inline-block; padding: 0.5rem 0.75rem; border-radius: 8px; background: #000 !important; color: #fff !important; text-decoration: none; }
        .btn.secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn.add-to-cart-btn { background: #000 !important; color: #e5e5ea !important; }
        .variant-selector { margin: 4px 0; }
        .variant-selector select { width: 100%; padding: 4px; border: 1px solid #e5e5ea; border-radius: 6px; font-size: 0.85rem; }
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
        @media (max-width: 768px) { .container { padding: 0 12px; } }
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

<main class="container">
    <div class="page-title"><h1>Danh sách sản phẩm</h1></div>

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
            <div style="display:flex; align-items:center; gap:10px; min-width: 180px; padding: 0.5rem 0.75rem; border: 1px solid #e5e5ea; border-radius: 8px; background: #fff;">
                <input id="favoritesOnly" type="checkbox" name="favorites" value="1" ${favoritesOnly ? 'checked' : ''} style="width: 18px; height: 18px;">
                <label for="favoritesOnly" style="font-size: 0.95rem; color:#1a1a1a; cursor:pointer; user-select:none;">Chỉ xem yêu thích</label>
            </div>
            <div style="display: flex; gap: 0.5rem;">
                <button type="submit" class="btn" style="padding: 0.75rem 1.5rem;">Tìm kiếm</button>
                <a href="${pageContext.request.contextPath}/products" class="btn secondary" style="padding: 0.75rem 1.5rem; text-decoration: none;">Xóa bộ lọc</a>
            </div>
        </form>
    </div>

    <c:if test="${favoritesOnly and favoritesRequiresLogin}">
        <div style="margin-bottom: 1rem; color: #666; font-size: 0.9rem;">
            Vui lòng <a href="${pageContext.request.contextPath}/login" style="color:#000; font-weight:600;">đăng nhập</a> để xem sản phẩm yêu thích.
        </div>
    </c:if>

    <c:if test="${favoritesOnly or not empty searchKeyword or not empty selectedCategory}">
        <div style="margin-bottom: 1rem; color: #666; font-size: 0.9rem;">
            <c:if test="${favoritesOnly}">Bộ lọc: <strong>Yêu thích</strong> | </c:if>
            <c:if test="${not empty searchKeyword}">Kết quả tìm kiếm cho: "<strong>${searchKeyword}</strong>"</c:if>
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
                            <div style="height:160px; display:flex; align-items:center; justify-content:center; color:#888;">📱</div>
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
                    <div style="color:#888; font-size:0.9rem;">
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
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage - 1}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}${favoritesOnly ? '&favorites=1' : ''}">« Trước</a>
            </c:if>
            <c:forEach var="p" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${p == currentPage}">
                        <span class="btn secondary">${p}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/products?page=${p}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}${favoritesOnly ? '&favorites=1' : ''}">${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage + 1}${not empty searchKeyword ? '&search=' : ''}${searchKeyword}${not empty selectedCategory ? '&category=' : ''}${selectedCategory}${favoritesOnly ? '&favorites=1' : ''}">Tiếp »</a>
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
