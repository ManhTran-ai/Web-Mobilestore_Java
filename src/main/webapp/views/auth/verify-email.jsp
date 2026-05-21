<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Email – MobileStore</title>
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
        .container { max-width: 976px; margin: 0 auto; padding: 0 24px; }
        .header-content { display: flex; justify-content: space-between; align-items: center; height: 100%; }
        .logo { font-size: 1.5rem; font-weight: 600; color: #ffffff; display: flex; align-items: center; height: 72px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #ffffff; text-decoration: none; font-size: 0.95rem; font-weight: 400; transition: opacity 0.2s; display: inline-flex; align-items: center; height: 72px; }
        .nav a:hover { opacity: 0.7; }
        .user-pill { display: inline-flex; align-items: center; gap: 8px; padding: 8px 10px; border: 1px solid rgba(255,255,255,0.2); border-radius: 999px; background: rgba(255,255,255,0.08); color: #fff; text-decoration: none; }
        .user-pill:hover { background: rgba(255,255,255,0.15); }
        .page { padding: 4rem 0; min-height: calc(100vh - 200px); }
        .center { max-width: 480px; margin: 0 auto; }
        .card { background: #ffffff; padding: 3rem 2.5rem; border-radius: 12px; border: 1px solid #e5e5e5; }
        .success-card { border-color: #bbf7d0; background: #f0fdf4; }
        h2 { margin-bottom: 0.5rem; text-align: center; color: #1a1a1a; font-size: 1.75rem; font-weight: 600; letter-spacing: -0.5px; }
        .subtitle { text-align: center; color: #666; font-size: 0.95rem; margin-bottom: 2rem; }
        .subtitle strong { color: #1a1a1a; font-weight: 600; }
        .email-highlight { background: #f4f4f4; border-radius: 8px; padding: 12px 16px; text-align: center; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .email-highlight .email { font-weight: 600; color: #1a1a1a; font-size: 1rem; }
        .email-highlight .label { color: #888; font-size: 0.85rem; }
        .field { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 8px; color: #1a1a1a; font-weight: 500; font-size: 0.95rem; text-align: center; }
        .otp-inputs { display: flex; justify-content: center; gap: 10px; margin-bottom: 1.5rem; }
        .otp-inputs input { width: 52px; height: 60px; text-align: center; font-size: 1.5rem; font-weight: 700; border: 2px solid #e5e5e5; border-radius: 10px; outline: none; transition: border-color 0.2s, box-shadow 0.2s; color: #1a1a1a; background: #ffffff; }
        .otp-inputs input:focus { border-color: #1a1a1a; box-shadow: 0 0 0 3px rgba(26,26,26,0.1); }
        .otp-inputs input.filled { border-color: #1a1a1a; background: #fafafa; }
        .otp-inputs input.error { border-color: #dc3545; background: #fff5f5; }
        input { width: 100%; padding: 14px 16px; border: 1px solid #e5e5e5; border-radius: 8px; font-size: 0.95rem; color: #1a1a1a; background: #ffffff; transition: border-color 0.2s; }
        input:focus { outline: none; border-color: #1a1a1a; }
        .btn { display: block; width: 100%; padding: 14px 16px; background: #1a1a1a !important; color: #ffffff !important; text-align: center; border: none; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: background-color 0.2s, transform 0.2s; }
        .btn:hover { background: #333 !important; transform: translateY(-1px); }
        .btn:disabled { background: #999 !important; cursor: not-allowed; transform: none; }
        .btn-secondary { display: block; width: 100%; padding: 12px 16px; background: #ffffff !important; color: #1a1a1a !important; text-align: center; border: 1px solid #e5e5e5 !important; border-radius: 8px; font-weight: 500; font-size: 0.9rem; cursor: pointer; transition: background-color 0.2s, border-color 0.2s; text-decoration: none; text-align: center; }
        .btn-secondary:hover { background: #f5f5f5 !important; border-color: #ccc !important; }
        .error { color: #b91c1c; margin-bottom: 1rem; background: #fef2f2; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
        .success { color: #065f46; margin-bottom: 1rem; background: #f0fdf4; border: 1px solid #bbf7d0; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
        .timer { text-align: center; color: #666; font-size: 0.9rem; margin-bottom: 1.5rem; }
        .timer .time-left { color: #1a1a1a; font-weight: 600; font-size: 1.1rem; }
        .timer.expired { color: #dc3545; }
        .timer.expired .time-left { color: #dc3545; }
        .resend-section { text-align: center; font-size: 0.9rem; color: #666; margin-top: 1rem; }
        .resend-section a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .resend-section a:hover { text-decoration: underline; }
        .resend-section.hidden { display: none; }
        .helper { margin-top: 1.5rem; text-align: center; font-size: 0.9rem; color: #666; }
        .helper a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .helper a:hover { text-decoration: underline; }
        .otp-icon { text-align: center; margin-bottom: 1rem; }
        .otp-icon svg { width: 56px; height: 56px; color: #1a1a1a; }
        .success-icon { text-align: center; margin-bottom: 1rem; }
        .success-icon svg { width: 56px; height: 56px; color: #16a34a; }
        .info-box { background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px; padding: 12px 16px; margin-bottom: 1.5rem; font-size: 0.9rem; color: #1e40af; text-align: center; }
        .info-box strong { font-weight: 600; }
    </style>
</head>
<body>
<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">MobileStore</div>
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
                            <span>👤</span>
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
                        <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                    </svg>
                </div>
                <h2>Xác nhận Email</h2>
                <p class="subtitle">Nhập mã OTP đã được gửi đến email của bạn</p>

                <div class="email-highlight">
                    <div class="label">Mã xác nhận đã gửi đến</div>
                    <div class="email">${sessionScope.regEmail}</div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="error" id="errorBox">${errorMessage}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/register/verify-otp" id="otpForm" novalidate>
                    <div class="field">
                        <label for="otp1">Nhập mã OTP (6 chữ số)</label>
                        <div class="otp-inputs" id="otpInputs">
                            <input type="text" id="otp1" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="one-time-code" tabindex="1">
                            <input type="text" id="otp2" maxlength="1" pattern="[0-9]" inputmode="numeric" tabindex="2">
                            <input type="text" id="otp3" maxlength="1" pattern="[0-9]" inputmode="numeric" tabindex="3">
                            <input type="text" id="otp4" maxlength="1" pattern="[0-9]" inputmode="numeric" tabindex="4">
                            <input type="text" id="otp5" maxlength="1" pattern="[0-9]" inputmode="numeric" tabindex="5">
                            <input type="text" id="otp6" maxlength="1" pattern="[0-9]" inputmode="numeric" tabindex="6">
                        </div>
                        <input type="hidden" name="otpCode" id="otpCode">
                    </div>

                    <div class="timer" id="timerContainer">
                        Mã hết hạn sau: <span class="time-left" id="timerDisplay">05:00</span>
                    </div>

                    <button type="submit" class="btn" id="submitBtn">Xác nhận đăng ký</button>
                </form>

                <div class="resend-section" id="resendSection" style="display: none;">
                    Không nhận được mã?
                    <a href="#" id="resendLink" onclick="resendOtp(); return false;">Gửi lại mã OTP</a>
                </div>

                <div class="resend-section" id="countdownSection">
                    Gửi lại sau <span id="countdownDisplay">60</span>s
                </div>

                <div class="helper" style="margin-top: 1rem;">
                    <a href="${pageContext.request.contextPath}/register">&larr; Quay về đăng ký</a>
                </div>

                <div class="info-box">
                    <strong>Lưu ý:</strong> Mã OTP có hiệu lực trong <strong>5 phút</strong>.
                    Vui lòng kiểm tra hộp thư (và thư rác) của bạn.<br>
                    Sai mã <strong>5 lần</strong> → tài khoản bị khóa trong 5 phút.
                </div>
            </div>
        </div>
    </div>
</section>

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
                    <li class="mb-2"><a href="policy.jsp?type=warranty" class="text-secondary text-decoration-none">Chính sách bảo hành</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=return" class="text-secondary text-decoration-none">Chính sách đổi trả</a></li>
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
    const otpInputs = document.querySelectorAll('.otp-inputs input');
    const otpHidden = document.getElementById('otpCode');
    const errorBox = document.getElementById('errorBox');

    function getOtpValue() {
        return Array.from(otpInputs).map(input => input.value).join('');
    }

    function validateOtpInputs() {
        let allFilled = true;
        let allNumeric = true;
        otpInputs.forEach(input => {
            if (input.value.trim() === '') { allFilled = false; }
            if (!/^[0-9]$/.test(input.value)) {
                allNumeric = false;
                input.classList.add('error');
            } else {
                input.classList.remove('error');
                input.classList.add('filled');
            }
        });
        if (allFilled && allNumeric) {
            otpHidden.value = getOtpValue();
            return true;
        }
        return false;
    }

    otpInputs.forEach((input, index) => {
        input.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
            if (this.value.length === 1 && index < otpInputs.length - 1) {
                otpInputs[index + 1].focus();
            }
            if (errorBox) { errorBox.style.display = 'none'; }
            if (validateOtpInputs()) {
                document.getElementById('otpForm').submit();
            }
        });
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && this.value === '' && index > 0) {
                otpInputs[index - 1].focus();
            }
        });
        input.addEventListener('paste', function(e) {
            e.preventDefault();
            const pastedData = (e.clipboardData || window.clipboardData).getData('text');
            const digits = pastedData.replace(/[^0-9]/g, '').split('').slice(0, 6);
            digits.forEach((digit, i) => {
                if (otpInputs[i]) {
                    otpInputs[i].value = digit;
                    otpInputs[i].classList.add('filled');
                }
            });
            if (digits.length > 0 && otpInputs[Math.min(digits.length, otpInputs.length - 1)]) {
                otpInputs[Math.min(digits.length, otpInputs.length - 1)].focus();
            }
            if (digits.length === 6) {
                setTimeout(() => {
                    if (validateOtpInputs()) {
                        document.getElementById('otpForm').submit();
                    }
                }, 100);
            }
        });
        input.addEventListener('keypress', function(e) {
            if (!/[0-9]/.test(e.key)) { e.preventDefault(); }
        });
    });

    window.addEventListener('load', function() {
        setTimeout(() => { otpInputs[0].focus(); }, 300);
    });

    let timeLeft = 5 * 60;
    const timerEl = document.getElementById('timerDisplay');
    const timerContainer = document.getElementById('timerContainer');
    const submitBtn = document.getElementById('submitBtn');

    const timerInterval = setInterval(() => {
        const minutes = String(Math.floor(timeLeft / 60)).padStart(2, '0');
        const seconds = String(timeLeft % 60).padStart(2, '0');
        timerEl.textContent = minutes + ':' + seconds;
        if (--timeLeft < 0) {
            clearInterval(timerInterval);
            timerEl.textContent = '00:00';
            timerContainer.classList.add('expired');
            submitBtn.disabled = true;
            document.getElementById('resendSection').style.display = 'block';
            document.getElementById('countdownSection').style.display = 'none';
        }
    }, 1000);

    let resendCountdown = 60;
    const countdownDisplay = document.getElementById('countdownDisplay');
    const resendSection = document.getElementById('resendSection');
    const countdownSection = document.getElementById('countdownSection');

    const resendCountdownInterval = setInterval(() => {
        if (resendCountdown > 1) {
            resendCountdown--;
            countdownDisplay.textContent = resendCountdown;
        } else {
            clearInterval(resendCountdownInterval);
            countdownSection.style.display = 'none';
            resendSection.style.display = 'block';
        }
    }, 1000);

    function resendOtp() {
        if (resendCountdown > 0) return;
        const username = '${sessionScope.regUsername}';
        const email = '${sessionScope.regEmail}';
        const password = '${sessionScope.regPassword}';
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/register/send-otp';
        ['username', 'email', 'password', 'confirmPassword'].forEach(name => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = (name === 'confirmPassword') ? password : (name === 'username' ? username : (name === 'email' ? email : password));
            form.appendChild(input);
        });
        document.body.appendChild(form);
        form.submit();
    }

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
