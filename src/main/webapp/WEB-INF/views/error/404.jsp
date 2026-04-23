<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Trang không tìm thấy</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f4f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .error-container {
            text-align: center;
            padding: 2rem;
        }
        .error-code {
            font-size: 6rem;
            font-weight: 700;
            color: #0071e3;
            line-height: 1;
        }
        .error-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1a1a1a;
            margin: 1rem 0;
        }
        .error-message {
            font-size: 1rem;
            color: #666;
            margin-bottom: 2rem;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #1a1a1a;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
        }
        .btn:hover { opacity: 0.8; }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">Trang không tìm thấy</h1>
        <p class="error-message">Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
        <a href="<%= request.getContextPath() %>/" class="btn">Quay về trang chủ</a>
    </div>
</body>
</html>
