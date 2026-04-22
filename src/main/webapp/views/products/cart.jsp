<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; background: #fff; color: #1a1a1a; }

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
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left }
        th { font-weight: 600 }
        .qty-controls { display: flex; gap: 8px; align-items: center }
        .qty-input { width: 60px; padding: 8px; border: 1px solid #e5e5ea; border-radius: 6px; text-align: center; font-size: 14px; }
        .qty-input:focus { outline: none; border-color: #0071e3; }
        .btn { padding: 8px 12px; border-radius: 6px; background: #111 !important; color: #fff !important; text-decoration: none; border: none; cursor: pointer; transition: opacity 0.2s }
        .btn:hover { opacity: 0.8 }
        .btn.secondary { background: #e5e5ea !important; color: #111 !important; }
        .btn.danger { background: #dc3545; color: #fff }
        .btn.danger:hover { background: #c82333 }
        .right { text-align: right }
        .cart-item-image { height: 60px; vertical-align: middle; margin-right: 8px; border-radius: 4px; object-fit: contain }
        .empty-cart { text-align: center; padding: 4rem 2rem }
        .empty-cart-icon { font-size: 4rem; margin-bottom: 1rem }
        .empty-cart h2 { font-size: 1.5rem; margin-bottom: 0.5rem; color: #1a1a1a }
        .empty-cart p { color: #666; margin-bottom: 1.5rem }
        @media (max-width: 768px) {
            .container { padding: 0 12px; }
            main.container { padding-top: 80px; }
            table { font-size: 14px; }
            th, td { padding: 8px 4px; }
            .qty-controls { flex-direction: column; gap: 4px; }
            .btn { padding: 6px 10px; font-size: 14px; }
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
                <a href="${pageContext.request.contextPath}/products">Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart" style="color:#fff; font-weight:600;">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang Quản Lý</a>
                        </c:if>
                        <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                            <span class="user-avatar">&#128100;</span>
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

<main class="container" style="padding-top: 100px;">
    <div style="padding: 2rem 0;">
        <h1>Giỏ Hàng Của Bạn</h1>
        <c:choose>
        <c:when test="${empty cartItems}">
        <div class="empty-cart">
            <div class="empty-cart-icon">&#128722;</div>
            <h2>Giỏ hàng trống</h2>
            <p>Không có sản phẩm nào trong giỏ hàng của bạn.</p>
            <a class="btn" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a>
        </div>
        </c:when>
        <c:otherwise>
        <table>
            <thead>
            <tr>
                <th>Sản Phẩm</th>
                <th>Phiên bản</th>
                <th>Giá</th>
                <th>Số Lượng</th>
                <th>Thành Tiền</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:set var="total" value="0"/>
            <c:forEach var="item" items="${cartItems}" varStatus="st">
                <c:set var="itemPrice" value="${item.variant != null ? item.variant.price : item.product.displayPrice}"/>
                <c:set var="itemDiscount" value="${item.product != null ? item.product.discount : 0}"/>
                <c:set var="itemTotal" value="${(itemPrice * (100 - itemDiscount) / 100) * item.quantity}"/>
                <tr data-index="${st.index}">
                    <td>
                        <img src="${pageContext.request.contextPath}/${item.variant != null ? item.variant.variantImage : item.product.displayImage}"
                             alt="${item.product.productName}" class="cart-item-image"
                             onerror="this.style.display='none'">
                        <span>${item.product.productName}</span><br>
                        <small style="color:#666;">${item.product.manufacturer}</small>
                    </td>
                    <td>
                        <c:if test="${item.variant != null}">
                            <small>${item.variant.color} / ${item.variant.storage}</small>
                        </c:if>
                    </td>
                    <td class="unit-price"><fmt:formatNumber value="${itemPrice}" type="number" groupingUsed="true"/>₫
                    </td>
                    <td>
                        <div class="qty-controls">
                            <input type="number" name="quantity" value="${item.quantity}" min="1"
                                   max="${item.variant != null ? item.variant.quantityInStock : item.product.totalStock}"
                                   class="qty-input" data-index="${st.index}"
                                   data-stock="${item.variant != null ? item.variant.quantityInStock : item.product.totalStock}">
                            <button type="button" class="btn" onclick="updateQuantity(this)">Cập nhật</button>
                        </div>
                    </td>
                    <td class="right item-total"><fmt:formatNumber value="${itemTotal}" type="number" groupingUsed="true"/>₫
                    </td>
                    <td>
                        <button type="button" class="btn danger" onclick="removeItem(this)">Xóa</button>
                    </td>
                </tr>
                <c:set var="total" value="${total + itemTotal}"/>
            </c:forEach>
            </tbody>
        </table>

        <div style="margin-top:20px;padding:20px;background:#f8f8f8;border-radius:8px;">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                <span style="font-size:1.2rem;font-weight:600;">Tạm tính:</span>
                <span style="font-size:1.4rem;font-weight:700;color:#0071e3;">
                            <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫
                        </span>
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;">
                <button type="button" class="btn danger" onclick="clearCart()">Xóa tất cả</button>
                <a class="btn secondary" href="${pageContext.request.contextPath}/products">Tiếp Tục Mua Sắm</a>
                <a class="btn" href="${pageContext.request.contextPath}/checkout">Thanh Toán</a>
            </div>
        </div>
        </c:otherwise>
        </c:choose>
</main>

<footer class="text-light pt-5 pb-3 mt-5" style="background-color: #000000;">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Mobile Store</h5>
                <p><i class="fas fa-map-marker-alt me-2"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
                <p><i class="fas fa-phone-alt me-2"></i> Hotline: 1800.1234</p>
                <p><i class="fas fa-envelope me-2"></i> support@mobilestore.com</p>
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
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var el = document.getElementById('cartCount');
                if (el) el.textContent = data.count;
            }).catch(function() {});
    }

    function showToast(message, isSuccess) {
        var t = document.getElementById('toastMessage');
        if (!t) {
            t = document.createElement('div');
            t.id = 'toastMessage';
            t.style.position = 'fixed';
            t.style.right = '16px';
            t.style.bottom = '16px';
            t.style.padding = '12px 20px';
            t.style.borderRadius = '8px';
            t.style.zIndex = 9999;
            t.style.fontSize = '14px';
            document.body.appendChild(t);
        }
        t.textContent = message;
        t.style.background = isSuccess ? '#28a745' : '#dc3545';
        t.style.color = '#fff';
        t.style.opacity = '1';
        setTimeout(function() { t.style.opacity = '0'; }, 2500);
    }

    function updateQuantity(btn) {
        var row = btn.closest('tr');
        var input = row.querySelector('.qty-input');
        var index = input.dataset.index;
        var quantity = parseInt(input.value);
        var stock = parseInt(input.dataset.stock);

        if (quantity < 1) {
            showToast('Số lượng phải lớn hơn 0', false);
            input.value = 1;
            return;
        }
        if (quantity > stock) {
            showToast('Số lượng vượt quá tồn kho (' + stock + ')', false);
            input.value = stock;
            return;
        }

        fetch('${pageContext.request.contextPath}/cart?action=update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin',
            body: 'index=' + index + '&quantity=' + quantity
        })
            .then(function(res) {
                if (!res.ok) throw new Error('Cập nhật thất bại');
                return res.json();
            })
            .then(function(json) {
                if (json.success) {
                    location.reload();
                } else {
                    showToast(json.message || 'Cập nhật thất bại', false);
                }
            })
            .catch(function(err) {
                console.error(err);
                showToast('Lỗi khi cập nhật', false);
            });
    }

    function removeItem(btn) {
        var row = btn.closest('tr');
        var input = row.querySelector('.qty-input');
        var index = input.dataset.index;

        if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/cart?action=remove', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin',
            body: 'index=' + index
        })
            .then(function(res) {
                if (!res.ok) throw new Error('Xóa thất bại');
                return res.json();
            })
            .then(function(json) {
                if (json.success) {
                    row.style.transition = 'opacity 0.3s';
                    row.style.opacity = '0';
                    setTimeout(function() { location.reload(); }, 300);
                } else {
                    showToast(json.message || 'Xóa thất bại', false);
                }
            })
            .catch(function(err) {
                console.error(err);
                showToast('Lỗi khi xóa', false);
            });
    }

    function clearCart() {
        if (!confirm('Bạn muốn xóa tất cả sản phẩm trong giỏ hàng?')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/cart?action=clear', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin',
            body: ''
        })
            .then(async function(res) {
                if (res.status === 401) {
                    var json = await res.json().catch(function() { return null; });
                    if (json && json.redirect) {
                        window.location.href = json.redirect;
                        return null;
                    }
                    throw new Error('Vui lòng đăng nhập để tiếp tục');
                }
                if (!res.ok) throw new Error('Xóa giỏ hàng thất bại');
                return res.json().catch(function() { return null; });
            })
            .then(function(json) {
                if (!json) return;
                if (json.success) {
                    location.reload();
                } else {
                    showToast(json.message || 'Xóa giỏ hàng thất bại', false);
                }
            })
            .catch(function(err) {
                console.error(err);
                showToast(err.message || 'Lỗi khi xóa giỏ hàng', false);
            });
    }

    document.querySelectorAll('.qty-input').forEach(function(input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                var btn = this.closest('.qty-controls').querySelector('.btn');
                updateQuantity(btn);
            }
        });
    });

    refreshCartCount();
</script>
</body>
</html>
