<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Thanh toán - Mobile Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-layout.css">
    <style>
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
            align-items: start;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.25rem;
            color: #1a1a1a;
        }

        .form-card {
            background: #ffffff;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
            font-size: 0.95rem;
        }

        .form-label .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d1d6;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #0071e3;
            box-shadow: 0 0 0 3px rgba(0, 113, 227, 0.1);
        }

        .form-control.error {
            border-color: #dc3545;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 0.375rem;
            display: none;
        }

        .form-group.error .error-message {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        textarea.form-control.error {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }

        .order-summary {
            background: #ffffff;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            padding: 1.5rem;
            position: sticky;
            top: 100px;
        }

        .order-summary-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e5ea;
        }

        .order-item {
            display: flex;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item:last-of-type {
            border-bottom: none;
        }

        .order-item-image {
            width: 60px;
            height: 60px;
            object-fit: contain;
            border-radius: 8px;
            background: #f5f5f7;
            flex-shrink: 0;
        }

        .order-item-info {
            flex: 1;
            min-width: 0;
        }

        .order-item-name {
            font-weight: 500;
            font-size: 0.9rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .order-item-qty {
            font-size: 0.85rem;
            color: #666;
        }

        .order-item-price {
            font-weight: 600;
            font-size: 0.9rem;
            text-align: right;
            flex-shrink: 0;
        }

        .order-totals {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e5ea;
        }

        .order-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .order-total-row.final {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e5ea;
            font-size: 1.2rem;
            font-weight: 700;
        }

        .order-total-row .amount {
            color: #0071e3;
            font-size: 1.5rem;
        }

        .right {
            text-align: right;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            background: #111 !important;
            color: #fff !important;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1rem;
            font-weight: 500;
            width: 100%;
            text-align: center;
            transition: opacity 0.2s;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-secondary {
            background: #e5e5ea !important;
            color: #1a1a1a !important;
        }

        .btn-vnpay {
            background: #0066cc !important;
        }

        .btn-group {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .btn-group .btn {
            flex: 1;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 1.5rem;
            color: #666;
            text-decoration: none;
            font-size: 0.95rem;
        }

        .back-link:hover {
            color: #1a1a1a;
        }

        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-cart-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .payment-option {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            border: 2px solid #e5e5ea;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 0.75rem;
            transition: all 0.2s;
        }

        .payment-option:hover {
            border-color: #ccc;
        }

        .payment-option.selected {
            border-color: #0071e3;
            background: #f0f7ff;
        }

        .payment-option input {
            width: 18px;
            height: 18px;
        }

        .payment-option-content div:first-child {
            font-weight: 600;
        }

        .payment-option-content div:last-child {
            font-size: 0.85rem;
            color: #666;
        }

        @media (max-width: 768px) {
            .checkout-grid {
                grid-template-columns: 1fr;
            }

            .order-summary {
                position: static;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 0 12px;
            }

            table {
                font-size: 14px;
            }

            th, td {
                padding: 8px 4px;
            }

            .btn {
                padding: 10px 16px;
                font-size: 14px;
            }

            h1 {
                font-size: 1.5rem !important;
            }
        }
    </style>
</head>
<c:set var="activePage" value="cart" scope="request"/>
<body>
<jsp:include page="/views/common/header.jsp"/>

<main class="container">
    <div style="padding: 2rem 0;">
        <a href="${pageContext.request.contextPath}/cart" class="back-link">← Quay lại giỏ hàng</a>
        <h1 style="font-size: 2rem; font-weight: 600; margin-bottom: 2rem;">Thanh toán</h1>

        <c:if test="${not empty error}">
            <div style="color:#c62828; background: #fdecea; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; border: 1px solid #f5c6cb;">
                <strong>Lỗi:</strong> ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h2 style="font-size: 1.5rem; margin-bottom: 0.5rem;">Giỏ hàng trống</h2>
                    <p style="color: #666; margin-bottom: 1.5rem;">Không có sản phẩm nào để thanh toán.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/products"
                       style="width: auto; display: inline-block;">Tiếp tục mua sắm</a>
                </div>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm" novalidate>
                    <div class="checkout-grid">
                        <div class="checkout-form">
                            <h2 class="section-title">Thông tin giao hàng</h2>
                            <div class="form-card">
                                <div class="form-group" id="receiverNameGroup">
                                    <label class="form-label" for="receiverName">
                                        Người nhận <span class="required">*</span>
                                    </label>
                                    <input type="text" id="receiverName" name="receiverName" class="form-control"
                                           required minlength="2" maxlength="100"
                                           placeholder="Nhập họ tên người nhận"
                                           value="${sessionScope.user != null ? sessionScope.user.username : ''}">
                                    <div class="error-message" id="receiverNameError">Vui lòng nhập tên người nhận</div>
                                </div>

                                <div class="form-group" id="phoneGroup">
                                    <label class="form-label" for="phone">
                                        Số điện thoại <span class="required">*</span>
                                    </label>
                                    <input type="tel" id="phone" name="phone" class="form-control"
                                           required pattern="[0-9]{10,11}"
                                           placeholder="Nhập số điện thoại"
                                           value="${sessionScope.user != null && sessionScope.user.customerPhone != null ? sessionScope.user.customerPhone : ''}">
                                    <div class="error-message" id="phoneError">Vui lòng nhập số điện thoại hợp lệ</div>
                                </div>

                                <div class="form-group" id="emailGroup">
                                    <label class="form-label" for="email">
                                        Email <span class="required">*</span>
                                    </label>
                                    <input type="email" id="email" name="email" class="form-control"
                                           required
                                           placeholder="Nhập địa chỉ email"
                                           value="${sessionScope.user != null ? sessionScope.user.email : ''}">
                                    <div class="error-message" id="emailError">Vui lòng nhập email hợp lệ</div>
                                </div>

                                <div class="form-group" id="addressGroup">
                                    <label class="form-label" for="streetAddressInput">
                                        <span id="addressLabel">Địa chỉ nhận hàng <span class="required">*</span></span>
                                    </label>
                                    <div class="address-dropdowns" style="display:grid; gap:12px; margin-bottom:12px;">
                                        <div>
                                            <select id="provinceSelect" class="form-control" style="background-image:none;">
                                                <option value="">-- Chọn Tỉnh / Thành phố --</option>
                                            </select>
                                        </div>
                                        <div>
                                            <select id="districtSelect" class="form-control" disabled style="background-image:none;">
                                                <option value="">-- Chọn Quận / Huyện --</option>
                                            </select>
                                        </div>
                                        <div>
                                            <select id="wardSelect" class="form-control" disabled style="background-image:none;">
                                                <option value="">-- Chọn Phường / Xã --</option>
                                            </select>
                                        </div>
                                    </div>
                                    <input type="hidden" id="districtIdField" name="districtId" value="${sessionScope.user.districtId}"/>
                                    <input type="hidden" id="wardCodeField" name="wardCode" value="${sessionScope.user.wardCode}"/>
                                    <input type="hidden" id="streetAddressField" name="streetAddress" value=""/>
                                    <input type="text" id="streetAddressInput" class="form-control"
                                           placeholder="Số nhà, tên đường" maxlength="255">
                                    <textarea id="shippingAddress" name="shippingAddress" class="form-control" style="margin-top:12px;"
                                              placeholder="Địa chỉ đầy đủ" readonly></textarea>
                                    <div class="error-message" id="addressError">Vui lòng nhập số nhà, tên đường (tối thiểu 5 ký tự)</div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="note">
                                        Ghi chú đơn hàng
                                    </label>
                                    <textarea id="note" name="note" class="form-control"
                                              placeholder="Ghi chú thêm cho đơn hàng (không bắt buộc)"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="order-summary">
                            <h3 class="order-summary-title">Đơn hàng của bạn</h3>

                            <c:set var="total" value="0"/>
                            <c:forEach var="item" items="${cartItems}">
                                <c:set var="itemDiscount" value="${item.product != null ? item.product.discount : 0}"/>
                                <c:set var="itemPrice" value="${item.variant != null ? item.variant.price : item.product.displayPrice}"/>
                                <c:set var="itemImg" value="${item.variant != null ? item.variant.variantImage : item.product.displayImage}"/>
                                <div class="order-item">
                                    <img src="${pageContext.request.contextPath}/${itemImg}"
                                         alt="${item.product.productName}"
                                         class="order-item-image"
                                         onerror="this.style.display='none'">
                                    <div class="order-item-info">
                                        <div class="order-item-name">${item.product.productName}</div>
                                        <c:if test="${item.variant != null}">
                                            <div class="order-item-qty" style="color:#888; font-size:0.8rem;">${item.variant.color} / ${item.variant.storage}</div>
                                        </c:if>
                                        <div class="order-item-qty">SL: ${item.quantity}</div>
                                    </div>
                                    <div class="order-item-price">
                                        <fmt:formatNumber
                                                value="${itemPrice * item.quantity}"
                                                type="number" groupingUsed="true"/>₫
                                    </div>
                                </div>
                                <c:set var="total"
                                       value="${total + (itemPrice * item.quantity)}"/>
                            </c:forEach>

                            <div class="order-totals">
                                <div class="order-total-row">
                                    <span>Tạm tính:</span>
                                    <span><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫</span>
                                </div>
                                <div class="order-total-row">
                                    <span>Phí vận chuyển: <span id="shippingFeeDisplay">Miễn phí</span></span>
                                </div>
                                <div class="order-total-row final">
                                    <span>Tổng cộng:</span>
                                    <span class="amount" id="totalAmountDisplay"><fmt:formatNumber value="${total}" type="number"
                                                                                                   groupingUsed="true"/>₫</span>
                                </div>
                            </div>

                            <div style="margin-top: 1.5rem;">
                                <label class="form-label" style="margin-bottom: 0.75rem;">Phương thức thanh toán</label>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn" name="action" value="cod">Thanh toán khi nhận hàng
                                </button>
                                <button class="btn" type="button" onclick="payWithVNPay()">Thanh toán qua VNPay</button>
                            </div>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</main>


<jsp:include page="/views/common/footer.jsp"/>

<script>
    const ctx = '${pageContext.request.contextPath}';
    const provinceSel = document.getElementById('provinceSelect');
    const districtSel = document.getElementById('districtSelect');
    const wardSel = document.getElementById('wardSelect');
    const hiddenDistrict = document.getElementById('districtIdField');
    const hiddenWard = document.getElementById('wardCodeField');
    const hiddenStreet = document.getElementById('streetAddressField');
    const addressTextarea = document.getElementById('shippingAddress');
    const streetAddressInput = document.getElementById('streetAddressInput');
    const addressGroup = document.getElementById('addressGroup');

    const savedDistrictId = '${sessionScope.user.districtId}';
    const savedWardCode = '${sessionScope.user.wardCode}';
    const hasFullSavedAddress = savedDistrictId && savedDistrictId.trim() !== ''
        && savedWardCode && savedWardCode.trim() !== '';

    const districtsCache = {};
    const wardsCache = {};
    let cartTotal = ${total};
    let isUserEditingAddress = false;

    async function loadProvinces() {
        const res = await fetch(ctx + '/api/ghn/provinces');
        const json = await res.json();
        if (json.success) {
            json.data.forEach(p => provinceSel.appendChild(createProvinceOption(p)));
            const batches = chunk(json.data, 5);
            for (const batch of batches) {
                await Promise.all(batch.map(p => prefetchDistricts(p.ProvinceID)));
            }
            if (hasFullSavedAddress) {
                await resolveAndPrefill(savedDistrictId, savedWardCode);
                prefillAddressFromProfile();
                buildFullAddress();
            }
        }
    }

    function prefillAddressFromProfile() {
        const savedAddress = '${sessionScope.user.shippingAddress != null ? sessionScope.user.shippingAddress : ""}';
        if (savedAddress && savedAddress.trim() !== '') {
            streetAddressInput.value = savedAddress.trim();
        }
    }

    function chunk(arr, size) {
        const result = [];
        for (let i = 0; i < arr.length; i += size) {
            result.push(arr.slice(i, i + size));
        }
        return result;
    }

    function createProvinceOption(p) {
        const opt = document.createElement('option');
        opt.value = p.ProvinceID;
        opt.textContent = p.NameExtension
            ? p.NameExtension.find(n => n && n.trim()) || p.ProvinceName
            : p.ProvinceName;
        return opt;
    }

    function createDistrictOption(d) {
        const opt = document.createElement('option');
        opt.value = d.DistrictID;
        opt.textContent = d.NameExtension
            ? d.NameExtension.find(n => n && n.trim()) || d.DistrictName
            : d.DistrictName;
        return opt;
    }

    function createWardOption(w) {
        const opt = document.createElement('option');
        opt.value = w.WardCode;
        opt.textContent = w.NameExtension
            ? w.NameExtension.find(n => n && n.trim()) || w.WardName
            : w.WardName;
        return opt;
    }

    async function prefetchDistricts(provinceId) {
        try {
            const res = await fetch(ctx + '/api/ghn/districts?province_id=' + provinceId);
            const j = await res.json();
            if (j.success) {
                districtsCache[provinceId] = j.data;
            }
        } catch (_) {}
    }

    async function resolveAndPrefill(districtId, wardCode) {
        for (const [provinceId, districts] of Object.entries(districtsCache)) {
            if (districts.find(d => String(d.DistrictID) === String(districtId))) {
                provinceSel.value = provinceId;
                await loadDistricts(provinceId, parseInt(districtId), wardCode);
                return;
            }
        }
        for (const opt of provinceSel.options) {
            if (!opt.value) continue;
            const dRes = await fetch(ctx + '/api/ghn/districts?province_id=' + opt.value);
            const dJson = await dRes.json();
            if (dJson.success) {
                const found = dJson.data.find(d => String(d.DistrictID) === String(districtId));
                if (found) {
                    provinceSel.value = opt.value;
                    await loadDistricts(opt.value, parseInt(districtId), wardCode);
                    return;
                }
            }
        }
    }

    async function loadDistricts(provinceId, preselectId, preselectWard) {
        districtSel.innerHTML = '<option value="">-- Đang tải... --</option>';
        districtSel.disabled = true;
        wardSel.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';
        wardSel.disabled = true;
        if (!provinceId) {
            districtSel.innerHTML = '<option value="">-- Chọn Tỉnh trước --</option>';
            return;
        }
        if (districtsCache[provinceId]) {
            districtSel.innerHTML = '<option value="">-- Chọn Quận / Huyện --</option>';
            districtsCache[provinceId].forEach(d => districtSel.appendChild(createDistrictOption(d)));
            districtSel.disabled = false;
            if (preselectId) {
                districtSel.value = preselectId;
                await loadWards(preselectId, preselectWard);
            }
            return;
        }
        const res = await fetch(ctx + '/api/ghn/districts?province_id=' + provinceId);
        const json = await res.json();
        districtSel.innerHTML = '<option value="">-- Chọn Quận / Huyện --</option>';
        if (json.success) {
            json.data.forEach(d => districtSel.appendChild(createDistrictOption(d)));
            districtSel.disabled = false;
            if (preselectId) {
                districtSel.value = preselectId;
                await loadWards(preselectId, preselectWard);
            }
        }
    }

    async function loadWards(districtId, preselectCode) {
        wardSel.innerHTML = '<option value="">-- Đang tải... --</option>';
        wardSel.disabled = true;
        if (!districtId) {
            wardSel.innerHTML = '<option value="">-- Chọn Quận trước --</option>';
            return;
        }
        if (wardsCache[districtId]) {
            wardSel.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';
            wardsCache[districtId].forEach(w => wardSel.appendChild(createWardOption(w)));
            wardSel.disabled = false;
            if (preselectCode) {
                wardSel.value = preselectCode;
                hiddenDistrict.value = districtId;
                hiddenWard.value = preselectCode;
                await calculateShippingFee();
            }
            buildFullAddress();
            return;
        }
        const res = await fetch(ctx + '/api/ghn/wards?district_id=' + districtId);
        const json = await res.json();
        wardSel.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';
        if (json.success) {
            json.data.forEach(w => wardSel.appendChild(createWardOption(w)));
            wardSel.disabled = false;
            wardsCache[districtId] = json.data;
            if (preselectCode) {
                wardSel.value = preselectCode;
                hiddenDistrict.value = districtId;
                hiddenWard.value = preselectCode;
                await calculateShippingFee();
            }
            buildFullAddress();
        }
    }

    async function calculateShippingFee() {
        const districtId = districtSel.value;
        const wardCode = wardSel.value;
        if (!districtId || !wardCode) {
            updateShippingDisplay(0, parseInt(districtId) || null, wardCode || null);
            return;
        }
        const body = {
            to_district_id: parseInt(districtId),
            to_ward_code: wardCode
        };
        const res = await fetch(ctx + '/api/ghn/calculate-fee', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        });
        const json = await res.json();
        const fee = json.success && json.fee ? json.fee : 0;
        updateShippingDisplay(fee, body.to_district_id, body.to_ward_code);
    }

    function updateShippingDisplay(fee, districtId, wardCode) {
        if (districtId) hiddenDistrict.value = districtId;
        if (wardCode) hiddenWard.value = wardCode;
        const shippingEl = document.getElementById('shippingFeeDisplay');
        const totalEl = document.getElementById('totalAmountDisplay');
        if (shippingEl) shippingEl.textContent = 'Miễn phí';
        if (totalEl) totalEl.textContent = new Intl.NumberFormat('vi-VN').format(cartTotal) + '₫';
    }

    function buildFullAddress() {
        if (isUserEditingAddress) return;
        const streetValue = streetAddressInput.value.trim();
        const provinceName = provinceSel.options[provinceSel.selectedIndex]?.text || '';
        const districtName = districtSel.options[districtSel.selectedIndex]?.text || '';
        const wardName = wardSel.options[wardSel.selectedIndex]?.text || '';
        const fullParts = [streetValue, wardName, districtName, provinceName]
            .filter(p => p && p.trim() !== '' && !p.trim().startsWith('--'));
        const fullAddress = fullParts.join(', ');
        addressTextarea.value = fullAddress;
        hiddenStreet.value = fullAddress;
    }

    provinceSel.addEventListener('change', () => loadDistricts(provinceSel.value, null, null));
    districtSel.addEventListener('change', () => loadWards(districtSel.value, null));
    wardSel.addEventListener('change', () => { calculateShippingFee(); buildFullAddress(); });
    streetAddressInput.addEventListener('input', () => buildFullAddress());

    loadProvinces();

    function validateForm() {
        let isValid = true;

        const receiverName = document.getElementById('receiverName');
        const receiverNameGroup = document.getElementById('receiverNameGroup');
        if (!receiverName.value.trim() || receiverName.value.trim().length < 2) {
            receiverName.classList.add('error');
            receiverNameGroup.classList.add('error');
            isValid = false;
        } else {
            receiverName.classList.remove('error');
            receiverNameGroup.classList.remove('error');
        }

        const phone = document.getElementById('phone');
        const phoneGroup = document.getElementById('phoneGroup');
        const phoneRegex = /^[0-9]{10,11}$/;
        if (!phone.value.trim() || !phoneRegex.test(phone.value.trim())) {
            phone.classList.add('error');
            phoneGroup.classList.add('error');
            isValid = false;
        } else {
            phone.classList.remove('error');
            phoneGroup.classList.remove('error');
        }

        const email = document.getElementById('email');
        const emailGroup = document.getElementById('emailGroup');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim() || !emailRegex.test(email.value.trim())) {
            email.classList.add('error');
            emailGroup.classList.add('error');
            isValid = false;
        } else {
            email.classList.remove('error');
            emailGroup.classList.remove('error');
        }

        if (!districtSel.value) {
            districtSel.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            districtSel.style.borderColor = '';
        }

        if (!wardSel.value) {
            wardSel.style.borderColor = '#dc3545';
            isValid = false;
        } else {
            wardSel.style.borderColor = '';
        }

        if (!streetAddressInput.value.trim() || streetAddressInput.value.trim().length < 5) {
            streetAddressInput.classList.add('error');
            addressGroup.classList.add('error');
            isValid = false;
        } else {
            streetAddressInput.classList.remove('error');
            addressGroup.classList.remove('error');
        }

        return isValid;
    }

    function payWithVNPay() {
        if (!validateForm()) {
            const firstError = document.querySelector('.form-group.error, select[style*="borderColor"], textarea.form-control.error');
            if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
            return;
        }
        const form = document.getElementById('checkoutForm');
        form.action = '${pageContext.request.contextPath}/vnpay-payment';
        form.submit();
    }

    document.querySelectorAll('.payment-option').forEach(option => {
        option.addEventListener('click', function () {
            document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
            this.classList.add('selected');
        });
    });

    document.getElementById('checkoutForm').addEventListener('submit', function (e) {
        if (!validateForm()) {
            e.preventDefault();
            const firstError = document.querySelector('.form-group.error, select[style*="borderColor"], textarea.form-control.error');
            if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    });

    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('input', function () {
            this.classList.remove('error');
            const group = this.closest('.form-group');
            if (group) group.classList.remove('error');
            if (this.tagName === 'SELECT') this.style.borderColor = '';
        });
    });

    streetAddressInput.addEventListener('focus', () => { isUserEditingAddress = true; });
    streetAddressInput.addEventListener('blur', () => { isUserEditingAddress = false; buildFullAddress(); });

    function refreshCartCount() {
        fetch(ctx + '/cart/count')
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