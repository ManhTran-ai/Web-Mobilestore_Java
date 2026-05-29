<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Kho - Mobile Store</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #1a1a1a; background-color: #f5f5f7; }
        .admin-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #1a1a1a; color: #ffffff; padding: 2rem 0; position: fixed; height: 100vh; overflow-y: auto; }
        .sidebar-header { padding: 0 1.5rem 2rem; border-bottom: 1px solid #333; margin-bottom: 1rem; }
        .sidebar-header h2 { font-size: 1.25rem; font-weight: 600; }
        .sidebar-header span { font-size: 0.875rem; color: #888; }
        .sidebar-nav { list-style: none; }
        .sidebar-nav li { margin: 0.25rem 0; }
        .sidebar-nav a { display: flex; align-items: center; padding: 0.875rem 1.5rem; color: #ccc; text-decoration: none; transition: all 0.2s; font-size: 0.95rem; }
        .sidebar-nav a:hover, .sidebar-nav a.active { background: #333; color: #fff; }
        .sidebar-nav a.active { border-left: 3px solid #0071e3; }
        .main-content { flex: 1; margin-left: 260px; padding: 2rem; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem; }
        .page-header h1 { font-size: 1.75rem; font-weight: 600; }
        .header-actions { display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; }
        .btn { display: inline-flex; align-items: center; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 0.95rem; font-weight: 500; text-decoration: none; cursor: pointer; transition: all 0.2s; border: none; font-family: inherit; }
        .btn-primary { background: #0071e3 !important; color: #fff !important; }
        .btn-primary:hover { background: #0077ed !important; }
        .btn-success { background: #34c759 !important; color: #fff !important; }
        .btn-success:hover { background: #30b854 !important; }
        .btn-secondary { background: #e5e5ea !important; color: #1a1a1a !important; }
        .btn-secondary:hover { background: #d1d1d6 !important; }
        .btn-warning { background: #ff9500 !important; color: #fff !important; }
        .btn-warning:hover { background: #e68a00 !important; }
        .btn-sm { padding: 0.5rem 1rem; font-size: 0.875rem; }
        .search-box { position: relative; }
        .search-box input { padding: 0.75rem 1rem 0.75rem 2.5rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 0.95rem; width: 280px; }
        .search-box input:focus { outline: none; border-color: #0071e3; }
        .search-box::before { content: ''; position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%); width: 16px; height: 16px; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23888'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z'/%3E%3C/svg%3E") no-repeat center; background-size: contain; }
        .alert { padding: 1rem 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-success { background: #d1f2eb; color: #0d6848; border: 1px solid #a3e4d7; }
        .alert-error { background: #fdecea; color: #c62828; border: 1px solid #f5c6cb; }
        .alert-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: #fff; border-radius: 12px; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .stat-card .label { font-size: 0.85rem; color: #888; margin-bottom: 0.5rem; }
        .stat-card .value { font-size: 1.75rem; font-weight: 600; }
        .stat-card.primary .value { color: #0071e3; }
        .stat-card.success .value { color: #34c759; }
        .stat-card.warning .value { color: #ff9500; }
        .table-container { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .table-header { padding: 1rem 1.5rem; border-bottom: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }
        .table-header h3 { font-size: 1rem; font-weight: 600; }
        .table-info { font-size: 0.9rem; color: #888; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid #e5e5ea; }
        .data-table th { background: #f5f5f7; font-weight: 600; color: #666; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .data-table tbody tr:hover { background: #fafafa; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .product-name { font-weight: 600; color: #1a1a1a; }
        .product-manufacturer { font-size: 0.8rem; color: #888; }
        .variant-color { display: inline-block; width: 14px; height: 14px; border-radius: 50%; border: 1px solid #d1d1d6; vertical-align: middle; margin-right: 4px; }
        .price { font-weight: 600; color: #1a1a1a; white-space: nowrap; }
        .quantity { font-weight: 600; white-space: nowrap; }
        .quantity.high { color: #34c759; }
        .quantity.low { color: #ff9500; }
        .quantity.out { color: #ff3b30; }
        .stock-badge { display: inline-block; padding: 0.25rem 0.6rem; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .stock-badge.high { background: #d1f2eb; color: #155724; }
        .stock-badge.low { background: #fff3cd; color: #856404; }
        .stock-badge.out { background: #fdecea; color: #c62828; }
        .actions { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .empty-state { text-align: center; padding: 4rem 2rem; color: #888; }
        .empty-state .icon { font-size: 4rem; margin-bottom: 1rem; }
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: none; align-items: center; justify-content: center; z-index: 1000; }
        .modal-overlay.active { display: flex; }
        .modal { background: #fff; border-radius: 16px; padding: 2rem; max-width: 440px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.3); animation: modalIn 0.3s ease; }
        .modal h3 { margin-bottom: 0.5rem; font-size: 1.25rem; }
        .modal p { color: #666; margin-bottom: 0.5rem; font-size: 0.9rem; }
        .modal .product-info { background: #f5f5f7; border-radius: 8px; padding: 0.75rem 1rem; margin-bottom: 1.5rem; font-size: 0.9rem; }
        .modal .product-info strong { color: #1a1a1a; }
        .modal-form { text-align: left; }
        .form-group { margin-bottom: 1rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.9rem; color: #1a1a1a; }
        .form-label .required { color: #ff3b30; }
        .form-control { width: 100%; padding: 0.75rem 1rem; border: 1px solid #d1d1d6; border-radius: 8px; font-size: 1rem; font-family: inherit; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: #0071e3; box-shadow: 0 0 0 3px rgba(0,113,227,0.1); }
        .form-control:read-only { background: #f5f5f7; }
        .help-text { font-size: 0.8rem; color: #888; margin-top: 0.3rem; }
        .modal-actions { display: flex; gap: 0.75rem; margin-top: 1.5rem; justify-content: flex-end; }
        .row-hidden { display: none !important; }
        @keyframes modalIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
        @media (max-width: 1200px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 900px) { .data-table th:nth-child(4), .data-table td:nth-child(4) { display: none; } }
        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; }
            .stats-row { grid-template-columns: 1fr; }
            .search-box input { width: 100%; }
        }
    </style>
</head>
<body>
<div class="admin-container">
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản Lý Kho</h1>
            <div class="header-actions">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm sản phẩm, màu, dung lượng...">
                </div>
            </div>
        </div>

        <c:if test="${param.success == 'imported'}"><div class="alert alert-success">Nhập kho thành công!</div></c:if>
        <c:if test="${param.success == 'exported'}"><div class="alert alert-success">Xuất kho thành công! Đơn hàng đã được tạo.</div></c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <c:choose>
                    <c:when test="${param.error == 'import_failed'}">Nhập kho thất bại. Vui lòng thử lại.</c:when>
                    <c:when test="${param.error == 'export_failed'}">Xuất kho thất bại. Có thể số lượng trong kho không đủ.</c:when>
                    <c:when test="${param.error == 'invalid_variant'}">Sản phẩm không hợp lệ.</c:when>
                    <c:when test="${param.error == 'missing_quantity'}">Vui lòng nhập số lượng.</c:when>
                    <c:when test="${param.error == 'invalid_quantity'}">Số lượng không hợp lệ.</c:when>
                    <c:when test="${param.error == 'invalid_price'}">Gía không hợp lệ.</c:when>
                    <c:otherwise>Đã xảy ra lỗi. Vui lòng thử lại.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng sản phẩm</div>
                <div class="value" id="statTotal">0</div>
            </div>
            <div class="stat-card warning">
                <div class="label">Sắp hết hàng (&le; 5)</div>
                <div class="value" id="statLow">0</div>
            </div>
            <div class="stat-card success">
                <div class="label">Còn hàng</div>
                <div class="value" id="statInStock">0</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Danh sách sản phẩm trong kho</h3>
                <span class="table-info">Hiển thị <span id="displayCount">0</span> / <span id="totalCount">0</span></span>
            </div>
            <c:choose>
                <c:when test="${empty variants}">
                    <div class="empty-state">
                        <div class="icon">📦</div>
                        <h3>Chưa có sản phẩm nào</h3>
                        <p>Thêm sản phẩm và biến thể để bắt đầu quản lý kho.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="inventoryTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sản phẩm</th>
                            <th>Màu sắc</th>
                            <th>Dung lượng</th>
                            <th>Giá bán</th>
                            <th>Tồn kho</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="v" items="${variants}">
                            <c:set var="qty" value="${v.quantityInStock}"/>
                            <c:set var="stockClass" value="${qty <= 0 ? 'out' : qty <= 5 ? 'low' : 'high'}"/>
                            <c:set var="stockBadgeClass" value="${qty <= 0 ? 'out' : qty <= 5 ? 'low' : 'high'}"/>
                            <c:set var="searchText" value="${v.product.productName} ${v.product.manufacturer} ${v.color} ${v.storage}"/>
                            <tr class="variant-row"
                                data-id="${v.variantId}"
                                data-qty="${qty}"
                                data-search="${searchText}">
                                <td><span style="font-weight: 600; color: #0071e3;">#${v.variantId}</span></td>
                                <td>
                                    <div class="product-name">${v.product.productName}</div>
                                    <div class="product-manufacturer">${v.product.manufacturer}</div>
                                </td>
                                <td>
                                    <span class="variant-color" style="background-color: ${v.color};"></span>${v.color}
                                </td>
                                <td>${v.storage}</td>
                                <td><span class="price">${v.price}đ</span></td>
                                <td>
                                    <span class="quantity ${stockClass}">${qty}</span>
                                    <span class="stock-badge ${stockBadgeClass}">
                                        <c:choose>
                                            <c:when test="${qty <= 0}">Hết hàng</c:when>
                                            <c:when test="${qty <= 5}">Sắp hết</c:when>
                                            <c:otherwise>Còn hàng</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td class="actions">
                                    <button type="button" class="btn btn-success btn-sm import-btn"
                                            data-id="${v.variantId}"
                                            data-name="${v.product.productName} - ${v.color} / ${v.storage}"
                                            data-qty="${qty}">
                                        + Nhập kho
                                    </button>
                                    <button type="button" class="btn btn-warning btn-sm export-btn"
                                            data-id="${v.variantId}"
                                            data-name="${v.product.productName} - ${v.color} / ${v.storage}"
                                            data-price="${v.price}"
                                            data-qty="${qty}">
                                        &minus; Xuất kho
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<div class="modal-overlay" id="importModal">
    <div class="modal">
        <h3>Nhập kho</h3>
        <div class="product-info" id="importProductInfo"></div>
        <form class="modal-form" method="post" action="${pageContext.request.contextPath}/admin/inventory">
            <input type="hidden" name="action" value="import">
            <input type="hidden" name="variantId" id="importVariantId">
            <div class="form-group">
                <label class="form-label" for="importQuantity">Số lượng nhập thêm <span class="required">*</span></label>
                <input type="number" class="form-control" id="importQuantity" name="quantity" min="1" required placeholder="VD: 50">
                <p class="help-text">Nhập số lượng sản phẩm cần thêm vào kho.</p>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" id="cancelImport">Hủy</button>
                <button type="submit" class="btn btn-success">Xác nhận nhập kho</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-overlay" id="exportModal">
    <div class="modal">
        <h3>Xuất kho (Bán hàng)</h3>
        <div class="product-info" id="exportProductInfo"></div>
        <form class="modal-form" method="post" action="${pageContext.request.contextPath}/admin/inventory">
            <input type="hidden" name="action" value="export">
            <input type="hidden" name="variantId" id="exportVariantId">
            <input type="hidden" name="price" id="exportPrice">
            <div class="form-group">
                <label class="form-label" for="exportQuantity">Số lượng xuất <span class="required">*</span></label>
                <input type="number" class="form-control" id="exportQuantity" name="quantity" min="1" required placeholder="VD: 2">
                <p class="help-text" id="exportQtyHelp"></p>
            </div>
            <div class="form-group">
                <label class="form-label" for="exportPhone">Số điện thoại khách hàng</label>
                <input type="text" class="form-control" id="exportPhone" name="customerPhone" placeholder="VD: 0901234567">
            </div>
            <div class="form-group">
                <label class="form-label" for="exportNote">Ghi chú</label>
                <textarea class="form-control" id="exportNote" name="note" rows="2" placeholder="VD: Bán lẻ tại quầy, Khách VIP..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" id="cancelExport">Hủy</button>
                <button type="submit" class="btn btn-warning">Xác nhận xuất kho</button>
            </div>
        </form>
    </div>
</div>

<script>
(function () {
    const searchInput = document.getElementById('searchInput');
    const rows = document.querySelectorAll('.variant-row');
    const displayCount = document.getElementById('displayCount');
    const totalCount = document.getElementById('totalCount');
    const statTotal = document.getElementById('statTotal');
    const statLow = document.getElementById('statLow');
    const statInStock = document.getElementById('statInStock');

    if (rows.length) {
        totalCount.textContent = rows.length;
        updateStats();

        searchInput.addEventListener('input', applyFilters);
        applyFilters();
    }

    function normalize(s) {
        return (s || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    }

    function applyFilters() {
        const q = normalize(searchInput.value.trim());
        let visible = 0;

        rows.forEach(function (row) {
            const match = !q || normalize(row.dataset.search).includes(q);
            row.classList.toggle('row-hidden', !match);
            if (match) visible++;
        });

        if (displayCount) displayCount.textContent = visible;
    }

    function updateStats() {
        let low = 0, inStock = 0;
        rows.forEach(function (row) {
            const qty = parseInt(row.dataset.qty);
            if (qty <= 5) low++;
            if (qty > 0) inStock++;
        });
        if (statTotal) statTotal.textContent = rows.length;
        if (statLow) statLow.textContent = low;
        if (statInStock) statInStock.textContent = inStock;
    }

    const importModal = document.getElementById('importModal');
    const exportModal = document.getElementById('exportModal');

    document.querySelectorAll('.import-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.getElementById('importVariantId').value = btn.dataset.id;
            document.getElementById('importProductInfo').innerHTML = '<strong>' + btn.dataset.name + '</strong> — Tồn kho hiện tại: ' + btn.dataset.qty;
            document.getElementById('importQuantity').value = '';
            document.getElementById('importQuantity').max = '';
            importModal.classList.add('active');
        });
    });

    document.querySelectorAll('.export-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.getElementById('exportVariantId').value = btn.dataset.id;
            document.getElementById('exportPrice').value = btn.dataset.price;
            document.getElementById('exportProductInfo').innerHTML = '<strong>' + btn.dataset.name + '</strong> — Tồn kho: ' + btn.dataset.qty + ' — Giá bán: ' + Number(btn.dataset.price).toLocaleString() + 'đ';
            document.getElementById('exportQuantity').value = '';
            document.getElementById('exportQuantity').max = btn.dataset.qty;
            document.getElementById('exportQtyHelp').textContent = 'Tối đa: ' + btn.dataset.qty + ' sản phẩm';
            document.getElementById('exportPhone').value = '';
            document.getElementById('exportNote').value = '';
            exportModal.classList.add('active');
        });
    });

    document.getElementById('cancelImport').addEventListener('click', function () {
        importModal.classList.remove('active');
    });

    document.getElementById('cancelExport').addEventListener('click', function () {
        exportModal.classList.remove('active');
    });

    importModal.addEventListener('click', function (e) {
        if (e.target === importModal) importModal.classList.remove('active');
    });

    exportModal.addEventListener('click', function (e) {
        if (e.target === exportModal) exportModal.classList.remove('active');
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            importModal.classList.remove('active');
            exportModal.classList.remove('active');
        }
    });

    var alerts = document.querySelectorAll('.alert-success, .alert-error, .alert-warning');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function () { alert.style.display = 'none'; }, 500);
        }, 5000);
    });
})();
</script>
</body>
</html>
