<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập bằng Email – MobileStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #ffffff;
        }

        .header {
            background: #1a1a1a;
            height: 72px;
            padding: 0;
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

        .nav a:hover { opacity: 0.7; }

        .page {
            padding: 4rem 0;
            min-height: calc(100vh - 200px);
        }

        .center {
            max-width: 420px;
            margin: 0 auto;
        }

        .card {
            background: #ffffff;
            padding: 3rem 2.5rem;
            border-radius: 12px;
            border: 1px solid #e5e5e5;
        }

        h2 {
            margin-bottom: 0.5rem;
            text-align: center;
            color: #1a1a1a;
            font-size: 1.75rem;
            font-weight: 600;
            letter-spacing: -0.5px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }

        .field {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #1a1a1a;
            font-weight: 500;
            font-size: 0.95rem;
        }

        input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 0.95rem;
            color: #1a1a1a;
            background: #ffffff;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #1a1a1a;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 14px 16px;
            background: #1a1a1a !important;
            color: #ffffff !important;
            text-align: center;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.2s;
        }

        .btn:hover {
            background: #333 !important;
            transform: translateY(-1px);
        }

        .btn:disabled {
            background: #999 !important;
            cursor: not-allowed;
            transform: none;
        }

        .error {
            color: #b91c1c;
            margin-bottom: 1rem;
            background: #fef2f2;
            border: 1px solid #fecaca;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: #5f6368;
            font-size: 0.85rem;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: #dadce0;
        }

        .divider span { padding: 0 1rem; }

        .helper {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.9rem;
            color: #666;
        }

        .helper a {
            color: #1a1a1a;
            text-decoration: none;
            font-weight: 500;
        }

        .helper a:hover { text-decoration: underline; }

        .email-otp-icon {
            text-align: center;
            margin-bottom: 1rem;
            color: #1a1a1a;
        }

        .email-otp-icon svg {
            width: 48px;
            height: 48px;
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
                <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang Quản Lý</a>
                        </c:if>
                        <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                            <span>${sessionScope.user.username}</span>
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

<section class="page">
    <div class="container">
        <div class="center">
            <div class="card">
                <div class="email-otp-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                    </svg>
                </div>
                <h2>Đăng nhập bằng Email</h2>
                <p class="subtitle">Nhập email để nhận mã xác nhận</p>

                <c:if test="${not empty errorMessage}">
                    <div class="error">${errorMessage}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/send-otp" novalidate>
                    <div class="field">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email"
                               placeholder="example@email.com"
                               required autocomplete="email">
                    </div>
                    <button type="submit" class="btn">Gửi mã xác nhận</button>
                </form>

                <div class="divider"><span>hoặc</span></div>

                <div class="helper">
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập bằng mật khẩu</a>
                </div>
                <div class="helper">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>
                <div class="helper">
                    <a href="${pageContext.request.contextPath}/">Quay về trang chủ</a>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    function refreshCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(r => r.json())
            .then(data => {
                const el = document.getElementById('cartCount');
                if (el) el.textContent = data.count;
            }).catch(() => {});
    }
    refreshCartCount();
</script>
</body>
</html>
