<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập mã OTP – MobileStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; line-height: 1.6; color: #1a1a1a; background-color: #ffffff; }
        .header { background: #1a1a1a; height: 72px; padding: 0; }
        .container { max-width: 976px; margin: 0 auto; padding: 0 24px; }
        .header-content { display: flex; justify-content: space-between; align-items: center; height: 100%; }
        .logo { font-size: 1.5rem; font-weight: 600; color: #ffffff; letter-spacing: -0.5px; display: flex; align-items: center; height: 72px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #ffffff; text-decoration: none; font-size: 0.95rem; font-weight: 400; transition: opacity 0.2s; display: inline-flex; align-items: center; height: 72px; line-height: normal; }
        .nav a:hover { opacity: 0.7; }
        .page { padding: 4rem 0; min-height: calc(100vh - 200px); }
        .center { max-width: 420px; margin: 0 auto; }
        .card { background: #ffffff; padding: 3rem 2.5rem; border-radius: 12px; border: 1px solid #e5e5e5; }
        h2 { margin-bottom: 0.5rem; text-align: center; color: #1a1a1a; font-size: 1.75rem; font-weight: 600; letter-spacing: -0.5px; }
        .subtitle { text-align: center; color: #666; font-size: 0.95rem; margin-bottom: 2rem; }
        .subtitle strong { color: #1a1a1a; }
        .field { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 8px; color: #1a1a1a; font-weight: 500; font-size: 0.95rem; }
        input { width: 100%; padding: 14px 16px; border: 1px solid #e5e5e5; border-radius: 8px; font-size: 0.95rem; color: #1a1a1a; background: #ffffff; transition: border-color 0.2s; }
        input:focus { outline: none; border-color: #1a1a1a; }
        .btn { display: block; width: 100%; padding: 14px 16px; background: #1a1a1a !important; color: #ffffff !important; text-align: center; border: none; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: background-color 0.2s, transform 0.2s; }
        .btn:hover { background: #333 !important; transform: translateY(-1px); }
        .btn:disabled { background: #999 !important; cursor: not-allowed; transform: none; }
        .error { color: #b91c1c; margin-bottom: 1rem; background: #fef2f2; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
        .timer { text-align: center; color: #666; font-size: 0.9rem; margin-bottom: 1.5rem; }
        .timer .time-left { color: #1a1a1a; font-weight: 600; font-size: 1.1rem; }
        .timer.expired { color: #b91c1c; }
        .resend-section { text-align: center; font-size: 0.9rem; color: #666; margin-top: 1.5rem; }
        .resend-section a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .resend-section a:hover { text-decoration: underline; }
        .resend-section.hidden { display: none; }
        .helper { margin-top: 1.5rem; text-align: center; font-size: 0.9rem; color: #666; }
        .helper a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .helper a:hover { text-decoration: underline; }
        .otp-icon { text-align: center; margin-bottom: 1rem; color: #1a1a1a; }
        .otp-icon svg { width: 48px; height: 48px; }
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
                <div class="otp-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
                    </svg>
                </div>
                <h2>Nhập mã xác nhận</h2>
                <p class="subtitle">Mã OTP đã được gửi đến <strong>${sessionScope.otpEmail}</strong>. Mã có hiệu lực trong 5 phút.</p>
                <c:if test="${not empty errorMessage}">
                    <div class="error">${errorMessage}</div>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/verify-otp" novalidate>
                    <div class="field">
                        <label for="otpCode">Mã OTP (6 chữ số)</label>
                        <input type="text" id="otpCode" name="otpCode" maxlength="6" placeholder="______" pattern="[0-9]{6}" required autocomplete="one-time-code" style="letter-spacing: 8px; font-size: 24px; text-align: center;">
                    </div>
                    <div class="timer" id="timerContainer">Mã hết hạn sau: <span class="time-left" id="timerDisplay">05:00</span></div>
                    <button type="submit" class="btn" id="submitBtn">Xác nhận</button>
                </form>
                <div class="resend-section hidden" id="resendSection">Không nhận được mã? <a href="${pageContext.request.contextPath}/send-otp" id="resendLink">Gửi lại OTP</a></div>
                <div class="resend-section" id="countdownSection">Gửi lại sau <span id="countdownDisplay">60</span>s</div>
                <div class="helper"><a href="${pageContext.request.contextPath}/send-otp">Nhập sai email? Đăng nhập lại</a></div>
            </div>
        </div>
    </div>
</section>
<script>
    let timeLeft = 5 * 60;
    const timerEl = document.getElementById('timerDisplay');
    const timerContainer = document.getElementById('timerContainer');
    const resendSection = document.getElementById('resendSection');
    const countdownSection = document.getElementById('countdownSection');
    const countdownDisplay = document.getElementById('countdownDisplay');
    const submitBtn = document.getElementById('submitBtn');
    const countdownInterval = setInterval(() => { let count = parseInt(countdownDisplay.textContent); if (count > 1) { countdownDisplay.textContent = count - 1; } else { clearInterval(countdownInterval); countdownSection.classList.add('hidden'); resendSection.classList.remove('hidden'); } }, 1000);
    const timerInterval = setInterval(() => { const minutes = String(Math.floor(timeLeft / 60)).padStart(2, '0'); const seconds = String(timeLeft % 60).padStart(2, '0'); timerEl.textContent = minutes + ':' + seconds; if (--timeLeft < 0) { clearInterval(timerInterval); timerEl.textContent = '00:00'; timerContainer.classList.add('expired'); submitBtn.disabled = true; resendSection.classList.remove('hidden'); countdownSection.classList.add('hidden'); } }, 1000);
    function refreshCartCount() { fetch('${pageContext.request.contextPath}/cart/count').then(r => r.json()).then(data => { const el = document.getElementById('cartCount'); if (el) el.textContent = data.count; }).catch(() => {}); }
    refreshCartCount();
</script>
</body>
</html>
