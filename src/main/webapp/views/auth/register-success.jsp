<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành công – MobileStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-layout.css">
    <style>
        .page {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4rem 0;
        }

        .success-card {
            background: #ffffff;
            padding: 3rem 2.5rem;
            border-radius: 12px;
            border: 1px solid #e5e5e5;
            text-align: center;
            max-width: 440px;
            width: 100%;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-icon {
            width: 80px;
            height: 80px;
            background: #dcfce7;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
            animation: scaleIn 0.4s ease-out 0.2s both;
        }

        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }

        .success-icon svg {
            width: 40px;
            height: 40px;
            color: #16a34a;
        }

        h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: #666;
            font-size: 1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .account-info {
            background: #f8f8f8;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 2rem;
            text-align: left;
        }

        .account-info .row {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            font-size: 0.95rem;
        }

        .account-info .row:not(:last-child) {
            border-bottom: 1px solid #e5e5e5;
        }

        .account-info .label {
            color: #888;
        }

        .account-info .value {
            color: #1a1a1a;
            font-weight: 600;
        }

        .btn-primary {
            display: block;
            width: 100%;
            padding: 14px 16px;
            background: #1a1a1a !important;
            color: #ffffff !important;
            text-align: center;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.2s;
            text-decoration: none;
            margin-bottom: 0.75rem;
        }

        .btn-primary:hover {
            background: #333 !important;
            transform: translateY(-1px);
        }

        .btn-secondary {
            display: block;
            width: 100%;
            padding: 12px 16px;
            background: #ffffff !important;
            color: #1a1a1a !important;
            text-align: center;
            border: 1px solid #e5e5e5 !important;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background-color 0.2s;
            text-decoration: none;
        }

        .btn-secondary:hover {
            background: #f5f5f5 !important;
        }

        .redirect-note {
            margin-top: 1.5rem;
            font-size: 0.85rem;
            color: #999;
        }

        .spinner {
            width: 20px;
            height: 20px;
            border: 2px solid #ffffff;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            display: inline-block;
            margin-right: 8px;
            vertical-align: middle;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<c:set var="activePage" value="register-success" scope="request"/>
<body>
<jsp:include page="/views/common/header.jsp"/>

<section class="page">
    <div class="success-card">
        <div class="success-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
            </svg>
        </div>

        <h1>Đăng ký thành công!</h1>
        <p class="subtitle">
            Tài khoản của bạn đã được tạo và đăng nhập tự động.
        </p>

        <div class="account-info">
            <div class="row">
                <span class="label">Tên đăng nhập</span>
                <span class="value">${sessionScope.user.username}</span>
            </div>
            <div class="row">
                <span class="label">Email</span>
                <span class="value">${sessionScope.user.email}</span>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/" class="btn-primary">
            Khám phá sản phẩm ngay
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="btn-secondary">
            Cập nhật hồ sơ
        </a>

        <p class="redirect-note">
            Đang chuyển hướng tự động trong <span id="countdown">3</span>s...
        </p>
    </div>
</section>

<jsp:include page="/views/common/footer.jsp"/>

<script>
    let seconds = 3;
    const countdownEl = document.getElementById('countdown');

    const interval = setInterval(() => {
        seconds--;
        countdownEl.textContent = seconds;
        if (seconds <= 0) {
            clearInterval(interval);
            window.location.href = '${pageContext.request.contextPath}/';
        }
    }, 1000);

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
