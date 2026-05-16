<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập bằng Email - MobileStore</title>
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
        .field { margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 8px; color: #1a1a1a; font-weight: 500; font-size: 0.95rem; }
        input { width: 100%; padding: 14px 16px; border: 1px solid #e5e5e5; border-radius: 8px; font-size: 0.95rem; color: #1a1a1a; background: #ffffff; transition: border-color 0.2s; }
        input:focus { outline: none; border-color: #1a1a1a; }
        .btn { display: block; width: 100%; padding: 14px 16px; background: #1a1a1a; color: #ffffff; text-align: center; border: none; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: background-color 0.2s; text-decoration: none; }
        .btn:hover { background: #333; }
        .btn-outline { display: block; width: 100%; padding: 14px 16px; background: #ffffff; color: #1a1a1a; text-align: center; border: 1px solid #e5e5e5; border-radius: 8px; font-weight: 500; font-size: 0.95rem; cursor: pointer; transition: all 0.2s; text-decoration: none; margin-top: 0.75rem; }
        .btn-outline:hover { border-color: #1a1a1a; background: #fafafa; }
        .error { color: #b91c1c; margin-bottom: 1rem; background: #fef2f2; border: 1px solid #fecaca; padding: 12px 16px; border-radius: 8px; font-size: 0.9rem; }
        .helper { margin-top: 1.5rem; text-align: center; font-size: 0.9rem; color: #666; }
        .helper a { color: #1a1a1a; text-decoration: none; font-weight: 500; }
        .helper a:hover { text-decoration: underline; }
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
                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <span>&#8592;</span> Quay lại đăng nhập
                </a>
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

                <a href="${pageContext.request.contextPath}/login" class="btn-outline">Đăng nhập bằng mật khẩu</a>

                <div class="helper">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>
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
</body>
</html>
