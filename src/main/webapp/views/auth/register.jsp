<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #ffffff;
        }

        .header {
            background: #1a1a1a;
            border-bottom: none;
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

        .user-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            text-decoration: none;
        }

        .user-pill:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .user-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.35);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
        }

        .user-name {
            font-weight: 600;
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
            margin-bottom: 2rem;
            text-align: center;
            color: #1a1a1a;
            font-size: 1.75rem;
            font-weight: 600;
            letter-spacing: -0.5px;
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

        input.error {
            border-color: #dc3545;
            background-color: #fff5f5;
        }

        input.valid {
            border-color: #28a745;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 6px;
            display: none;
        }

        .field.error .error-message {
            display: block;
        }

        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: #e5e5e5;
            border-radius: 2px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: width 0.3s, background 0.3s;
        }

        .password-strength-bar.weak {
            width: 33%;
            background: #dc3545;
        }

        .password-strength-bar.medium {
            width: 66%;
            background: #ffc107;
        }

        .password-strength-bar.strong {
            width: 100%;
            background: #28a745;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 14px 16px;
            background: #1a1a1a;
            color: #ffffff;
            text-align: center;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.2s;
        }

        .btn:hover {
            background: #333;
            transform: translateY(-1px);
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

        .success {
            color: #065f46;
            margin-bottom: 1rem;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
        }

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

        .helper a:hover {
            text-decoration: underline;
        }

        .password-hint {
            font-size: 0.85rem;
            color: #666;
            margin-top: 6px;
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
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang
                                Quản Lý</a>
                        </c:if>
                        <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                            <span class="user-avatar">👤</span>
                            <span class="user-name">${sessionScope.user.username}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/register" style="color:#fff; font-weight:600;">Đăng
                            Ký</a>
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
                <h2>Đăng ký tài khoản</h2>
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success">${success}</div>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm" novalidate>
                    <div class="field" id="usernameField">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" required
                               value="${param.username}"
                               minlength="3" maxlength="50"
                               pattern="^[a-zA-Z0-9_]+$"
                               autocomplete="username"
                               placeholder="Nhập tên đăng nhập"/>
                        <div class="error-message" id="usernameError">Tên đăng nhập phải có ít nhất 3 ký tự</div>
                    </div>
                    <div class="field" id="emailField">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required
                               value="${param.email}"
                               autocomplete="email"
                               placeholder="Nhập địa chỉ email (dùng để khôi phục mật khẩu)"/>
                        <div class="error-message" id="emailError">Vui lòng nhập địa chỉ email hợp lệ</div>
                    </div>
                    <div class="field" id="passwordField">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" required
                               minlength="6"
                               autocomplete="new-password"
                               placeholder="Nhập mật khẩu"/>
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strengthBar"></div>
                        </div>
                        <div class="password-hint">Mật khẩu phải có ít nhất 6 ký tự</div>
                        <div class="error-message" id="passwordError">Mật khẩu phải có ít nhất 6 ký tự</div>
                    </div>
                    <div class="field" id="confirmPasswordField">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                               autocomplete="new-password"
                               placeholder="Nhập lại mật khẩu"/>
                        <div class="error-message" id="confirmPasswordError">Mật khẩu xác nhận không khớp</div>
                    </div>
                    <button class="btn" type="submit" id="submitBtn">Đăng ký</button>
                </form>
                <div class="helper">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                </div>
                <div class="helper">
                    <a href="${pageContext.request.contextPath}/">Quay về trang chủ</a>
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
                <div class="mt-3">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <h5 class="text-uppercase fw-bold mb-4">Chính sách hỗ trợ</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="policy.jsp?type=warranty" class="text-secondary text-decoration-none">Chính
                        sách bảo hành</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=return" class="text-secondary text-decoration-none">Chính
                        sách đổi trả</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=shipping" class="text-secondary text-decoration-none">Chính
                        sách vận chuyển</a></li>
                    <li class="mb-2"><a href="policy.jsp?type=privacy" class="text-secondary text-decoration-none">Bảo
                        mật thông tin</a></li>
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

    function validateUsername() {
        const username = document.getElementById('username');
        const field = document.getElementById('usernameField');
        const error = document.getElementById('usernameError');
        const value = username.value.trim();

        if (!value) {
            username.classList.add('error');
            username.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Tên đăng nhập không được để trống';
            return false;
        }

        if (value.length < 3) {
            username.classList.add('error');
            username.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Tên đăng nhập phải có ít nhất 3 ký tự';
            return false;
        }

        if (value.length > 50) {
            username.classList.add('error');
            username.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Tên đăng nhập không được vượt quá 50 ký tự';
            return false;
        }

        if (!/^[a-zA-Z0-9_]+$/.test(value)) {
            username.classList.add('error');
            username.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới';
            return false;
        }

        username.classList.remove('error');
        username.classList.add('valid');
        field.classList.remove('error');
        return true;
    }

    function validateEmail() {
        const email = document.getElementById('email');
        const field = document.getElementById('emailField');
        const error = document.getElementById('emailError');
        const value = (email.value || '').trim().toLowerCase();
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        if (!value) {
            email.classList.add('error');
            email.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Email không được để trống';
            return false;
        }
        if (!emailRegex.test(value)) {
            email.classList.add('error');
            email.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Địa chỉ email không hợp lệ';
            return false;
        }
        email.classList.remove('error');
        email.classList.add('valid');
        field.classList.remove('error');
        return true;
    }

    function validatePassword() {
        const password = document.getElementById('password');
        const field = document.getElementById('passwordField');
        const error = document.getElementById('passwordError');
        const value = password.value;
        const strengthBar = document.getElementById('strengthBar');

        if (!value) {
            password.classList.add('error');
            password.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Mật khẩu không được để trống';
            strengthBar.className = 'password-strength-bar';
            return false;
        }

        if (value.length < 6) {
            password.classList.add('error');
            password.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
            strengthBar.className = 'password-strength-bar weak';
            return false;
        }

        strengthBar.className = 'password-strength-bar';
        if (value.length >= 6 && value.length < 10) {
            strengthBar.classList.add('weak');
        } else if (value.length >= 10 && /[A-Z]/.test(value) && /[0-9]/.test(value)) {
            strengthBar.classList.add('strong');
        } else {
            strengthBar.classList.add('medium');
        }

        password.classList.remove('error');
        password.classList.add('valid');
        field.classList.remove('error');
        return true;
    }

    function validateConfirmPassword() {
        const confirmPassword = document.getElementById('confirmPassword');
        const field = document.getElementById('confirmPasswordField');
        const error = document.getElementById('confirmPasswordError');
        const password = document.getElementById('password').value;
        const value = confirmPassword.value;

        if (!value) {
            confirmPassword.classList.add('error');
            confirmPassword.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Vui lòng xác nhận mật khẩu';
            return false;
        }

        if (value !== password) {
            confirmPassword.classList.add('error');
            confirmPassword.classList.remove('valid');
            field.classList.add('error');
            error.textContent = 'Mật khẩu xác nhận không khớp';
            return false;
        }

        confirmPassword.classList.remove('error');
        confirmPassword.classList.add('valid');
        field.classList.remove('error');
        return true;
    }

    function validateRegisterForm() {
        const isUsernameValid = validateUsername();
        const isEmailValid = validateEmail();
        const isPasswordValid = validatePassword();
        const isConfirmValid = validateConfirmPassword();
        return isUsernameValid && isEmailValid && isPasswordValid && isConfirmValid;
    }

    document.getElementById('username').addEventListener('blur', validateUsername);
    document.getElementById('username').addEventListener('input', function () {
        if (this.classList.contains('error')) {
            validateUsername();
        }
    });

    document.getElementById('email').addEventListener('blur', validateEmail);
    document.getElementById('email').addEventListener('input', function () {
        if (this.classList.contains('error')) {
            validateEmail();
        }
    });

    document.getElementById('password').addEventListener('blur', validatePassword);
    document.getElementById('password').addEventListener('input', function () {
        if (this.classList.contains('error')) {
            validatePassword();
        }
        const confirmPassword = document.getElementById('confirmPassword');
        if (confirmPassword.value) {
            validateConfirmPassword();
        }
    });

    document.getElementById('confirmPassword').addEventListener('blur', validateConfirmPassword);
    document.getElementById('confirmPassword').addEventListener('input', function () {
        if (this.classList.contains('error')) {
            validateConfirmPassword();
        }
    });

    document.getElementById('registerForm').addEventListener('submit', function (e) {
        if (!validateRegisterForm()) {
            e.preventDefault();
            const firstError = document.querySelector('input.error');
            if (firstError) {
                firstError.focus();
            }
        }
    });

    refreshCartCount();
</script>
</body>
</html>

