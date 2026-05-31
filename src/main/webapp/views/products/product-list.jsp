<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sản phẩm - Mobile Store</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-layout.css">
    <style>
        .shop-layout { display: flex; gap: 1.25rem; align-items: flex-start; }
        .filter-sidebar { width: 248px; flex-shrink: 0; position: sticky; top: 88px; }
        .filter-panel {
            background: #f8f9fa;
            border: 1px solid #d1d1d6;
            border-radius: 10px;
            padding: 0.9rem 1rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }
        .filter-panel-title {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            background: #000 !important;
            color: #fff !important;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .filter-section { margin-bottom: 0.75rem; }
        .filter-section:last-of-type { margin-bottom: 0; }
        .filter-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            color: #666;
            margin-bottom: 0.35rem;
        }
        .filter-input {
            width: 100%;
            padding: 0.5rem 0.65rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            font-size: 0.88rem;
            font-family: inherit;
            transition: border-color 0.2s;
        }
        .filter-input:focus {
            outline: none;
            border-color: #1a1a1a;
        }
        .category-list {
            list-style: none;
            max-height: 160px;
            overflow-y: auto;
            padding-right: 2px;
        }
        .category-list::-webkit-scrollbar { width: 3px; }
        .category-list::-webkit-scrollbar-thumb { background: #d1d1d6; border-radius: 3px; }
        .category-item {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.28rem 0;
            cursor: pointer;
            font-size: 0.86rem;
            color: #333;
            line-height: 1.3;
        }
        .category-item input { accent-color: #1a1a1a; width: 14px; height: 14px; flex-shrink: 0; }
        .category-item:hover { color: #000; }
        .price-range-list { max-height: none; overflow: visible; }
        .price-custom-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.35rem;
            margin-top: 0.4rem;
        }
        .price-custom-row input {
            padding: 0.45rem 0.5rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            font-size: 0.8rem;
            width: 100%;
        }
        .price-hint { font-size: 0.72rem; color: #999; margin-top: 0.25rem; line-height: 1.3; }
        .filter-select {
            width: 100%;
            padding: 0.45rem 0.55rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            font-size: 0.86rem;
            font-family: inherit;
            background: #fff;
            cursor: pointer;
        }
        .filter-select:focus { outline: none; border-color: #1a1a1a; }
        .filter-checkbox {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.45rem 0.55rem;
            border: 1px solid #e5e5ea;
            border-radius: 6px;
            background: #fafafa;
            cursor: pointer;
            font-size: 0.86rem;
        }
        .filter-checkbox input { width: 15px; height: 15px; accent-color: #1a1a1a; }
        .filter-actions {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            margin-top: 0.75rem;
            padding-top: 0.75rem;
            border-top: 1px solid #e5e5ea;
        }
        .filter-actions .btn {
            width: 100%;
            text-align: center;
            justify-content: center;
            padding: 0.55rem 0.75rem;
            font-size: 0.88rem;
        }
        .filter-actions .btn-clear {
            width: 100%;
            text-align: center;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            background: #000 !important;
            color: #fff !important;
        }
        .filter-actions .btn-clear:hover { background: #f5f5f7 !important; color: #1a1a1a !important; }
        .shop-main { flex: 1; min-width: 0; }
        .results-bar {
            margin-bottom: 1.25rem;
            padding: 0.85rem 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #666;
            line-height: 1.5;
        }
        .results-bar strong { color: #1a1a1a; }
        .results-count { font-size: 0.95rem; color: #888; margin-bottom: 1rem; }
        .active-tags { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.5rem; }
        .active-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            background: #fff;
            border: 1px solid #e5e5ea;
            border-radius: 20px;
            font-size: 0.8rem;
            color: #333;
        }
        .shop-main .grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        .page-title { padding: 2rem 0; }
        .grid { display: grid; gap: 1.5rem; }
        .card {
            border: 1px solid #e5e5ea;
            border-radius: 14px;
            padding: 1.25rem;
            background: #fff;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .card:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }
        .card img {
            width: 100%;
            height: 220px;
            object-fit: contain;
            display: block;
            margin-bottom: 0.75rem;
        }
        .card .name {
            font-weight: 600;
            font-size: 1.05rem;
            line-height: 1.35;
            margin-bottom: 0.35rem;
        }
        .card .manufacturer { color: #666; font-size: 0.95rem; margin-bottom: 0.65rem; }
        .card .product-info-price { margin-bottom: 0.5rem; }
        .pagination { display: flex; justify-content: center; gap: 0.5rem; margin: 1.5rem 0; }
        .current-price { font-size: 1.25rem; font-weight: 700; color: #1a1a1a; }
        .current-price.sale { color: #ff3b30; }
        .discount-tag { background: #000; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 0.95rem; font-weight: 600; }
        .old-price { font-size: 1rem; color: #86868b; text-decoration: line-through; }
        .btn { display: inline-block; padding: 0.65rem 1rem; border-radius: 8px; background: #000 !important; color: #fff !important; text-decoration: none; font-size: 0.95rem; }
        .btn.secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn.add-to-cart-btn {
            width: 100%;
            text-align: center;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            background: #000 !important;
            color: #fff !important;
        }
        .variant-selector { margin: 0.5rem 0; }
        .variant-selector select {
            width: 100%;
            padding: 0.55rem 0.65rem;
            border: 1px solid #e5e5ea;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .card-stock { color: #888; font-size: 0.95rem; }
        @media (max-width: 1100px) {
            .shop-main .grid { grid-template-columns: repeat(2, 1fr); }
            .card img { height: 200px; }
        }
        @media (max-width: 992px) {
            .shop-layout { flex-direction: column; }
            .filter-sidebar { width: 100%; position: static; }
            .category-list { max-height: 160px; }
        }
        @media (max-width: 768px) {
            .container { padding: 0 12px; }
            .shop-main .grid { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
            .card { padding: 1rem; }
            .card img { height: 160px; }
            .card .name { font-size: 0.95rem; }
        }
        @media (max-width: 480px) {
            .shop-main .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<c:set var="activePage" value="products" scope="request"/>
<body>
<jsp:include page="/views/common/header.jsp"/>

<main class="container shop-container">
    <div class="page-title"><h1>Danh sách sản phẩm</h1></div>

    <div class="shop-layout">
        <aside class="filter-sidebar">
            <div class="filter-panel">
                <div class="filter-panel-title">
                    <span>Bộ lọc</span>
                </div>

                <div class="filter-section">
                    <label class="filter-label" for="search">Tìm kiếm</label>
                    <input type="text" id="search" name="search" class="filter-input"
                           value="${searchKeyword}" placeholder="Tên sản phẩm, hãng...">
                </div>

                <div class="filter-section">
                    <span class="filter-label">Danh mục</span>
                    <ul class="category-list">
                        <li>
                            <label class="category-item">
                                <input type="radio" name="category" value=""
                                       ${empty selectedCategory ? 'checked' : ''}>
                                <span>Tất cả danh mục</span>
                            </label>
                        </li>
                        <c:forEach var="category" items="${categories}">
                            <li>
                                <label class="category-item">
                                    <input type="radio" name="category" value="${category.categoryId}"
                                           ${selectedCategory == category.categoryId ? 'checked' : ''}>
                                    <span>${category.categoryName}</span>
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <div class="filter-section">
                    <span class="filter-label">Khoảng giá</span>
                    <ul class="category-list price-range-list">
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value=""
                                       ${empty selectedPriceRange ? 'checked' : ''}>
                                <span>Tất cả mức giá</span>
                            </label>
                        </li>
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value="under_5m"
                                       ${selectedPriceRange == 'under_5m' ? 'checked' : ''}>
                                <span>Dưới 5 triệu</span>
                            </label>
                        </li>
                        <li>
                            <label class="category-item">
                                <input type="radio" name="priceRange" value="5_10m"
                                       ${selectedPriceRange == '5_10m' ? 'checked' : ''}>
                                <span>5 - 10 triệu</span>
                            </label>
                        </li>
                    </ul>
                    <div class="price-custom-row">
                        <input id="minPrice" type="number" name="minPrice" min="0" step="1000"
                               value="${minPriceInput}" placeholder="Từ">
                        <input id="maxPrice" type="number" name="maxPrice" min="0" step="1000"
                               value="${maxPriceInput}" placeholder="Đến">
                    </div>
                    <p class="price-hint">Nhập giá (VNĐ) nếu cần lọc chi tiết hơn.</p>
                </div>

                <div class="filter-section">
                    <label class="filter-label" for="sort">Sắp xếp theo giá</label>
                    <select id="sort" name="sort" class="filter-select">
                        <option value="" ${empty selectedSort ? 'selected' : ''}>Mặc định (mới nhất)</option>
                        <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến cao</option>
                        <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Giá: Cao đến thấp</option>
                    </select>
                </div>

                <div class="filter-section">
                    <label class="filter-checkbox" for="favoritesOnly">
                        <input id="favoritesOnly" type="checkbox" name="favorites" value="1"
                               ${favoritesOnly ? 'checked' : ''}>
                        <span>Chỉ xem yêu thích</span>
                    </label>
                </div>

                <div class="filter-actions">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-clear">Xóa bộ lọc</a>
                </div>
            </div>
        </aside>

        <div class="shop-main" id="shop-main-content">
            <jsp:include page="/views/products/shop-main-content.jsp"/>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp"/>

<div id="toast-container"></div>
<script>
    const isFavoritesFilter = ${favoritesOnly};
    const contextPath = '${pageContext.request.contextPath}';

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

    function showLoading(el) {
        el.style.opacity = '0.5';
        el.style.pointerEvents = 'none';
    }

    function hideLoading(el) {
        el.style.opacity = '1';
        el.style.pointerEvents = 'auto';
    }

    function debounce(fn, delay) {
        let timeout;
        return function(...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => fn.apply(this, args), delay);
        };
    }

    function getFilterParams() {
        const params = new URLSearchParams();
        const search = document.getElementById('search').value.trim();
        if (search) params.append('search', search);

        const category = document.querySelector('input[name="category"]:checked');
        if (category && category.value) params.append('category', category.value);

        const priceRange = document.querySelector('input[name="priceRange"]:checked');
        if (priceRange && priceRange.value) params.append('priceRange', priceRange.value);

        const minPrice = document.getElementById('minPrice')?.value.trim();
        if (minPrice) params.append('minPrice', minPrice);

        const maxPrice = document.getElementById('maxPrice')?.value.trim();
        if (maxPrice) params.append('maxPrice', maxPrice);

        const sort = document.getElementById('sort')?.value;
        if (sort) params.append('sort', sort);

        const favorites = document.getElementById('favoritesOnly');
        if (favorites?.checked) params.append('favorites', '1');

        return params.toString();
    }

    function applyFilters() {
        const shopMain = document.getElementById('shop-main-content');
        if (!shopMain) return;

        showLoading(shopMain);

        const params = getFilterParams();
        const url = contextPath + '/products' + (params ? '?' + params : '');

        fetch(url, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(r => r.text())
        .then(html => {
            shopMain.innerHTML = html;
            hideLoading(shopMain);
            rebindCardEvents();
        })
        .catch(err => {
            hideLoading(shopMain);
            showToast('Không thể tải dữ liệu. Vui lòng thử lại.');
        });
    }

    function clearFilters() {
        document.getElementById('search').value = '';
        const allRadios = document.querySelectorAll('.filter-panel input[type="radio"]');
        allRadios.forEach(r => {
            if (r.value === '' || r.name === 'category' || r.name === 'priceRange') {
                if (r.value === '') r.checked = true;
            } else {
                r.checked = false;
            }
        });
        const minPriceInput = document.getElementById('minPrice');
        if (minPriceInput) minPriceInput.value = '';
        const maxPriceInput = document.getElementById('maxPrice');
        if (maxPriceInput) maxPriceInput.value = '';
        const sortSelect = document.getElementById('sort');
        if (sortSelect) sortSelect.value = '';
        const favoritesCheck = document.getElementById('favoritesOnly');
        if (favoritesCheck) favoritesCheck.checked = false;

        applyFilters();
    }

    function rebindCardEvents() {
        document.querySelectorAll('.wishlist-btn').forEach(btn => {
            btn.replaceWith(btn.cloneNode(true));
        });
        document.querySelectorAll('.add-btn').forEach(btn => {
            btn.replaceWith(btn.cloneNode(true));
        });

        document.querySelectorAll('.wishlist-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                const productId = this.getAttribute('data-id');
                const currentBtn = this;

                fetch(contextPath + '/api/toggle-like', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'productId=' + productId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        if (data.action === 'liked') {
                            currentBtn.classList.add('active');
                        } else {
                            currentBtn.classList.remove('active');
                            if (isFavoritesFilter) {
                                const card = currentBtn.closest('.card');
                                if (card) card.remove();
                            }
                        }
                        showToast(data.message);
                    } else {
                        showToast(data.message || 'Có lỗi xảy ra!');
                        if (data.message && data.message.includes('đăng nhập')) {
                            setTimeout(() => { window.location.href = contextPath + '/login'; }, 1500);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Không thể kết nối đến máy chủ.');
                });
            });
        });

        document.querySelectorAll('.add-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const card = this.closest('.card');
                const select = card.querySelector('.variant-select');
                if (!select) {
                    showToast('Không có phiên bản nào cho sản phẩm này');
                    return;
                }
                const variantId = select.value;
                const selectedOption = select.options[select.selectedIndex];
                const stock = parseInt(selectedOption.getAttribute('data-stock') || '0', 10);

                if (stock <= 0) {
                    showToast('Phiên bản đã hết hàng');
                    return;
                }

                fetch(contextPath + '/cart?action=add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin',
                    body: 'variantId=' + encodeURIComponent(variantId) + '&quantity=1'
                }).then(async res => {
                    if (res.status === 401) {
                        const json = await res.json().catch(() => null);
                        if (json && json.redirect) {
                            window.location.href = json.redirect;
                            return;
                        }
                        throw new Error('Vui lòng đăng nhập để tiếp tục');
                    }
                    if (!res.ok) {
                        const txt = await res.text().catch(() => null);
                        let msg = 'Lỗi khi thêm vào giỏ';
                        try { msg = JSON.parse(txt).message || txt || msg; } catch (e) { msg = txt || msg; }
                        throw new Error(msg);
                    }
                    return res.json().catch(() => null);
                }).then(json => {
                    if (json && json.count !== undefined) {
                        const el = document.getElementById('cartCount');
                        if (el) el.textContent = json.count;
                        showToast('Đã thêm vào giỏ hàng');
                    } else {
                        refreshCartCount();
                        showToast('Đã thêm vào giỏ hàng');
                    }
                }).catch(err => {
                    console.error('Add to cart failed', err);
                    alert(err.message || 'Lỗi khi thêm vào giỏ');
                });
            });
        });
    }

    document.addEventListener('DOMContentLoaded', () => {
        document.getElementById('search')?.addEventListener('input', debounce(applyFilters, 400));

        ['minPrice', 'maxPrice'].forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.addEventListener('blur', applyFilters);
                el.addEventListener('keydown', e => {
                    if (e.key === 'Enter') { e.preventDefault(); el.blur(); }
                });
            }
        });

        document.querySelectorAll('.filter-panel input[type="radio"]').forEach(radio => {
            radio.addEventListener('change', applyFilters);
        });

        document.getElementById('sort')?.addEventListener('change', applyFilters);

        document.getElementById('favoritesOnly')?.addEventListener('change', applyFilters);

        const clearBtn = document.querySelector('.btn-clear');
        if (clearBtn) {
            clearBtn.addEventListener('click', e => {
                e.preventDefault();
                clearFilters();
            });
        }

        rebindCardEvents();
    });

    function refreshCartCount() {
        fetch(contextPath + '/cart/count')
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
