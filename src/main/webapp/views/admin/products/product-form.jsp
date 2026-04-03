```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm'} - Trang quản lý</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #1a1a1a; background-color: #f5f5f7; }
        .admin-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1a1a1a; color: #ffffff; padding: 2rem 0; position: fixed; height: 100vh; overflow-y: auto; }
        .sidebar-header { padding: 0 1.5rem 2rem; border-bottom: 1px solid #333; margin-bottom: 1rem; }
        .sidebar-header h2 { font-size: 1.25rem; font-weight: 600; color: #ffffff; }
        .sidebar-header span { font-size: 0.875rem; color: #888; }
        .sidebar-nav { list-style: none; }
        .sidebar-nav li { margin: 0.25rem 0; }
        .sidebar-nav a { display: flex; align-items: center; padding: 0.875rem 1.5rem; color: #ccc; text-decoration: none; transition: all 0.2s; font-size: 0.95rem; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background: #333; color: #ffffff; }
        .sidebar-nav a.active { border-left: 3px solid #0071e3; }
        .sidebar-nav .icon { margin-right: 0.75rem; font-size: 1.1rem; }
        .main-content { flex: 1; margin-left: 260px; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-header h1 { font-size: 1.75rem; font-weight: 600; color: #1a1a1a; }
        .breadcrumb { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 1rem; font-size: 0.9rem; }
        .breadcrumb a { color: #0071e3; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #888; }
        .form-card { background: #ffffff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; max-width: 950px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; padding-bottom: 0.75rem; border-bottom: 2px solid #e5e5ea; }
        .section-header h3 { font-size: 1.1rem; font-weight: 600; color: #1a1a1a; }
        .section-header h3 .badge { font-size: 0.75rem; background: #0071e3; color: #fff; padding: 2px 8px; border-radius: 12px; margin-left: 6px; vertical-align: middle; }
        .form-group { margin-bottom: 1.5rem; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #1a1a1a; font-size: 0.95rem; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .form-control::placeholder { color: #aaa; }
        .form-control.is-invalid { border-color: #ff3b30; }
        .form-control.is-valid { border-color: #34c759; }
        textarea.form-control { resize: vertical; min-height: 100px; }
        select.form-control { cursor: pointer; background: #ffffff url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L1 3h10z'/%3E%3C/svg%3E") no-repeat right 1rem center; -webkit-appearance: none; -moz-appearance: none; appearance: none; padding-right: 2.5rem; }
        .invalid-feedback { display: none; color: #ff3b30; font-size: 0.85rem; margin-top: 0.375rem; }
        .form-control.is-invalid + .invalid-feedback { display: block; }
        .char-counter { font-size: 0.8rem; color: #888; text-align: right; margin-top: 0.25rem; }
        .char-counter.warning { color: #ff9500; }
        .char-counter.danger { color: #ff3b30; }
        .help-text { font-size: 0.85rem; color: #888; margin-top: 0.375rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #e5e5ea; }
        .btn { display: inline-flex; align-items: center; justify-content: center; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 0.95rem; font-weight: 500; text-decoration: none; cursor: pointer; transition: all 0.2s; border: none; font-family: inherit; }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .btn-primary { background: #0071e3; color: #ffffff; }
        .btn-primary:hover:not(:disabled) { background: #0077ed; }
        .btn-secondary { background: #e5e5ea; color: #1a1a1a; }
        .btn-secondary:hover { background: #d1d1d6; }
        .btn-add { background: #34c759; color: #fff; padding: 0.5rem 1rem; font-size: 0.875rem; }
        .btn-add:hover { background: #2db84d; }
        .btn-danger { background: #ff3b30; color: #fff; padding: 0.5rem 1rem; font-size: 0.875rem; }
        .btn-danger:hover { background: #e0352b; }
        .spinner { display: none; width: 18px; height: 18px; border: 2px solid #ffffff; border-top-color: transparent; border-radius: 50%; animation: spin 0.8s linear infinite; margin-right: 6px; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .btn-primary.loading .spinner { display: inline-block; }
        .alert { padding: 1rem 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-error { background: #fdecea; color: #c62828; border: 1px solid #f5c6cb; }
        .alert-error ul { margin: 0.5rem 0 0 1.5rem; padding: 0; }
        .alert-info { background: #e8f4fd; color: #0c5460; border: 1px solid #bee5eb; }
        .variant-list { margin-top: 1rem; }
        .variant-card { background: #f9f9fb; border: 1px solid #e5e5ea; border-radius: 10px; padding: 1.25rem; margin-bottom: 1rem; position: relative; transition: box-shadow 0.2s; }
        .variant-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .variant-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .variant-card-title { font-weight: 600; font-size: 0.95rem; color: #1a1a1a; display: flex; align-items: center; gap: 8px; }
        .variant-card-title .variant-num { background: #0071e3; color: #fff; font-size: 0.75rem; padding: 2px 8px; border-radius: 12px; }
        .variant-row { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 1rem; margin-bottom: 0.75rem; }
        .variant-row:last-child { margin-bottom: 0; }
        .variant-field { }
        .variant-field label { display: block; font-size: 0.8rem; font-weight: 500; color: #666; margin-bottom: 0.25rem; }
        .variant-field input, .variant-field select { width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #d1d1d6; border-radius: 6px; font-size: 0.9rem; font-family: inherit; }
        .variant-field input:focus, .variant-field select:focus { outline: none; border-color: #0071e3; }
        .variant-image-section { margin-top: 0.75rem; display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; }
        .variant-image-thumb { width: 72px; height: 72px; border-radius: 8px; object-fit: cover; border: 1px solid #e5e5ea; background: #f0f0f0; }
        .variant-delete-btn { width: 28px; height: 28px; border-radius: 50%; background: #ff3b30; color: white; border: 2px solid #fff; cursor: pointer; font-size: 16px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(0,0,0,0.15); flex-shrink: 0; }
        .variant-delete-btn:hover { background: #e0352b; }
        .empty-variants { text-align: center; padding: 2rem; color: #888; background: #f9f9fb; border-radius: 10px; border: 2px dashed #e5e5ea; }
        .empty-variants .icon { font-size: 2rem; margin-bottom: 0.5rem; display: block; }
        .empty-variants p { margin-bottom: 1rem; }
        .client-error-box { margin-bottom: 1.5rem; }
        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; }
            .variant-row { grid-template-columns: 1fr 1fr; }
            .sidebar { display: none; }
            .main-content { margin-left: 0; }
        }
        @media (max-width: 480px) {
            .variant-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="admin-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>Mobile Store</h2>
            <span>Trang quản lý</span>
        </div>
        <nav>
            <ul class="sidebar-nav">
                <li><a href="${pageContext.request.contextPath}/"><span class="icon">&#127968;</span> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/products" class="active"><span class="icon">&#128230;</span> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/orders"><span class="icon">&#129534;</span> Đơn hàng</a></li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
            <span>/</span>
            <span>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</span>
        </div>

        <div class="page-header">
            <h1>${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <strong>&#10060; Lỗi:</strong>
                <c:choose>
                    <c:when test="${not empty errors}">
                        <ul>
                            <c:forEach var="err" items="${errors}">
                                <li>${err}</li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        ${error}
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="client-error-box" id="clientErrorBox" style="display:none;">
            <div class="alert alert-error">
                <strong>&#10060; Vui lòng sửa các lỗi sau:</strong>
                <ul id="clientErrorList"></ul>
            </div>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/products/${isEdit ? 'edit' : 'add'}"
                  method="post"
                  enctype="multipart/form-data"
                  id="productForm"
                  novalidate>

                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${product.productId}">
                </c:if>

                <div class="section-header">
                    <h3>Thông tin sản phẩm</h3>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="productName">Tên sản phẩm <span class="required">*</span></label>
                        <input type="text" id="productName" name="productName" class="form-control"
                               placeholder="VD: iPhone 15 Pro Max"
                               value="${product.productName}" maxlength="255" required>
                        <div class="invalid-feedback" id="productNameError">Tên sản phẩm không hợp lệ</div>
                        <div class="char-counter"><span id="productNameCount">0</span>/255</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="manufacturer">Nhà sản xuất <span class="required">*</span></label>
                        <input type="text" id="manufacturer" name="manufacturer" class="form-control"
                               placeholder="VD: Apple, Samsung, Xiaomi..."
                               value="${product.manufacturer}" maxlength="255" required>
                        <div class="invalid-feedback" id="manufacturerError">Nhà sản xuất không hợp lệ</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="categoryId">Danh mục <span class="required">*</span></label>
                        <select id="categoryId" name="categoryId" class="form-control" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}"
                                    ${product.category.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback" id="categoryError">Vui lòng chọn danh mục</div>
                        <input type="text" id="newCategoryName" name="newCategoryName" class="form-control"
                               placeholder="Hoặc nhập tên danh mục mới"
                               maxlength="255" style="margin-top:0.5rem;">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="productCondition">Tình trạng <span class="required">*</span></label>
                        <select id="productCondition" name="productCondition" class="form-control" required>
                            <option value="Mới" ${product.productCondition == 'Mới' || empty product.productCondition ? 'selected' : ''}>Mới</option>
                            <option value="Đã qua sử dụng" ${product.productCondition == 'Đã qua sử dụng' ? 'selected' : ''}>Đã qua sử dụng</option>
                            <option value="Tân trang" ${product.productCondition == 'Tân trang' ? 'selected' : ''}>Tân trang</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="discount">Giảm giá (%)</label>
                        <input type="number" id="discount" name="discount" class="form-control"
                               placeholder="VD: 10, 20..."
                               min="0" max="100"
                               value="${product.discount != null ? product.discount : 0}">
                        <div class="invalid-feedback" id="discountError">Giảm giá phải từ 0 - 100%</div>
                        <p class="help-text">% giảm giá áp dụng cho tất cả phiên bản</p>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="productInfo">Mô tả sản phẩm</label>
                        <textarea id="productInfo" name="productInfo" class="form-control"
                                  placeholder="Nhập mô tả chi tiết về sản phẩm..."
                                  maxlength="1000">${product.productInfo}</textarea>
                        <div class="char-counter"><span id="productInfoCount">0</span>/1000</div>
                    </div>
                </div>

                <div class="section-header" style="margin-top:2rem;">
                    <h3>Phiên bản sản phẩm <span class="badge" id="variantCount">0</span></h3>
                    <button type="button" class="btn btn-add" onclick="addVariant()">
                        &#43; Thêm phiên bản
                    </button>
                </div>

                <div id="variantList" class="variant-list">
                    <div class="empty-variants" id="emptyVariantsMsg">
                        <span class="icon">&#128230;</span>
                        <p>Chưa có phiên bản nào. Nhấn <strong>"Thêm phiên bản"</strong> để bắt đầu.</p>
                    </div>
                </div>

                <c:if test="${isEdit && not empty product.variants}">
                    <c:forEach var="v" items="${product.variants}" varStatus="st">
                    </c:forEach>
                </c:if>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <span class="spinner"></span>
                        <span class="btn-text">${isEdit ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm'}</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    (function() {
        var variantIndex = 0;
        var existingVariants = [];
        <c:if test="${isEdit && not empty product.variants}">
        <c:forEach var="v" items="${product.variants}" varStatus="st">
        existingVariants.push({
            index: ${st.index},
            variantId: '${v.variantId}',
            color: '${v.color}',
            storage: '${v.storage}',
            price: '${v.price}',
            quantityInStock: '${v.quantityInStock}',
            variantImage: '${v.variantImage}'
        });
        </c:forEach>
        </c:if>

        var form = document.getElementById('productForm');
        var submitBtn = document.getElementById('submitBtn');
        var clientErrorBox = document.getElementById('clientErrorBox');
        var clientErrorList = document.getElementById('clientErrorList');
        var emptyMsg = document.getElementById('emptyVariantsMsg');
        var variantCountEl = document.getElementById('variantCount');

        function escHtml(str) {
            if (!str) return '';
            return str.toString()
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function countVariants() {
            var cards = document.querySelectorAll('.variant-card');
            variantCountEl.textContent = cards.length;
            if (emptyMsg) {
                emptyMsg.style.display = cards.length === 0 ? 'block' : 'none';
            }
        }

        function reindexVariants() {
            const variants = document.querySelectorAll('.variant-card');

            variants.forEach((variant, index) => {
                variant.id = 'variantCard_' + index;

                const deleteBtn = variant.querySelector('.variant-delete-btn');
                if (deleteBtn) {
                    deleteBtn.setAttribute('onclick', 'removeVariant(' + index + ')');
                }

                const variantNum = variant.querySelector('.variant-num');
                if (variantNum) {
                    variantNum.textContent = 'Phiên bản #' + (index + 1);
                }

                variant.querySelectorAll('input, select').forEach(input => {
                    if (input.name) {
                        input.name = input.name.replace(/_\d+$/, '_' + index);
                        input.id = input.id ? input.id.replace(/_\d+$/, '_' + index) : '';
                    }
                });

                variant.querySelectorAll('label').forEach(label => {
                    if (label.getAttribute('for')) {
                        label.setAttribute('for', label.getAttribute('for').replace(/_\d+$/, '_' + index));
                    }
                });

                const thumb = variant.querySelector('.variant-image-thumb[id]');
                if (thumb) {
                    thumb.id = 'variantThumb_' + index;
                }

                const fileBtn = variant.querySelector('input[type="button"]');
                if (fileBtn) {
                    fileBtn.setAttribute('onclick', "document.getElementById('variantImage_" + index + "').click()");
                }

                const fileInput = variant.querySelector('input[type="file"]');
                if (fileInput) {
                    fileInput.setAttribute('onchange', 'previewVariantImage(' + index + ', this)');
                }
            });

            variantIndex = variants.length;
        }

        function addVariant(data) {
            data = data || {};
            var idx = variantIndex++;
            var container = document.getElementById('variantList');
            if (emptyMsg) emptyMsg.style.display = 'none';

            var card = document.createElement('div');
            card.className = 'variant-card';
            card.id = 'variantCard_' + idx;

            var imageHtml = '';
            if (data.variantImage) {
                imageHtml = '<img src="' + contextPath + '/' + data.variantImage + '" class="variant-image-thumb" alt="Variant Image" id="variantThumb_' + idx + '">';
            } else {
                imageHtml = '<div class="variant-image-thumb" style="display:flex;align-items:center;justify-content:center;color:#aaa;font-size:0.7rem;text-align:center;padding:4px;">Chưa có ảnh</div>' +
                    '<img class="variant-image-thumb" id="variantThumb_' + idx + '" style="display:none;">';
            }

            card.innerHTML =
                '<div class="variant-card-header">' +
                '<div class="variant-card-title">' +
                '<span class="variant-num">Phiên bản #' + (idx + 1) + '</span>' +
                '</div>' +
                '<button type="button" class="variant-delete-btn" onclick="removeVariant(' + idx + ')" title="Xóa phiên bản">&#215;</button>' +
                '</div>' +
                '<div class="variant-card-body">' +
                '<div class="variant-row">' +
                '<div class="variant-field">' +
                '<label for="variantColor_' + idx + '">Màu sắc <span style="color:#ff3b30;">*</span></label>' +
                '<input type="text" id="variantColor_' + idx + '" name="variantColor_' + idx + '" ' +
                'placeholder="VD: Đen, Trắng, Xanh..." value="' + escHtml(data.color || '') + '" required>' +
                '</div>' +
                '<div class="variant-field">' +
                '<label for="variantStorage_' + idx + '">Dung lượng <span style="color:#ff3b30;">*</span></label>' +
                '<input type="text" id="variantStorage_' + idx + '" name="variantStorage_' + idx + '" ' +
                'placeholder="VD: 128GB, 256GB..." value="' + escHtml(data.storage || '') + '" required>' +
                '</div>' +
                '<div class="variant-field">' +
                '<label for="variantPrice_' + idx + '">Giá (VNĐ) <span style="color:#ff3b30;">*</span></label>' +
                '<input type="number" id="variantPrice_' + idx + '" name="variantPrice_' + idx + '" ' +
                'placeholder="VD: 25000000" min="0" max="999999999" step="1000" ' +
                'value="' + escHtml(data.price || '') + '" required>' +
                '</div>' +
                '<div class="variant-field">' +
                '<label for="variantQuantity_' + idx + '">Số lượng tồn kho <span style="color:#ff3b30;">*</span></label>' +
                '<input type="number" id="variantQuantity_' + idx + '" name="variantQuantity_' + idx + '" ' +
                'placeholder="VD: 50" min="0" max="99999" ' +
                'value="' + escHtml(data.quantityInStock || '') + '" required>' +
                '</div>' +
                '</div>' +
                '<div class="variant-image-section">' +
                imageHtml +
                '<div class="variant-image-input-wrap">' +
                '<input type="file" id="variantImage_' + idx + '" name="variantImage_' + idx + '" ' +
                'class="file-input-hidden" accept=".jpg,.jpeg,.png,.gif,.webp" ' +
                'onchange="previewVariantImage(' + idx + ', this)">' +
                '<input type="button" class="form-control" style="cursor:pointer;background:#f5f5f7;font-size:0.875rem;" ' +
                'value="' + (data.variantImage ? '&#8635; Thay đổi ảnh' : 'Chọn ảnh phiên bản') + '" ' +
                'onclick="document.getElementById(\'variantImage_' + idx + '\').click()">' +
                '</div>' +
                '</div>' +
                '</div>';

            if (data.variantId) {
                var hid = document.createElement('input');
                hid.type = 'hidden';
                hid.name = 'variantId_' + idx;
                hid.value = data.variantId;
                card.appendChild(hid);
            }

            container.appendChild(card);
            countVariants();
        }

        function removeVariant(idx) {
            var card = document.getElementById('variantCard_' + idx);
            if (card) {
                card.style.transition = 'opacity 0.3s';
                card.style.opacity = '0';
                setTimeout(function() {
                    card.remove();
                    reindexVariants();
                    countVariants();
                }, 250);
            }
        }

        window.addVariant = addVariant;
        window.removeVariant = removeVariant;
        window.reindexVariants = reindexVariants;

        function previewVariantImage(idx, input) {
            if (input.files && input.files[0]) {
                var file = input.files[0];

                if (!file.type.match(/^image\/(jpeg|jpg|png|gif|webp)$/)) {
                    alert('Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WebP)');
                    input.value = '';
                    return;
                }

                if (file.size > 10 * 1024 * 1024) {
                    alert('File ảnh phải nhỏ hơn 10MB');
                    input.value = '';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    var thumb = document.getElementById('variantThumb_' + idx);
                    if (thumb) {
                        thumb.src = e.target.result;
                        thumb.style.display = 'block';

                        var placeholder = thumb.parentNode.querySelector('.variant-image-thumb:not([id])');
                        if (placeholder) {
                            placeholder.style.display = 'none';
                        }
                    }

                    var btn = input.parentNode.querySelector('input[type="button"]');
                    if (btn) {
                        btn.value = '🔄 Thay đổi ảnh';
                    }
                };
                reader.readAsDataURL(file);
            }
        }

        window.previewVariantImage = previewVariantImage;

        function setupCharCounter(inputId, counterId, maxLength) {
            var input = document.getElementById(inputId);
            var counter = document.getElementById(counterId);
            if (input && counter) {
                function updateCount() {
                    var length = input.value.length;
                    counter.textContent = length;
                    counter.parentNode.className = 'char-counter';
                    if (length > maxLength * 0.8) {
                        counter.parentNode.className += ' warning';
                    }
                    if (length >= maxLength) {
                        counter.parentNode.className += ' danger';
                    }
                }
                input.addEventListener('input', updateCount);
                updateCount();
            }
        }

        setupCharCounter('productName', 'productNameCount', 255);
        setupCharCounter('productInfo', 'productInfoCount', 1000);

        if (existingVariants.length > 0) {
            existingVariants.forEach(function(variant) {
                addVariant(variant);
            });
        }

        form.addEventListener('submit', function(e) {
            e.preventDefault();

            var errors = [];

            var productName = document.getElementById('productName').value.trim();
            if (!productName) {
                errors.push('Tên sản phẩm không được để trống');
            }

            var manufacturer = document.getElementById('manufacturer').value.trim();
            if (!manufacturer) {
                errors.push('Nhà sản xuất không được để trống');
            }

            var categoryId = document.getElementById('categoryId').value;
            var newCategoryName = document.getElementById('newCategoryName').value.trim();
            if (!categoryId && !newCategoryName) {
                errors.push('Vui lòng chọn danh mục hoặc nhập danh mục mới');
            }

            var variants = document.querySelectorAll('.variant-card');
            if (variants.length === 0) {
                errors.push('Phải có ít nhất 1 phiên bản sản phẩm');
            }

            variants.forEach(function(variant, index) {
                var color = variant.querySelector('[name^="variantColor_"]').value.trim();
                var storage = variant.querySelector('[name^="variantStorage_"]').value.trim();
                var price = variant.querySelector('[name^="variantPrice_"]').value.trim();
                var quantity = variant.querySelector('[name^="variantQuantity_"]').value.trim();

                if (!color) {
                    errors.push('Phiên bản #' + (index + 1) + ': Màu sắc không được để trống');
                }
                if (!storage) {
                    errors.push('Phiên bản #' + (index + 1) + ': Dung lượng không được để trống');
                }
                if (!price || isNaN(price) || parseFloat(price) < 0) {
                    errors.push('Phiên bản #' + (index + 1) + ': Giá phải là số hợp lệ >= 0');
                }
                if (!quantity || isNaN(quantity) || parseInt(quantity) < 0) {
                    errors.push('Phiên bản #' + (index + 1) + ': Số lượng phải là số nguyên >= 0');
                }
            });

            if (errors.length > 0) {
                clientErrorList.innerHTML = '';
                errors.forEach(function(error) {
                    var li = document.createElement('li');
                    li.textContent = error;
                    clientErrorList.appendChild(li);
                });
                clientErrorBox.style.display = 'block';
                clientErrorBox.scrollIntoView({ behavior: 'smooth' });
                return;
            }

            clientErrorBox.style.display = 'none';

            const fileInputs = document.querySelectorAll('input[type="file"]');
            console.log('Total file inputs found:', fileInputs.length);

            let disabledCount = 0;
            fileInputs.forEach(input => {
                if (!input.files || input.files.length === 0) {
                    input.disabled = true;
                    disabledCount++;
                    console.log('Disabled empty file input:', input.name);
                } else {
                    console.log('Active file input:', input.name, 'size:', input.files[0].size);
                }
            });

            console.log('Disabled ' + disabledCount + ' empty file inputs');

            submitBtn.classList.add('loading');
            submitBtn.disabled = true;

            setTimeout(() => {
                form.submit();
            }, 100);
        });

    })();
</script>
