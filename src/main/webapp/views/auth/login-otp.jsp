<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập mã OTP - MobileStore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif; line-height: 1.6; color: #1a1a1a; background: #ffffff; }
        .header { background: #1a1a1a; height: 72px; }
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
        input { width: 100%; padding: 14px 16px; border: 1px solid #e5e5e5; border-radius: 8px; font-size: 0.95rem; color: #1a1a1a; background: #ffffff; transition: border-color 0.2s; text-align: center; letter-spacing: 8px; font-size: 24px; }
        input:focus { outline: none; border-color: #1a1a1a; }
        .btn { display: block; width: 100%; padding: 14px 16px; background: #1a1a1a; color: #ffffff; text-align: center; border: none; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: background-color 0.2s; }
        .btn:hover { background: #333; }
        .btn:disabled { background: #999; cursor: not-allowed; }
        .btn-outline { display: block; width: 100%; padding: 14px 16px; background: #ffffff; color: #1a1a1a; text-align: center; border: 1px solid #e5e5e5; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: all 0.2s; text-decoration: none; margin-top: 0.75rem; }
        .btn-outline:hover { border-color: #1a1a1a; background: #fafafa; }
        .error { color: #b91c1c; margin-bottom: 1rem; background: #fef2f2; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
        .timer { text-align: center; margin-bottom: 1.5rem; font-size: 0.9rem; color: #666; }
        .timer .time { font-weight: 600; color: #1a1a1a; font-variant-numeric: tabular-nums; }
        .timer.expired { color: #b91c1c; }
        .resend { text-align: center; margin-top: 1rem; font-size: 0.9rem; color: #666; }
        .resend a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .resend a:hover { text-decoration: underline; }
        .resend.hidden { visibility: hidden; }
        .back-link { display: flex; align-items: center; gap: 6px; justify-content: center; margin-bottom: 1.5rem; color: #666; font-size: 0.9rem; text-decoration: none; }
        .back-link:hover { color: #1a1a1a; }
        footer { background: #000; padding: 3rem 0 1.5rem; margin-top: 4rem; color: #fff; }
        footer .container { max-width: 976px; margin: 0 auto; padding: 0 24px; }
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
                <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng</a>
                <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                <a href="${pageContext.request.contextPath}/register">Đăng Ký</a>
            </nav>
        </div>
    </div>
</header>

<section class="page">
    <div class="container">
        <div class="center">
            <div class="card">
                <a href="${pageContext.request.contextPath}/send-otp" class="back-link">
                    <span>&#8592;</span> Nhập lại email
                </a>
                <h2>Xác nhận mã OTP</h2>
                <p class="subtitle">
                    Mã OTP đã được gửi đến <strong>${sessionScope.otpEmail}</strong>.
                    Mã có hiệu lực trong 5 phút.
                </p>

                <c:if test="${not empty errorMessage}">
                    <div class="error">${errorMessage}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/verify-otp" novalidate>
                    <div class="field">
                        <label for="otpCode">Mã OTP (6 chữ số)</label>
                        <input type="text" id="otpCode" name="otpCode"
                               maxlength="6" placeholder="------"
                               pattern="[0-9]{6}" required
                               autocomplete="off" readonly
                               onfocus="this.removeAttribute('readonly')">
                    </div>

                    <p class="timer" id="timerSection">
                        Mã hết hạn sau: <span class="time" id="timer">05:00</span>
                    </p>

                    <button type="submit" class="btn" id="submitBtn">Xác nhận</button>
                </form>

                <div class="resend" id="resendSection">
                    Không nhận được mã?
                    <a href="${pageContext.request.contextPath}/send-otp" id="resendLink">Gửi lại OTP</a>
                    <span id="countdownText" class="hidden">(<span id="countdownSeconds">60</span>s)</span>
                </div>

                <a href="${pageContext.request.contextPath}/login" class="btn-outline">Đăng nhập bằng mật khẩu</a>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container">
        <div style="text-align: center; color: #666; font-size: 0.85rem;">
            &copy; 2026 Mobile Store.
        </div>
    </div>
</footer>

<script>
    (function() {
        var timeLeft = 5 * 60;
        var countdownInterval;
        var otpInput = document.getElementById('otpCode');
        if (otpInput) {
            otpInput.value = '';
            otpInput.focus();
        }

        function updateDisplay() {
            var minutes = String(Math.floor(timeLeft / 60)).padStart(2, '0');
            var seconds = String(timeLeft % 60).padStart(2, '0');
            document.getElementById('timer').textContent = minutes + ':' + seconds;
        }

        function startCountdown() {
            updateDisplay();
            countdownInterval = setInterval(function() {
                timeLeft--;
                updateDisplay();
                if (timeLeft <= 0) {
                    clearInterval(countdownInterval);
                    document.getElementById('timer').textContent = '00:00';
                    document.getElementById('submitBtn').disabled = true;
                    var timerSection = document.getElementById('timerSection');
                    timerSection.className = 'timer expired';
                    timerSection.innerHTML = 'Mã đã hết hạn. <a href="${pageContext.request.contextPath}/send-otp" style="color:#b91c1c;">Gửi lại OTP</a>';
                }
            }, 1000);
        }

        function startResendCooldown() {
            var resendLink = document.getElementById('resendLink');
            var countdownText = document.getElementById('countdownText');
            var secondsLeft = 60;
            resendLink.style.pointerEvents = 'none';
            resendLink.style.opacity = '0.5';
            resendLink.style.textDecoration = 'none';
            countdownText.classList.remove('hidden');

            var cooldownInterval = setInterval(function() {
                secondsLeft--;
                document.getElementById('countdownSeconds').textContent = secondsLeft;
                if (secondsLeft <= 0) {
                    clearInterval(cooldownInterval);
                    resendLink.style.pointerEvents = 'auto';
                    resendLink.style.opacity = '1';
                    resendLink.style.textDecoration = 'underline';
                    countdownText.classList.add('hidden');
                }
            }, 1000);
        }

        document.getElementById('otpCode').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '').substring(0, 6);
        });

        startCountdown();
        startResendCooldown();
    })();
</script>
</body>
</html>
