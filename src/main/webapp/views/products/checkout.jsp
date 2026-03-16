<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Mobile Store</title>
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
            margin: 2rem auto;
            padding: 0 16px;
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
            max-width: 976px;
            margin: 0 auto;
            padding: 0 24px;
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

        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
            align-items: start;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.25rem;
            color: #1a1a1a;
        }

        .form-card {
            background: #ffffff;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
            font-size: 0.95rem;
        }

        .form-label .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #0071e3;
            box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
        }

        .form-control.error {
            border-color: #dc3545;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 0.375rem;
            display: none;
        }

        .form-group.error .error-message {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .order-summary {
            background: #ffffff;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1.5rem;
            position: sticky;
            top: 100px;
        }

        .order-summary-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e5ea;
        }

        .order-item {
            display: flex;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item:last-of-type {
            border-bottom: none;
        }

        .order-item-image {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border-radius: 8px;
            background: #f5f5f7;
            flex-shrink: 0;
        }

        .order-item-info {
            flex: 1;
            min-width: 0;
        }

        .order-item-name {
            font-weight: 500;
            font-size: 0.9rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .order-item-qty {
            font-size: 0.85rem;
            color: #666;
        }

        .order-item-price {
            font-weight: 600;
            font-size: 0.9rem;
            text-align: right;
            flex-shrink: 0;
        }

        .order-totals {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e5ea;
        }

        .order-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .order-total-row.final {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e5ea;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .order-total-row .amount {
            color: #0071e3;
            font-size: 1.5rem;
        }

        .right { text-align: right; }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            background: #111;
            color: #fff;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1rem;
            font-weight: 500;
            width: 100%;
            text-align: center;
            transition: opacity 0.2s;
        }

        .btn:hover { opacity: 0.9; }
        .btn-secondary { background: #e5e5ea; color: #1a1a1a; }
        .btn-vnpay { background: #0066cc; }

        .btn-group {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .btn-group .btn { flex: 1; }

        .back-link {
            display: inline-block;
            margin-bottom: 1.5rem;
            color: #666;
            text-decoration: none;
            font-size: 0.95rem;
        }

        .back-link:hover { color: #1a1a1a; }

        .empty-cart { text-align: center; padding: 4rem 2rem; }
        .empty-cart-icon { font-size: 4rem; margin-bottom: 1rem; }

        .payment-option {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            border: 2px solid #e5e5ea;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 0.75rem;
            transition: all 0.2s;
        }

        .payment-option:hover { border-color: #ccc; }
        .payment-option.selected {
            border-color: #0071e3;
            background: #f0f7ff;
        }

        .payment-option input { width: 18px; height: 18px; }

        .payment-option-content div:first-child { font-weight: 600; }
        .payment-option-content div:last-child { font-size: 0.85rem; color: #666; }

        @media (max-width: 768px) {
            .checkout-grid { grid-template-columns: 1fr; }
            .order-summary { position: static; }
            .form-row { grid-template-columns: 1fr; }
            .header-content { padding: 0 12px; }
            .nav { gap: 1rem; }
            .nav a { font-size: 0.9rem; }
            .container { padding: 0 12px; }
            main.container { padding-top: 80px; }
            table { font-size: 14px; }
            th, td { padding: 8px 4px; }
            .btn { padding: 10px 16px; font-size: 14px; }
            h1 { font-size: 1.5rem !important; }
        }
    </style>
</head>
<body>
<header class="header">
    <div class="header-content">
        <div class="logo">Mobile Store</div>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/products">Sản Phẩm</a>
            <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
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
</header>

<main class="container" style="padding-top: 100px;">
    <div style="padding: 2rem 0;">
        <a href="${pageContext.request.contextPath}/cart" class="back-link">← Quay lại giỏ hàng</a>
        <h1 style="font-size: 2rem; font-weight: 600; margin-bottom: 2rem;">Thanh toán</h1>

        <c:if test="${not empty error}">
            <div style="color:#c62828; background: #fdecea; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; border: 1px solid #f5c6cb;">
                <strong>❌ Lỗi:</strong> ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h2 style="font-size: 1.5rem; margin-bottom: 0.5rem;">Giỏ hàng trống</h2>
                    <p style="color: #666; margin-bottom: 1.5rem;">Không có sản phẩm nào để thanh toán.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/products" style="width: auto; display: inline-block;">Tiếp tục mua sắm</a>
                </div>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm" novalidate>
                    <div class="checkout-grid">
                        <div class="checkout-form">
                            <h2 class="section-title">Thông tin giao hàng</h2>
                            <div class="form-card">
                                <div class="form-group" id="receiverNameGroup">
                                    <label class="form-label" for="receiverName">
                                        Người nhận <span class="required">*</span>
                                    </label>
                                    <input type="text" id="receiverName" name="receiverName" class="form-control"
                                           required minlength="2" maxlength="100"
                                           placeholder="Nhập họ tên người nhận"
                                           value="${sessionScope.user != null ? sessionScope.user.username : ''}">
                                    <div class="error-message" id="receiverNameError">Vui lòng nhập tên người nhận</div>
                                </div>

                                <div class="form-group" id="phoneGroup">
                                    <label class="form-label" for="phone">
                                        Số điện thoại <span class="required">*</span>
                                    </label>
                                    <input type="tel" id="phone" name="phone" class="form-control"
                                           required pattern="[0-9]{10,11}"
                                           placeholder="Nhập số điện thoại"
                                           value="${sessionScope.user != null && sessionScope.user.customerPhone != null ? sessionScope.user.phone : ''}">
                                    <div class="error-message" id="phoneError">Vui lòng nhập số điện thoại hợp lệ</div>
                                </div>

                                <div class="form-group" id="emailGroup">
                                    <label class="form-label" for="email">
                                        Email <span class="required">*</span>
                                    </label>
                                    <input type="email" id="email" name="email" class="form-control"
                                           required
                                           placeholder="Nhập địa chỉ email"
                                           value="${sessionScope.user != null ? sessionScope.user.email : ''}">
                                    <div class="error-message" id="emailError">Vui lòng nhập email hợp lệ</div>
                                </div>

                                <div class="form-group" id="addressGroup">
                                    <label class="form-label" for="address">
                                        Địa chỉ nhận hàng <span class="required">*</span>
                                    </label>
                                    <textarea id="address" name="address" class="form-control"
                                              required minlength="10" maxlength="500"
                                              placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)"></textarea>
                                    <div class="error-message" id="addressError">Vui lòng nhập địa chỉ giao hàng</div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="note">
                                        Ghi chú đơn hàng
                                    </label>
                                    <textarea id="note" name="note" class="form-control"
                                              placeholder="Ghi chú thêm cho đơn hàng (không bắt buộc)"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="order-summary">
                            <h3 class="order-summary-title">Đơn hàng của bạn</h3>

                            <c:set var="total" value="0"/>
                            <c:forEach var="item" items="${cartItems}">
                                <div class="order-item">
                                    <img src="${pageContext.request.contextPath}/${item.product.image}"
                                         alt="${item.product.productName}"
                                         class="order-item-image"
                                         onerror="this.style.display='none'">
                                    <div class="order-item-info">
                                        <div class="order-item-name">${item.product.productName}</div>
                                        <div class="order-item-qty">SL: ${item.quantity}</div>
                                    </div>
                                    <div class="order-item-price">
                                        <fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/>₫
                                    </div>
                                </div>
                                <c:set var="total" value="${total + (item.product.price * item.quantity)}"/>
                            </c:forEach>

                            <div class="order-totals">
                                <div class="order-total-row">
                                    <span>Tạm tính:</span>
                                    <span><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫</span>
                                </div>
                                <div class="order-total-row">
                                    <span>Phí vận chuyển:</span>
                                    <span>Miễn phí</span>
                                </div>
                                <div class="order-total-row final">
                                    <span>Tổng cộng:</span>
                                    <span class="amount"><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫</span>
                                </div>
                            </div>

                            <div style="margin-top: 1.5rem;">
                                <label class="form-label" style="margin-bottom: 0.75rem;">Phương thức thanh toán</label>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn" name="action" value="cod">Thanh toán khi nhận hàng</button>
                                <button class="btn" type="button" onclick="payWithVNPay()" >Thanh toán qua VNPay</button>
                            </div>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
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
            }).catch(() => {});
    }

    function validateForm() {
        let isValid = true;

        const receiverName = document.getElementById('receiverName');
        const receiverNameGroup = document.getElementById('receiverNameGroup');
        if (!receiverName.value.trim() || receiverName.value.trim().length < 2) {
            receiverName.classList.add('error');
            receiverNameGroup.classList.add('error');
            isValid = false;
        } else {
            receiverName.classList.remove('error');
            receiverNameGroup.classList.remove('error');
        }

        const phone = document.getElementById('phone');
        const phoneGroup = document.getElementById('phoneGroup');
        const phoneRegex = /^[0-9]{10,11}$/;
        if (!phone.value.trim() || !phoneRegex.test(phone.value.trim())) {
            phone.classList.add('error');
            phoneGroup.classList.add('error');
            isValid = false;
        } else {
            phone.classList.remove('error');
            phoneGroup.classList.remove('error');
        }

        const email = document.getElementById('email');
        const emailGroup = document.getElementById('emailGroup');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim() || !emailRegex.test(email.value.trim())) {
            email.classList.add('error');
            emailGroup.classList.add('error');
            isValid = false;
        } else {
            email.classList.remove('error');
            emailGroup.classList.remove('error');
        }

        const address = document.getElementById('address');
        const addressGroup = document.getElementById('addressGroup');
        if (!address.value.trim() || address.value.trim().length < 10) {
            address.classList.add('error');
            addressGroup.classList.add('error');
            isValid = false;
        } else {
            address.classList.remove('error');
            addressGroup.classList.remove('error');
        }

        return isValid;
    }

    function payWithVNPay() {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/vnpay-payment';
        document.body.appendChild(form);
        form.submit();
    }

    document.querySelectorAll('.payment-option').forEach(option => {
        option.addEventListener('click', function() {
            document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
            this.classList.add('selected');
        });
    });

    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

        if (paymentMethod === 'COD') {
            if (!validateForm()) {
                e.preventDefault();
                const firstError = document.querySelector('.form-group.error');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        }
    });

    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('error');
            this.closest('.form-group').classList.remove('error');
        });
    });

    refreshCartCount();
</script>
</body>
</html>