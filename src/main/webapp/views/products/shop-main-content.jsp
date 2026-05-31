<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<p class="results-count">Hiển thị <strong>${totalItems}</strong> sản phẩm</p>

<c:if test="${favoritesOnly and favoritesRequiresLogin}">
    <div class="results-bar">
        Vui lòng <a href="${pageContext.request.contextPath}/login" style="color:#000; font-weight:600;">đăng nhập</a> để xem sản phẩm yêu thích.
    </div>
</c:if>

<c:if test="${favoritesOnly or not empty searchKeyword or not empty selectedCategory or not empty priceRangeLabel or not empty sortLabel}">
    <div class="results-bar">
        <span>Đang lọc:</span>
        <div class="active-tags">
            <c:if test="${favoritesOnly}">
                <span class="active-tag">Yêu thích</span>
            </c:if>
            <c:if test="${not empty searchKeyword}">
                <span class="active-tag">"${searchKeyword}"</span>
            </c:if>
            <c:if test="${not empty selectedCategory}">
                <c:forEach var="category" items="${categories}">
                    <c:if test="${category.categoryId == selectedCategory}">
                        <span class="active-tag">${category.categoryName}</span>
                    </c:if>
                </c:forEach>
            </c:if>
            <c:if test="${not empty priceRangeLabel}">
                <span class="active-tag">${priceRangeLabel}</span>
            </c:if>
            <c:if test="${not empty sortLabel}">
                <span class="active-tag">${sortLabel}</span>
            </c:if>
        </div>
    </div>
</c:if>

<div class="grid">
    <c:forEach var="product" items="${products}">
        <div class="card" data-product-id="${product.productId}" style="position: relative;">
            <c:set var="isLiked" value="false" />
            <c:if test="${not empty likedProductIds and likedProductIds.contains(product.productId)}">
                <c:set var="isLiked" value="true" />
            </c:if>
            <div class="wishlist-btn ${isLiked ? 'active' : ''}" data-id="${product.productId}" title="Thêm vào yêu thích">
                &hearts;
            </div>
            <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}"
               style="text-decoration:none; color:inherit; display:block;">
                <c:choose>
                    <c:when test="${not empty product.displayImage}">
                        <img src="${pageContext.request.contextPath}/${product.displayImage}" alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <div style="height:220px; display:flex; align-items:center; justify-content:center; color:#888; font-size:3rem;">📱</div>
                    </c:otherwise>
                </c:choose>
                <div class="name">${product.productName}</div>
                <div class="manufacturer">${product.manufacturer}</div>
                <div class="product-info-price">
                    <c:choose>
                        <c:when test="${not empty product.discount and product.discount > 0}">
                            <div class="current-price">
                                <fmt:formatNumber value="${product.displayOriginalPrice * (100 - product.discount) / 100}"
                                                  type="number"/>₫
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; margin-top: 2px;">
                <span class="old-price">
                    <fmt:formatNumber value="${product.displayOriginalPrice}" type="number"/>₫
                </span>
                                <span class="discount-tag">-${product.discount}%</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="current-price">
                                <fmt:formatNumber value="${product.displayPrice}" type="number"/>₫
                            </div>
                            <div style="height: 21px;"></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-stock">
                    <c:choose>
                        <c:when test="${product.totalStock == 0}">Hết hàng</c:when>
                        <c:otherwise>Tồn kho: ${product.totalStock}</c:otherwise>
                    </c:choose>
                </div>
            </a>
            <div class="variant-selector" style="margin-top:8px;">
                <select class="variant-select" data-product-id="${product.productId}">
                    <c:forEach var="v" items="${product.variants}">
                        <option value="${v.variantId}"
                                data-price="${v.price}"
                                data-stock="${v.quantityInStock}"
                                data-image="${v.variantImage}">
                                ${v.color} / ${v.storage} - <fmt:formatNumber value="${v.price}" type="number"/>₫
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-top:8px;">
                <button class="btn add-to-cart-btn add-btn"
                        data-product-id="${product.productId}"
                    ${product.totalStock == 0 ? 'disabled' : ''}>
                    ${product.totalStock == 0 ? 'Hết hàng' : 'Chọn mua'}
                </button>
            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${empty products}">
    <div style="padding: 2rem 0; text-align: center; color: #666;">
        <c:choose>
            <c:when test="${favoritesOnly}">Bạn chưa có sản phẩm yêu thích nào.</c:when>
            <c:otherwise>Không có sản phẩm phù hợp.</c:otherwise>
        </c:choose>
    </div>
</c:if>

<c:if test="${totalPages > 1}">
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage - 1}${filterQuery}">« Trước</a>
        </c:if>
        <c:forEach var="p" begin="1" end="${totalPages}">
            <c:choose>
                <c:when test="${p == currentPage}">
                    <span class="btn secondary">${p}</span>
                </c:when>
                <c:otherwise>
                    <a class="btn" href="${pageContext.request.contextPath}/products?page=${p}${filterQuery}">${p}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a class="btn" href="${pageContext.request.contextPath}/products?page=${currentPage + 1}${filterQuery}">Tiếp »</a>
        </c:if>
    </div>
</c:if>
