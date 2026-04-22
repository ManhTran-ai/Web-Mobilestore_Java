<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Mobile Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; background: #fff; color: #1a1a1a; }
        .container { max-width: 1345px; margin: 0 auto; padding: 0 24px; }
        .header { background: #1a1a1a; height: 72px; padding: 0; position: sticky; top: 0; z-index: 100; }
        .header-content { display: flex; justify-content: space-between; align-items: center; height: 100%; }
        .logo { font-size: 1.5rem; font-weight: 600; color: #fff; letter-spacing: -0.5px; display: flex; align-items: center; height: 72px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #fff; text-decoration: none; font-size: 0.95rem; font-weight: 400; transition: opacity 0.2s; display: inline-flex; align-items: center; height: 72px; line-height: normal; }
        .nav a:hover { opacity: 0.7; }
        .user-pill { display: inline-flex; align-items: center; gap: 8px; padding: 8px 10px; }
        .user-pill:hover { background: rgba(255,255,255,0.15); }
        .user-avatar { width: 26px; height: 26px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.35); display: inline-flex; align-items: center; justify-content: center; font-size: 13px; }
        .user-name { font-weight: 600; }
        .product-detail { padding: 2rem 0; display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: start; }
        .product-image-section { border: 1px solid #e5e5ea; border-radius: 12px; padding: 2rem; background: #fff; text-align: center; position: sticky; top: 90px; }
        #mainProductImage { max-width: 100%; height: 400px; object-fit: contain; display: block; margin: 0 auto; }
        .thumbnails { display: flex; gap: 8px; justify-content: center; margin-top: 12px; flex-wrap: wrap; }
        .thumb { width: 60px; height: 60px; object-fit: contain; border: 2px solid transparent; border-radius: 8px; cursor: pointer; opacity: 0.6; transition: all 0.2s; }
        .thumb.active, .thumb:hover { border-color: #0071e3; opacity: 1; }
        .product-info { padding-top: 1rem; }
        .product-title { font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem; color: #1a1a1a; }
        .product-manufacturer { font-size: 1.1rem; color: #666; margin-bottom: 1rem; }
        .product-condition { display: inline-block; background: #e5e5ea; color: #1a1a1a; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.9rem; font-weight: 500; margin-bottom: 1.5rem; }
        .price-wrapper { margin-bottom: 1.5rem; padding: 1rem 0; border-top: 1px solid #f5f5f7; border-bottom: 1px solid #f5f5f7; }
        .product-price-new { font-size: 2.5rem; font-weight: 700; color: #000; display: block; line-height: 1; }
        .price-old-group { display: flex; align-items: center; gap: 12px; margin-top: 8px; }
        .product-price-old { font-size: 1.2rem; color: #86868b; text-decoration: line-through; }
        .discount-tag { background: #000; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 0.9rem; font-weight: 600; }
        .save-amount { font-size: 0.95rem; color: #1d1d1f; margin-top: 8px; font-style: italic; }
        .variant-section { margin-bottom: 1.5rem; }
        .variant-label { font-weight: 600; margin-bottom: 0.5rem; display: block; }
        .color-options { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 12px; }
        .color-btn { padding: 6px 14px; border: 2px solid #e5e5ea; border-radius: 8px; background: #fff; cursor: pointer; font-size: 0.9rem; transition: all 0.2s; }
        .color-btn:hover { border-color: #0071e3; }
        .color-btn.selected { border-color: #0071e3; background: #f0f7ff; color: #0071e3; font-weight: 600; }
        .color-btn.out-of-stock { opacity: 0.4; cursor: not-allowed; }
        .storage-options { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 12px; }
        .storage-btn { padding: 8px 16px; border: 2px solid #e5e5ea; border-radius: 8px; background: #fff; cursor: pointer; font-size: 0.9rem; transition: all 0.2s; }
        .storage-btn:hover { border-color: #0071e3; }
        .storage-btn.selected { border-color: #0071e3; background: #f0f7ff; color: #0071e3; font-weight: 600; }
        .storage-btn.out-of-stock { opacity: 0.4; cursor: not-allowed; }
        .selected-variant-price { margin: 8px 0; font-size: 1.2rem; font-weight: 600; }
        .product-stock { font-size: 1rem; margin-bottom: 1.5rem; font-weight: 500; }
        .product-stock.in-stock { color: #28a745; }
        .product-stock.low-stock { color: #ffc107; }
        .product-stock.out-of-stock { color: #dc3545; }
        .product-description { background: #f8f9fa; border: 1px solid #e5e5ea; border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; }
        .product-description h3 { font-size: 1.2rem; font-weight: 600; margin-bottom: 1rem; color: #1a1a1a; }
        .product-description p { line-height: 1.6; color: #333; }
        .actions { display: flex; gap: 1rem; align-items: center; }
        .btn { display: inline-block; padding: 0.75rem 1.5rem; border-radius: 8px; background: #000 !important; color: #fff !important; text-decoration: none; font-weight: 500; transition: opacity 0.2s; border: none; cursor: pointer; font-size: 1rem; }
        .btn:hover { opacity: 0.8; }
        .btn.secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn:disabled { background: #ccc !important; cursor: not-allowed; }
        .related-products { margin-top: 4rem; padding-top: 2rem; border-top: 1px solid #e5e5ea; }
        .related-products h2 { font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem; color: #1a1a1a; }
        .related-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 1rem; }
        .related-card { border: 1px solid #e5e5ea; border-radius: 8px; padding: 0.75rem; background: #fff; transition: box-shadow 0.2s; text-decoration: none; color: inherit; display: block; }
        .related-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .related-card img { width: 100%; height: 90px; object-fit: contain; display: block; margin-bottom: 0.5rem; }
        .related-card .name { font-weight: 600; font-size: 0.8rem; margin-bottom: 0.25rem; line-height: 1.3; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .related-card .manufacturer { color: #666; font-size: 0.7rem; margin-bottom: 0.5rem; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .related-card .price { font-weight: 600; color: #000; font-size: 0.8rem; }
        @media (max-width: 768px) {
            .container { padding: 0 12px; }
            .product-detail { grid-template-columns: 1fr; gap: 2rem; }
            .product-title { font-size: 1.5rem; }
            .actions { flex-direction: column; align-items: stretch; }
            .btn { text-align: center; }
            .product-image-section { position: static; }
            #mainProductImage { height: 280px; }
            .related-grid { grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); }
        }

        .wishlist-btn {
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #eee;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 20px;
            color: #ccc;
            transition: all 0.3s ease;
            z-index: 10;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .wishlist-btn:hover {
            transform: scale(1.1);
            color: #ff3b30;
        }
        .wishlist-btn.active {
            color: #ff3b30;
        }
        #toast-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .toast {
            background: #000;
            color: #fff;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-size: 14px;
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s ease;
        }
        .toast.show {
            opacity: 1;
            transform: translateY(0);
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
                <a href="${pageContext.request.contextPath}/products" style="color:#fff; font-weight:600;">Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/cart">Giỏ Hàng(<span id="cartCount">0</span>)</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.roleName == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/products" style="color:#0071e3;">Trang Quản Lý</a>
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

<main class="container">
    <div class="product-detail">
        <div class="product-image-section" style="position: relative;">
            <c:set var="isLiked" value="false" />
            <c:if test="${not empty likedProductIds and likedProductIds.contains(product.productId)}">
                <c:set var="isLiked" value="true" />
            </c:if>
            <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${product.productId}" title="Thêm vào yêu thích">
                &hearts;
            </div>

            <img id="mainProductImage" src="${pageContext.request.contextPath}/${product.displayImage}" alt="${product.productName}">
            <div class="thumbnails" id="thumbnails"></div>
        </div>

        <div class="product-info">
            <h1 class="product-title">${product.productName}</h1>
            <div class="product-manufacturer">${product.manufacturer}</div>
            <div class="product-condition">${product.productCondition}</div>

            <div class="variant-section" id="variantSection">
                <span class="variant-label" id="colorLabel" style="display:none;">Màu sắc:</span>
                <div class="color-options" id="colorOptions"></div>

                <span class="variant-label" id="storageLabel" style="display:none;">Dung lượng:</span>
                <div class="storage-options" id="storageOptions"></div>

                <div class="selected-variant-price" id="selectedVariantPrice">
                    <fmt:formatNumber value="${product.displayPrice}" type="number" groupingUsed="true"/>₫
                </div>
            </div>

            <div class="product-stock in-stock" id="stockInfo">Còn hàng</div>

            <c:if test="${not empty product.productInfo}">
                <div class="product-description">
                    <h3>Mô tả sản phẩm</h3>
                    <p>${product.productInfo}</p>
                </div>
            </c:if>

            <div class="actions">
                <button class="btn add-to-cart-btn" id="addToCartBtn" onclick="addToCart()">
                    Thêm vào giỏ hàng
                </button>
                <a href="${pageContext.request.contextPath}/products" class="btn secondary">Xem thêm sản phẩm</a>
            </div>
        </div>
    </div>

    <c:if test="${not empty relatedProducts}">
        <div class="related-products">
            <h2>Sản phẩm liên quan</h2>
            <div class="related-grid">
                <c:forEach var="rp" items="${relatedProducts}">
                    <div style="position: relative;">
                        <c:set var="isLikedRp" value="false" />
                        <c:if test="${not empty likedProductIds and likedProductIds.contains(rp.productId)}">
                            <c:set var="isLikedRp" value="true" />
                        </c:if>
                        <div class="wishlist-btn ${isLikedRp ? 'active' : ''}" data-id="${rp.productId}" title="Thêm vào yêu thích" style="top: 5px; right: 5px; width: 28px; height: 28px; font-size: 16px;">
                            &hearts;
                        </div>
                        <a href="${pageContext.request.contextPath}/products/view?id=${rp.productId}" class="related-card">
                            <c:choose>
                            <c:when test="${not empty rp.displayImage}">
                                <img src="${pageContext.request.contextPath}/${rp.displayImage}" alt="${rp.productName}">
                            </c:when>
                            <c:otherwise>
                                <div style="height:90px; display:flex; align-items:center; justify-content:center; color:#888; font-size:2rem;">&#128241;</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="name">${rp.productName}</div>
                        <div class="manufacturer">${rp.manufacturer}</div>
                        <div class="price">
                            <fmt:formatNumber value="${rp.displayPrice}" type="number"/>₫
                        </div>
                    </a>
                </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</main>

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
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách bảo hành</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách đổi trả</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Chính sách vận chuyển</a></li>
                    <li class="mb-2"><a href="#" class="text-secondary text-decoration-none">Bảo mật thông tin</a></li>
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

<div id="toast-container"></div>
<script>
    function showToast(message) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast';
        toast.textContent = message;
        container.appendChild(toast);
        
        setTimeout(() => toast.classList.add('show'), 10);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    document.addEventListener('DOMContentLoaded', () => {
        const wishlistBtns = document.querySelectorAll('.wishlist-btn');
        wishlistBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                const productId = this.getAttribute('data-id');
                const currentBtn = this;
                
                fetch('${pageContext.request.contextPath}/api/toggle-like', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        if (data.action === 'liked') {
                            currentBtn.classList.add('active');
                        } else {
                            currentBtn.classList.remove('active');
                        }
                        showToast(data.message);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!');
                        if (data.message && data.message.includes('đăng nhập')) {
                            setTimeout(() => {
                                window.location.href = '${pageContext.request.contextPath}/login';
                            }, 1500);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Không thể kết nối đến máy chủ.');
                });
            });
        });
    });

    const variants = [
        <c:forEach var="v" items="${product.variants}" varStatus="st">
        {variantId: ${v.variantId}, color: "${v.color}", storage: "${v.storage}",
            price: ${v.price}, stock: ${v.quantityInStock}, image: "${v.variantImage}"}${st.last ? '' : ','}
        </c:forEach>
    ];

    const colorMap = {};
    variants.forEach(function(v) {
        if (!colorMap[v.color]) colorMap[v.color] = [];
        colorMap[v.color].push(v);
    });
    const colors = Object.keys(colorMap);

    const storageMap = {};
    variants.forEach(function(v) {
        if (!storageMap[v.storage]) storageMap[v.storage] = [];
        storageMap[v.storage].push(v);
    });
    const storages = Object.keys(storageMap);

    let selectedColor = null;
    let selectedStorage = null;
    let selectedVariant = null;

    function formatNumber(n) {
        return new Intl.NumberFormat('vi-VN').format(n);
    }

    function selectColor(color) {
        selectedColor = color;
        document.querySelectorAll('.color-btn').forEach(function(btn) {
            btn.classList.toggle('selected', btn.getAttribute('data-color') === color);
        });
        updateStorageOptions();

        var colorVariants = colorMap[color];
        var availableStorages = colorVariants.filter(function(v) { return v.stock > 0; });
        if (!selectedStorage || !availableStorages.find(function(v) { return v.storage === selectedStorage; })) {
            if (availableStorages.length > 0) {
                selectStorage(availableStorages[0].storage);
            } else {
                selectedStorage = null;
                selectedVariant = null;
                updateUI();
                buildThumbnails(selectedColor);
            }
        } else {
            findSelectedVariant();
            updateUI();
            if (selectedVariant) {
                updateMainImage(selectedVariant);
            }
        }
        buildThumbnails(selectedColor);
    }

    function updateStorageOptions() {
        var container = document.getElementById('storageOptions');
        container.innerHTML = '';
        var label = document.getElementById('storageLabel');
        if (!selectedColor) {
            label.style.display = 'none';
            return;
        }
        label.style.display = 'block';
        var colorVariants = colorMap[selectedColor];
        colorVariants.forEach(function(v) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'storage-btn' + (v.stock <= 0 ? ' out-of-stock' : '') + (v.storage === selectedStorage ? ' selected' : '');
            btn.setAttribute('data-storage', v.storage);
            if (v.stock <= 0) btn.disabled = true;
            btn.textContent = v.storage + (v.stock <= 0 ? ' (Hết hàng)' : '');
            btn.onclick = function() { if (v.stock > 0) selectStorage(v.storage); };
            container.appendChild(btn);
        });
    }

    function selectStorage(storage) {
        selectedStorage = storage;
        document.querySelectorAll('.storage-btn').forEach(function(btn) {
            btn.classList.toggle('selected', btn.getAttribute('data-storage') === storage);
        });
        findSelectedVariant();
        updateUI();
        if (selectedVariant) {
            updateMainImage(selectedVariant);
        }
    }

    function findSelectedVariant() {
        if (!selectedColor || !selectedStorage) {
            selectedVariant = null;
            return;
        }
        selectedVariant = variants.find(function(v) { return v.color === selectedColor && v.storage === selectedStorage; }) || null;
    }

    function updateUI() {
        var priceEl = document.getElementById('selectedVariantPrice');
        var stockEl = document.getElementById('stockInfo');
        var btn = document.getElementById('addToCartBtn');

        if (selectedVariant) {
            priceEl.textContent = formatNumber(selectedVariant.price) + '₫';
            if (selectedVariant.stock <= 0) {
                stockEl.textContent = 'Hết hàng';
                stockEl.className = 'product-stock out-of-stock';
                btn.disabled = true;
                btn.textContent = 'Hết hàng';
            } else if (selectedVariant.stock < 5) {
                stockEl.textContent = 'Chỉ còn ' + selectedVariant.stock + ' sản phẩm';
                stockEl.className = 'product-stock low-stock';
                btn.disabled = false;
                btn.textContent = 'Thêm vào giỏ hàng';
            } else {
                stockEl.textContent = 'Còn hàng';
                stockEl.className = 'product-stock in-stock';
                btn.disabled = false;
                btn.textContent = 'Thêm vào giỏ hàng';
            }
        } else {
            priceEl.innerHTML = '<fmt:formatNumber value="${product.displayPrice}" type="number" groupingUsed="true"/>₫ <span style="font-size:0.8rem;color:#666;">(Giá từ)</span>';
            stockEl.textContent = '';
            stockEl.className = 'product-stock';
            btn.disabled = false;
            btn.textContent = 'Vui lòng chọn phiên bản';
        }
    }

    function selectThumb(img, src) {
        document.getElementById('mainProductImage').src = '${pageContext.request.contextPath}/' + src;
        document.querySelectorAll('.thumb').forEach(function(t) { t.classList.remove('active'); });
        img.classList.add('active');
    }

    function buildThumbnails(colorFilter) {
        var container = document.getElementById('thumbnails');
        container.innerHTML = '';
        var filteredVariants = colorFilter
            ? variants.filter(function(v) { return v.color === colorFilter; })
            : variants;
        if (filteredVariants.length === 0) return;
        var seenImages = {};
        var uniqueVariants = [];
        for (var i = 0; i < filteredVariants.length; i++) {
            var v = filteredVariants[i];
            var imgPath = (v.variantImage && String(v.variantImage).trim()) || '';
            if (!imgPath) continue;
            if (!seenImages[imgPath]) {
                seenImages[imgPath] = true;
                uniqueVariants.push(v);
            }
        }
        uniqueVariants.forEach(function(v, i) {
            var img = document.createElement('img');
            img.className = 'thumb' + (i === 0 ? ' active' : '');
            img.src = '${pageContext.request.contextPath}/' + v.variantImage;
            img.alt = v.color;
            img.onclick = function() { selectThumb(img, v.variantImage); };
            container.appendChild(img);
        });
    }

    function updateMainImage(variant) {
        if (!variant || !variant.image) return;
        var mainImg = document.getElementById('mainProductImage');
        mainImg.src = '${pageContext.request.contextPath}/' + variant.image;
        document.querySelectorAll('.thumb').forEach(function(t) { t.classList.remove('active'); });
        var thumbs = document.querySelectorAll('.thumb');
        for (var i = 0; i < thumbs.length; i++) {
            if (thumbs[i].src.indexOf(variant.image) !== -1) {
                thumbs[i].classList.add('active');
                break;
            }
        }
    }

    function buildColorOptions() {
        var container = document.getElementById('colorOptions');
        var label = document.getElementById('colorLabel');
        container.innerHTML = '';
        if (colors.length <= 1 && variants.length <= 1) {
            label.style.display = 'none';
            return;
        }
        label.style.display = 'block';
        colors.forEach(function(color) {
            var inStock = colorMap[color].some(function(v) { return v.stock > 0; });
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'color-btn' + (!inStock ? ' out-of-stock' : '');
            btn.setAttribute('data-color', color);
            btn.textContent = color + (!inStock ? ' (Hết hàng)' : '');
            if (!inStock) btn.disabled = true;
            btn.onclick = function() { if (inStock) selectColor(color); };
            container.appendChild(btn);
        });
    }

    function addToCart() {
        if (!selectedVariant) {
            showToast('Vui lòng chọn phiên bản sản phẩm');
            return;
        }
        if (selectedVariant.stock <= 0) {
            showToast('Phiên bản đã hết hàng');
            return;
        }

        fetch('${pageContext.request.contextPath}/cart?action=add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            credentials: 'same-origin',
            body: 'variantId=' + selectedVariant.variantId + '&quantity=1'
        }).then(async function(res) {
            if (res.status === 401) {
                var json = await res.json().catch(function() { return null; });
                if (json && json.redirect) {
                    window.location.href = json.redirect;
                    return;
                }
                throw new Error('Vui lòng đăng nhập để tiếp tục');
            }
            if (!res.ok) {
                var txt = await res.text().catch(function() { return null; });
                var msg = 'Lỗi khi thêm vào giỏ';
                try { msg = JSON.parse(txt).message || txt || msg; } catch(e) { msg = txt || msg; }
                throw new Error(msg);
            }
            return res.json().catch(function() { return null; });
        }).then(function(json) {
            if (json && json.count !== undefined) {
                var el = document.getElementById('cartCount');
                if (el) el.textContent = json.count;
                showToast('Đã thêm vào giỏ hàng');
            }
        }).catch(function(err) {
            console.error(err);
            alert(err.message || 'Lỗi khi thêm vào giỏ');
        });
    }

    function refreshCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var el = document.getElementById('cartCount');
                if (el) el.textContent = data.count;
            }).catch(function() {});
    }

    buildThumbnails();
    buildColorOptions();

    var firstAvailableColor = null;
    colors.forEach(function(c) {
        if (!firstAvailableColor && colorMap[c].some(function(v) { return v.stock > 0; })) {
            firstAvailableColor = c;
        }
    });
    if (firstAvailableColor) {
        selectColor(firstAvailableColor);
    } else {
        updateUI();
    }

    refreshCartCount();
</script>
</body>
</html>
