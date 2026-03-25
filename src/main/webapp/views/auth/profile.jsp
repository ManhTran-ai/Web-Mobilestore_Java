<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background: radial-gradient(circle at 20% 20%, #e0f7f4 0, #f5f7fb 35%, #f9fbff 65%, #f5f5f5 100%);
            color: #0f172a;
            line-height: 1.6;
        }

        .header {
            background: #1a1a1a;
            height: 72px;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .container {
            max-width: 1320px;
            margin: 0 auto;
            padding: 0 12px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 72px;
        }

        .logo {
            font-weight: 600;
            font-size: 1.5rem;
            color: #ffffff;
            letter-spacing: -0.5px;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav a {
            color: #fff;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 400;
            display: inline-flex;
            align-items: center;
            height: 72px;
        }

        .nav a:hover {
            opacity: 0.7;
        }

        .user-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;

        }

        .user-pill:hover {
            background: rgba(255, 255, 255, 0.16);
        }

        .user-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.35);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .user-name {
            font-weight: 700;
            letter-spacing: -0.2px;
        }

        .page {
            padding: 48px 0 72px;
        }

        .hero {
            background: #000000;
            color: #fff;
            padding: 24px 24px 18px;
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(15, 118, 110, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .hero .title {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .hero .subtitle {
            opacity: 0.9;
            margin-top: 6px;
            font-size: 0.98rem;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            background: rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            font-weight: 600;
        }

        .content {
            margin-top: 24px;
            display: grid;
            gap: 16px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            padding: 20px;
        }

        .tabs {
            display: flex;
            gap: 12px;
            border-bottom: 1px solid #e5e7eb;
            padding: 0 4px 8px;
        }

        .tab-btn {
            border: none;
            background: transparent;
            padding: 10px 14px;
            font-weight: 700;
            color: #475569;
            cursor: pointer;
            border-radius: 12px;
            transition: all 0.2s ease;
        }

        .tab-btn.active {
            background: #0f172a;
            color: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.18);
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 16px;
            margin-top: 12px;
        }

        label {
            display: block;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 6px;
        }

        input, textarea {
            width: 100%;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.96rem;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            background: #f8fafc;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
            background: #fff;
        }

        textarea {
            resize: vertical;
            min-height: 96px;
        }

        .actions {
            margin-top: 20px;
            display: flex;
            gap: 12px;
        }

        .btn {
            border: none;
            padding: 12px 18px;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.12s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .btn-primary {
            background: #0f172a;
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.22);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            background: #111827;
        }

        .btn-ghost {
            background: #e2e8f0;
            color: #0f172a;
        }

        .note {
            color: #475569;
            font-size: 0.9rem;
            margin-top: 6px;
        }

        .status {
            margin-bottom: 12px;
            padding: 12px 14px;
            border-radius: 12px;
            font-weight: 600;
        }

        .status.success {
            background: #ecfdf3;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .status.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecdd3;
        }

        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
            margin-top: 14px;
        }

        .product-card {
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 20px rgba(15, 23, 42, 0.06);
            display: flex;
            flex-direction: column;
        }

        .product-thumb {
            background: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 18px;
        }

        .product-thumb img {
            max-width: 100%;
            max-height: 180px;
            object-fit: contain;
        }

        .product-body {
            padding: 14px;
            display: grid;
            gap: 6px;
        }

        .product-name {
            font-weight: 700;
            color: #0f172a;
        }

        .product-meta {
            color: #64748b;
            font-size: 0.9rem;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .price {
            font-weight: 800;
            color: #0f766e;
        }

        .discount {
            color: #b91c1c;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .empty-state {
            padding: 32px;
            text-align: center;
            color: #475569;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 14px;
        }

        .fav-actions {
            margin-top: 10px;
            display: flex;
            justify-content: flex-end;
        }

        .btn-danger {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecdd3;
        }

        .btn-danger:hover {
            background: #fecdd3;
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
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#7dd3fc;">Trang
                                Quản Lý</a>
                        </c:if>
                        <a class="user-pill" href="${pageContext.request.contextPath}/profile">
                            <span class="user-avatar">👤</span>
                            <span class="user-name">${sessionScope.user.username}</span>
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
        <div class="hero">
            <div>
                <div class="title">Xin chào, <c:out value="${profileUser.username}"/></div>
                <div class="subtitle">Quản lý thông tin cá nhân và danh sách sản phẩm yêu thích của bạn.</div>
            </div>

        </div>

        <div class="content">
            <div class="card">
                <div class="tabs">
                    <button type="button" class="tab-btn" data-tab="info">Thông tin chung</button>
                    <button type="button" class="tab-btn" data-tab="favorites">Sản phẩm yêu thích</button>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="status success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="status error">${errorMessage}</div>
                </c:if>

                <div id="tab-info" class="tab-panel">
                    <form method="post" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="updateProfile"/>
                        <div class="form-grid">
                            <div>
                                <label for="username">Họ và tên</label>
                                <input type="text" id="username" name="username" value="${profileUser.username}"
                                       required minlength="3" maxlength="120"/>
                            </div>
                            <div>
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" value="${profileUser.email}"
                                       placeholder="email@domain.com"/>
                            </div>
                            <div>
                                <label for="customerPhone">Số điện thoại</label>
                                <input type="text" id="customerPhone" name="customerPhone"
                                       value="${profileUser.customerPhone}" placeholder="Nhập số điện thoại"/>
                            </div>
                            <div>
                                <label for="shippingAddress">Địa chỉ giao hàng</label>
                                <textarea id="shippingAddress" name="shippingAddress"
                                          placeholder="Số nhà, đường, quận/huyện, tỉnh/thành">${profileUser.shippingAddress}</textarea>
                            </div>
                            <div>
                                <label for="note">Ghi chú</label>
                                <textarea id="note" name="note"
                                          placeholder="Thông tin thêm để hỗ trợ giao hàng">${profileUser.note}</textarea>
                            </div>
                        </div>

                        <div class="form-grid" style="margin-top:12px;">
                            <div>
                                <label for="newPassword">Mật khẩu mới</label>
                                <input type="password" id="newPassword" name="newPassword"
                                       placeholder="Để trống nếu không đổi" minlength="6"/>
                                <div class="note">Tối thiểu 6 ký tự. Chỉ cần nhập khi muốn đổi mật khẩu.</div>
                            </div>
                            <div>
                                <label for="confirmPassword">Xác nhận mật khẩu</label>
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       placeholder="Nhập lại mật khẩu mới" minlength="6"/>
                            </div>
                        </div>

                        <div class="actions">
                            <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
                            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/">Về trang chủ</a>
                        </div>
                    </form>
                </div>

                <div id="tab-favorites" class="tab-panel">
                    <c:choose>
                        <c:when test="${empty favoriteProducts}">
                            <div class="empty-state">Chưa có sản phẩm nào trong danh sách yêu thích.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="favorites-grid">
                                <c:forEach var="product" items="${favoriteProducts}">
                                    <div class="product-card">
                                        <div class="product-thumb">
                                            <img src="${pageContext.request.contextPath}/${product.image}"
                                                 alt="${product.productName}"/>
                                        </div>
                                        <div class="product-body">
                                            <div class="product-name">${product.productName}</div>
                                            <div class="product-meta">${product.manufacturer}
                                                · ${product.productCondition}</div>
                                            <div class="price-row">
                                                <div class="price">
                                                    <fmt:formatNumber value="${product.price}" type="currency"
                                                                      currencySymbol="" groupingUsed="true"/> đ
                                                </div>
                                                <c:if test="${product.discount > 0}">
                                                    <div class="discount">-${product.discount}%</div>
                                                </c:if>
                                            </div>
                                            <div class="fav-actions">
                                                <form method="post" action="${pageContext.request.contextPath}/profile">
                                                    <input type="hidden" name="action" value="removeFavorite"/>
                                                    <input type="hidden" name="productId" value="${product.productId}"/>
                                                    <button type="submit" class="btn btn-danger">Xóa yêu thích</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    const activeTab = '${activeTab}' || 'info';
    const tabButtons = document.querySelectorAll('.tab-btn');
    const panels = {
        info: document.getElementById('tab-info'),
        favorites: document.getElementById('tab-favorites')
    };

    function setTab(tab) {
        tabButtons.forEach(btn => {
            const isActive = btn.dataset.tab === tab;
            btn.classList.toggle('active', isActive);
        });
        Object.keys(panels).forEach(key => {
            panels[key].classList.toggle('active', key === tab);
        });
    }

    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => setTab(btn.dataset.tab));
    });

    setTab(activeTab === 'favorites' ? 'favorites' : 'info');

    function refreshCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(r => r.json())
            .then(data => {
                const el = document.getElementById('cartCount');
                if (el && data.count !== undefined) {
                    el.textContent = data.count;
                }
            }).catch(() => {
        });
    }

    refreshCartCount();
</script>
</body>
</html>
