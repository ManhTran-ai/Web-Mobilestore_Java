<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Mobile Store</title>
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

        table{width:100%;border-collapse:collapse;margin-bottom:20px}
        th,td{padding:12px;border:1px solid #ddd;text-align:left}
        th{font-weight:600}
        .qty-controls {display:flex;gap:8px;align-items:center}
        .qty-input {
            width: 60px;
            padding: 8px;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            text-align: center;
            font-size: 14px;
        }
        .qty-input:focus {
            outline: none;
            border-color: #0071e3;
        }
        .btn{padding:8px 12px;border-radius:6px;background:#111;color:#fff;text-decoration:none;border:none;cursor:pointer;transition:opacity 0.2s}
        .btn:hover{opacity:0.8}
        .btn.secondary{background:#e5e5ea;color:#111}
        .btn.danger{background:#dc3545;color:#fff}
        .btn.danger:hover{background:#c82333}
        .btn-update{padding:6px 10px;font-size:13px}
        .btn-remove{padding:6px 10px;font-size:13px}
        .right{text-align:right}
        .cart-item-image{height:60px;vertical-align:middle;margin-right:8px;border-radius:4px;object-fit:contain}
        .empty-cart{text-align:center;padding:4rem 2rem}
        .empty-cart-icon{font-size:4rem;margin-bottom:1rem}
        .empty-cart h2{font-size:1.5rem;margin-bottom:0.5rem;color:#1a1a1a}
        .empty-cart p{color:#666;margin-bottom:1.5rem}

        @media (max-width: 768px) {
            .container {
                padding: 0 12px;
            }

            main.container {
                padding-top: 80px;
            }

            table {
                font-size: 14px;
            }

            th, td {
                padding: 8px 4px;
            }

            .qty-controls {
                flex-direction: column;
                gap: 4px;
            }

            .btn {
                padding: 6px 10px;
                font-size: 14px;
            }

            .container > div:last-child {
                padding: 16px;
            }

            .container > div:last-child > div:first-child {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
                margin-bottom: 12px;
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
                <a href="${pageContext.request.contextPath}/products">Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart" style="color:#fff; font-weight:600;">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang Quản Lý</a>
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

    <main class="container" style="padding-top: 100px;">
        <div style="padding: 2rem 0;">
            <h1>Giỏ Hàng Của Bạn</h1>
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
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
                            <th>Giá</th>
                            <th>Số Lượng</th>
                            <th>Thành Tiền</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="total" value="0" />
                        <c:forEach var="item" items="${cartItems}" varStatus="st">
                            <tr data-index="${st.index}">
                                <td>
                                    <img src="${pageContext.request.contextPath}/${item.product.image}" alt="${item.product.productName}" class="cart-item-image" onerror="this.style.display='none'">
                                    <span>${item.product.productName}</span><br>
                                    <small style="color:#666;">${item.product.manufacturer}</small>
                                </td>
                                <td class="unit-price"><fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/>₫</td>
                                <td>
                                    <div class="qty-controls">
                                        <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.quantityInStock}" class="qty-input" data-index="${st.index}" data-stock="${item.product.quantityInStock}">
                                        <button type="button" class="btn btn-update" onclick="updateQuantity(this)">Cập nhật</button>
                                    </div>
                                </td>
                                <td class="right item-total"><fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/>₫</td>
                                <td>
                                    <button type="button" class="btn secondary btn-remove" onclick="removeItem(this)">Xóa</button>
                                </td>
                            </tr>
                            <c:set var="total" value="${total + (item.product.price * item.quantity)}" />
                        </c:forEach>
                    </tbody>
                </table>

                <div class="cart-summary" style="margin-top:20px;padding:20px;background:#f8f8f8;border-radius:8px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <span style="font-size:1.2rem;font-weight:600;">Tạm tính:</span>
                        <span class="total-amount" style="font-size:1.4rem;font-weight:700;color:#0071e3;">
                            <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫
                        </span>
                    </div>
                    <div style="display:flex;gap:12px;justify-content:flex-end;">
                        <a class="btn secondary" href="${pageContext.request.contextPath}/products">Tiếp Tục Mua Sắm</a>
                        <a class="btn" href="${pageContext.request.contextPath}/checkout">Thanh Toán</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <script>
        function refreshCartCount() {
            fetch('${pageContext.request.contextPath}/cart/count')
                .then(r => r.json())
                .then(data => {
                    const el = document.getElementById('cartCount');
                    if (el) el.textContent = data.count;
                }).catch(() => {});
        }

        function showToast(message, isSuccess = true) {
            let t = document.getElementById('toastMessage');
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
            setTimeout(() => {
                t.style.opacity = '0';
            }, 2500);
        }

        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(num);
        }

        function updateQuantity(btn) {
            const row = btn.closest('tr');
            const input = row.querySelector('.qty-input');
            const index = input.dataset.index;
            const quantity = parseInt(input.value);
            const stock = parseInt(input.dataset.stock);

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
            .then(res => {
                if (!res.ok) throw new Error('Cập nhật thất bại');
                return res.json();
            })
            .then(json => {
                if (json.success) {
                    location.reload();
                } else {
                    showToast(json.message || 'Cập nhật thất bại', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Lỗi khi cập nhật', false);
            });
        }

        function removeItem(btn) {
            const row = btn.closest('tr');
            const input = row.querySelector('.qty-input');
            const index = input.dataset.index;
            
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
            .then(res => {
                if (!res.ok) throw new Error('Xóa thất bại');
                return res.json();
            })
            .then(json => {
                if (json.success) {
                    const row = document.querySelector(`tr[data-index="${index}"]`);
                    row.style.transition = 'opacity 0.3s';
                    row.style.opacity = '0';
                    setTimeout(() => {
                        location.reload();
                    }, 300);
                } else {
                    showToast(json.message || 'Xóa thất bại', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Lỗi khi xóa', false);
            });
        }

        document.querySelectorAll('.qty-input').forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const btn = this.closest('.qty-controls').querySelector('.btn-update');
                    updateQuantity(btn);
                }
            });
        });

        refreshCartCount();
    </script>
</body>
</html>