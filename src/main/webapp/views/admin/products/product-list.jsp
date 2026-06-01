<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .product-image { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; background: #f5f5f7; }
        .product-image-placeholder { width: 60px; height: 60px; border-radius: 8px; background: #f5f5f7; display: flex; align-items: center; justify-content: center; color: #888; font-size: 1.5rem; }
        .product-name { font-weight: 500; color: #1a1a1a; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .product-manufacturer { font-size: 0.875rem; color: #888; }
        .price { font-weight: 600; color: #0071e3; white-space: nowrap; }
        .stock { display: inline-block; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .stock.in-stock { background: #d1f2eb; color: #0d6848; }
        .stock.low-stock { background: #fff3cd; color: #856404; }
        .stock.out-of-stock { background: #fdecea; color: #c62828; }
        .condition-badge { display: inline-block; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 500; background: #e5e5ea; color: #666; }
        .condition-badge.new { background: #d1f2eb; color: #0d6848; }
        .actions { display: flex; gap: 0.5rem; }
        .table-footer { padding: 1rem 1.5rem; border-top: 1px solid #e5e5ea; display: flex; justify-content: space-between; align-items: center; }
        .format-number { font-variant-numeric: tabular-nums; }

        .modal-product-name { font-weight: 600; color: #1a1a1a; }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="products" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Sản phẩm</h1>
            <div class="header-actions">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm kiếm sản phẩm...">
                </div>
                <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                    + Thêm sản phẩm
                </a>
            </div>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>✓</span> Thêm sản phẩm thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>✓</span> Cập nhật sản phẩm thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>✓</span> Xóa sản phẩm thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'delete_failed'}">
            <div class="alert alert-error">
                <span>✕</span> Không thể xóa sản phẩm. Sản phẩm có thể đang được sử dụng trong đơn hàng.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'not_found'}">
            <div class="alert alert-error">
                <span>✕</span> Không tìm thấy sản phẩm.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_id'}">
            <div class="alert alert-error">
                <span>✕</span> ID sản phẩm không hợp lệ.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card primary">
                <div class="label">Tổng sản phẩm</div>
                <div class="value">${products.size()}</div>
            </div>
            <div class="stat-card success">
                <div class="label">Còn hàng</div>
                <div class="value" id="inStockCount">0</div>
            </div>
            <div class="stat-card warning">
                <div class="label">Sắp hết hàng</div>
                <div class="value" id="lowStockCount">0</div>
            </div>
            <div class="stat-card danger">
                <div class="label">Hết hàng</div>
                <div class="value" id="outOfStockCount">0</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Danh sách sản phẩm</h3>
                <span class="table-info">Hiển thị <span id="displayCount">${products.size()}</span> sản phẩm</span>
            </div>
            <c:choose>
                <c:when test="${empty products}">
                    <div class="empty-state">
                        <div class="icon">📱</div>
                        <h3>Chưa có sản phẩm nào</h3>
                        <p>Bắt đầu bằng cách thêm sản phẩm đầu tiên cho cửa hàng của bạn</p>
                        <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                            + Thêm sản phẩm đầu tiên
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="productsTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Sản phẩm</th>
                            <th>Danh mục</th>
                            <th>Giá gốc</th>
                            <th>Giảm giá</th>
                            <th>Tồn kho</th>
                            <th>Tình trạng</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr data-product-id="${product.productId}"
                                data-product-name="${product.productName}"
                                data-quantity="${product.totalStock}">
                                <td>${product.productId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty product.displayImage}">
                                            <img src="${pageContext.request.contextPath}/${product.displayImage}"
                                                 alt="${product.productName}"
                                                 class="product-image"
                                                 loading="lazy">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="product-image-placeholder">📱</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="product-name" title="${product.productName}">${product.productName}</div>
                                    <div class="product-manufacturer">${product.manufacturer}</div>
                                    <c:if test="${not empty product.variants}">
                                        <div style="font-size:0.75rem; color:#888; margin-top:2px;">
                                            📦 ${product.variants.size()} phiên bản
                                            <span style="color:#34c759;">
                                                (Từ <fmt:formatNumber value="${product.displayPrice}" type="number"/>₫)
                                            </span>
                                        </div>
                                    </c:if>
                                </td>
                                <td>${product.category.categoryName}</td>
                                <td class="price format-number">
                                    <fmt:formatNumber value="${product.displayOriginalPrice}" type="number" groupingUsed="true"/>₫
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.discount > 0}">
                                            <span class="discount-badge" style="background: #ff3b30; color: #fff; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; font-weight: 700;">
                                                -${product.discount}%
                                            </span>
                                            <div style="font-size: 0.75rem; color: #888; margin-top: 4px;">
                                                Bán: <fmt:formatNumber value="${product.displayPrice}" type="number"/>₫
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #ccc; font-size: 0.85rem;">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.totalStock == 0}">
                                            <span class="stock out-of-stock">Hết hàng</span>
                                        </c:when>
                                        <c:when test="${product.totalStock <= 10}">
                                            <span class="stock low-stock">${product.totalStock}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock in-stock">${product.totalStock}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="condition-badge ${product.productCondition == 'Mới' ? 'new' : ''}">
                                        ${product.productCondition}
                                    </span>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.productId}"
                                       class="btn btn-secondary btn-sm"
                                       title="Sửa sản phẩm">
                                        ✏️ Sửa
                                    </a>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${product.productId}"
                                            data-name="${product.productName}"
                                            title="Xóa sản phẩm">
                                        🗑️ Xóa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <span class="table-info">Tổng cộng: ${products.size()} sản phẩm</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-icon warning">⚠️</div>
        <h3>Xác nhận xóa sản phẩm</h3>
        <p>Bạn có chắc chắn muốn xóa sản phẩm:<br>
            <span class="modal-product-name" id="modalProductName"></span>?</p>
        <p style="font-size: 0.85rem; color: #ff3b30;">Hành động này không thể hoàn tác!</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
            <form id="deleteForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-danger">Xóa sản phẩm</button>
            </form>
        </div>
    </div>
</div>

<script>
    const searchInput = document.getElementById('searchInput');
    const productsTable = document.getElementById('productsTable');
    const deleteModal = document.getElementById('deleteModal');
    const deleteForm = document.getElementById('deleteForm');
    const modalProductName = document.getElementById('modalProductName');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    function calculateStats() {
        const rows = document.querySelectorAll('#productsTable tbody tr');
        let inStock = 0, lowStock = 0, outOfStock = 0;

        rows.forEach(row => {
            const quantity = parseInt(row.dataset.quantity) || 0;
            if (quantity === 0) {
                outOfStock++;
            } else if (quantity <= 10) {
                lowStock++;
            } else {
                inStock++;
            }
        });

        document.getElementById('inStockCount').textContent = inStock;
        document.getElementById('lowStockCount').textContent = lowStock;
        document.getElementById('outOfStockCount').textContent = outOfStock;
    }

    if (searchInput && productsTable) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            const rows = productsTable.querySelectorAll('tbody tr');
            let visibleCount = 0;

            rows.forEach(row => {
                const productName = row.dataset.productName.toLowerCase();
                const text = row.textContent.toLowerCase();

                if (productName.includes(searchTerm) || text.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            document.getElementById('displayCount').textContent = visibleCount;
        });
    }

    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const productId = this.dataset.id;
            const productName = this.dataset.name;

            modalProductName.textContent = productName;
            deleteForm.action = '${pageContext.request.contextPath}/admin/products/delete?id=' + productId;
            deleteModal.classList.add('active');
        });
    });

    cancelDeleteBtn.addEventListener('click', function() {
        deleteModal.classList.remove('active');
    });

    deleteModal.addEventListener('click', function(e) {
        if (e.target === deleteModal) {
            deleteModal.classList.remove('active');
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && deleteModal.classList.contains('active')) {
            deleteModal.classList.remove('active');
        }
    });

    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-success');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.style.display = 'none', 500);
        });
    }, 5000);

    calculateStats();
</script>
</body>
</html>
