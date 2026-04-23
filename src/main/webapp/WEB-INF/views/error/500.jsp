<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi hệ thống</title>
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
            color: #dc3545;
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
        .error-detail {
            display: none;
            text-align: left;
            background: #fff3cd;
            border: 1px solid #ffeeba;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 2rem;
            font-size: 0.85rem;
            color: #856404;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
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
        .toggle-detail {
            color: #0066cc;
            cursor: pointer;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <h1 class="error-title">Oops! Đã xảy ra lỗi hệ thống</h1>
        <p class="error-message">Xin lỗi, đã có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.</p>

        <% if (exception != null) { %>
        <div class="toggle-detail" onclick="document.getElementById('errorDetail').style.display='block'; this.style.display='none';">
            [Hiện chi tiết lỗi]
        </div>
        <div id="errorDetail" class="error-detail">
            <strong>Exception:</strong> <%= exception.getClass().getName() %><br>
            <strong>Message:</strong> <%= exception.getMessage() != null ? exception.getMessage() : "null" %><br>
            <br>
            <strong>Stack trace:</strong><br>
            <pre style="white-space: pre-wrap; word-break: break-all; margin-top: 8px; font-size: 0.75rem;"><%
                for (StackTraceElement ste : exception.getStackTrace()) {
                    if (ste.getClassName().startsWith("com.mobilestore")) {
                        out.println(ste.toString());
                    }
                }
            %></pre>
        </div>
        <% } %>

        <a href="<%= request.getContextPath() %>/" class="btn">Quay về trang chủ</a>
    </div>
</body>
</html>
