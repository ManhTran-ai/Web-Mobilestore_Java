package com.mobilestore.controller;

import com.mobilestore.constant.ProductPriceRange;
import com.mobilestore.constant.ProductSortOrder;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.CategoryService;
import com.mobilestore.service.ReviewService;
import com.mobilestore.service.impl.ProductServiceImpl;
import com.mobilestore.service.impl.CategoryServiceImpl;
import com.mobilestore.service.impl.ReviewServiceImpl;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.Review;
import com.mobilestore.dao.UserLikeDAO;
import com.mobilestore.entity.User;
import com.mobilestore.util.ProductPriceUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductsServlet", urlPatterns = {"/products", "/products/*"})
public class ProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (requestURI.equals(contextPath + "/products/view")) {
            handleProductDetail(request, response);
            return;
        }

        int page = 1;
        int pageSize = 12;
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        String searchKeyword = request.getParameter("search");
        String categoryParam = request.getParameter("category");
        String favoritesParam = request.getParameter("favorites");
        String priceRangeParam = request.getParameter("priceRange");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String sortParam = request.getParameter("sort");

        boolean favoritesOnly = favoritesParam != null && (
            "1".equals(favoritesParam) ||
            "true".equalsIgnoreCase(favoritesParam) ||
            "on".equalsIgnoreCase(favoritesParam)
        );

        if (pageParam != null) {
            try { page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        }
        if (sizeParam != null) {
            try { pageSize = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}
        }

        ProductService productService = new ProductServiceImpl();
        CategoryService categoryService = new CategoryServiceImpl();

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignored) {}
        }

        Long minPrice = parsePriceParam(minPriceParam);
        Long maxPrice = parsePriceParam(maxPriceParam);
        String priceRangeCode = trimToNull(priceRangeParam);
        String priceRangeLabel = null;

        if (minPrice == null && maxPrice == null && priceRangeCode != null) {
            ProductPriceRange preset = ProductPriceRange.fromCode(priceRangeCode);
            if (preset != null) {
                minPrice = preset.getMinPrice();
                maxPrice = preset.getMaxPrice();
                priceRangeLabel = preset.getLabel();
            }
        } else if (minPrice != null || maxPrice != null) {
            priceRangeCode = "custom";
            priceRangeLabel = buildCustomPriceLabel(minPrice, maxPrice);
        }

        ProductSortOrder sortOrder = ProductSortOrder.fromCode(trimToNull(sortParam));
        String sortCode = sortOrder.getCode();
        String sortLabel = sortOrder == ProductSortOrder.DEFAULT ? null : sortOrder.getLabel();

        List<Product> products;
        int totalItems;
        int totalPages;

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        request.setAttribute("favoritesOnly", favoritesOnly);
        request.setAttribute("favoritesRequiresLogin", favoritesOnly && user == null);

        String normalizedSearch = trimToNull(searchKeyword);

        if (favoritesOnly) {
            if (user == null) {
                products = new ArrayList<>();
                totalItems = 0;
                totalPages = 0;
            } else {
                UserLikeDAO userLikeDAO = new UserLikeDAO();
                List<Product> likedProducts = userLikeDAO.findLikedProductsByUser(user.getId());

                List<Product> filtered = likedProducts;
                if (normalizedSearch != null) {
                    String searchLower = normalizedSearch.toLowerCase();
                    filtered = filtered.stream()
                            .filter(p -> p.getProductName() != null && p.getProductName().toLowerCase().contains(searchLower))
                            .toList();
                }
                if (categoryId != null) {
                    Integer finalCategoryId = categoryId;
                    filtered = filtered.stream()
                            .filter(p -> p.getCategory() != null && finalCategoryId.equals(p.getCategory().getCategoryId()))
                            .toList();
                }
                if (minPrice != null || maxPrice != null) {
                    Long finalMin = minPrice;
                    Long finalMax = maxPrice;
                    filtered = filtered.stream()
                            .filter(p -> ProductPriceUtil.matchesPriceRange(p, finalMin, finalMax))
                            .toList();
                }
                filtered = applyPriceSort(filtered, sortOrder);

                totalItems = filtered.size();
                totalPages = (int) Math.ceil((double) totalItems / pageSize);
                if (page > totalPages && totalPages > 0) page = totalPages;

                int fromIndex = Math.max(0, (page - 1) * pageSize);
                int toIndex = Math.min(filtered.size(), fromIndex + pageSize);
                if (fromIndex >= filtered.size()) {
                    products = new ArrayList<>();
                } else {
                    products = new ArrayList<>(filtered.subList(fromIndex, toIndex));
                }
            }
        } else if (normalizedSearch != null) {
            totalItems = productService.countSearch(normalizedSearch, categoryId, minPrice, maxPrice);
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.searchWithFilter(normalizedSearch, categoryId, minPrice, maxPrice, sortCode, page, pageSize).getContent();
        } else if (categoryId != null) {
            totalItems = productService.countSearch(null, categoryId, minPrice, maxPrice);
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.searchWithFilter(null, categoryId, minPrice, maxPrice, sortCode, page, pageSize).getContent();
        } else {
            totalItems = productService.countAll(minPrice, maxPrice);
            totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (page > totalPages && totalPages > 0) page = totalPages;

            products = productService.findByPage(page, pageSize, minPrice, maxPrice, sortCode).getContent();
        }

        List<com.mobilestore.entity.Category> categories = categoryService.findAll();

        if (user != null) {
            UserLikeDAO userLikeDAO = new UserLikeDAO();
            List<Integer> likedProductIds = userLikeDAO.findLikedProductIdsByUser(user.getId());
            request.setAttribute("likedProductIds", likedProductIds);
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("searchKeyword", normalizedSearch);
        request.setAttribute("selectedPriceRange", priceRangeCode);
        request.setAttribute("priceRangeLabel", priceRangeLabel);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("minPriceInput", minPriceParam != null ? minPriceParam.trim() : "");
        request.setAttribute("maxPriceInput", maxPriceParam != null ? maxPriceParam.trim() : "");
        request.setAttribute("selectedSort", sortCode);
        request.setAttribute("sortLabel", sortLabel);
        request.setAttribute("filterQuery", buildFilterQuery(normalizedSearch, categoryId, favoritesOnly,
                priceRangeCode, minPriceParam, maxPriceParam, sortCode));

        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (isAjax) {
            request.getRequestDispatcher("/views/products/shop-main-content.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/products/product-list.jsp").forward(request, response);
        }
    }

    private List<Product> applyPriceSort(List<Product> products, ProductSortOrder sortOrder) {
        if (sortOrder == ProductSortOrder.PRICE_ASC) {
            return products.stream()
                    .sorted(Comparator.comparingLong(ProductPriceUtil::getEffectiveDisplayPrice))
                    .toList();
        }
        if (sortOrder == ProductSortOrder.PRICE_DESC) {
            return products.stream()
                    .sorted(Comparator.comparingLong(ProductPriceUtil::getEffectiveDisplayPrice).reversed())
                    .toList();
        }
        return products;
    }

    private String buildFilterQuery(String search, Integer categoryId, boolean favoritesOnly,
                                    String priceRange, String minPriceInput, String maxPriceInput,
                                    String sortOrder) {
        StringBuilder q = new StringBuilder();
        appendParam(q, "search", search);
        if (categoryId != null) {
            appendParam(q, "category", String.valueOf(categoryId));
        }
        if (favoritesOnly) {
            appendParam(q, "favorites", "1");
        }
        if (minPriceInput != null && !minPriceInput.trim().isEmpty()) {
            appendParam(q, "minPrice", minPriceInput.trim());
        }
        if (maxPriceInput != null && !maxPriceInput.trim().isEmpty()) {
            appendParam(q, "maxPrice", maxPriceInput.trim());
        }
        if ((minPriceInput == null || minPriceInput.trim().isEmpty())
                && (maxPriceInput == null || maxPriceInput.trim().isEmpty())
                && priceRange != null && !priceRange.isBlank()) {
            appendParam(q, "priceRange", priceRange);
        }
        if (sortOrder != null && !sortOrder.isBlank()) {
            appendParam(q, "sort", sortOrder);
        }
        return q.toString();
    }

    private void appendParam(StringBuilder q, String name, String value) {
        if (value == null || value.isBlank()) {
            return;
        }
        q.append("&").append(name).append("=")
                .append(URLEncoder.encode(value, StandardCharsets.UTF_8));
    }

    private String buildCustomPriceLabel(Long minPrice, Long maxPrice) {
        if (minPrice != null && maxPrice != null) {
            return formatVnd(minPrice) + " - " + formatVnd(maxPrice);
        }
        if (minPrice != null) {
            return "Từ " + formatVnd(minPrice);
        }
        return "Đến " + formatVnd(maxPrice);
    }

    private String formatVnd(long amount) {
        return String.format("%,d₫", amount).replace(',', '.');
    }

    private Long parsePriceParam(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            long parsed = Long.parseLong(value.trim().replace(".", "").replace(",", ""));
            return parsed >= 0 ? parsed : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số id sản phẩm");
            return;
        }

        try {
            Integer productId = Integer.parseInt(idParam.trim());
            ProductService productService = new ProductServiceImpl();
            Product product = productService.findById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm");
                return;
            }

            List<Product> relatedProducts = new ArrayList<>();
            if (product.getCategory() != null && product.getCategory().getCategoryId() != null) {
                relatedProducts = productService.findByCategory(product.getCategory().getCategoryId())
                    .stream()
                    .filter(p -> !p.getProductId().equals(product.getProductId()))
                    .limit(7)
                    .toList();
            }

            jakarta.servlet.http.HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

            if (currentUser != null) {
                com.mobilestore.dao.UserLikeDAO userLikeDAO = new com.mobilestore.dao.UserLikeDAO();
                List<Integer> likedProductIds = userLikeDAO.findLikedProductIdsByUser(currentUser.getId());
                request.setAttribute("likedProductIds", likedProductIds);
            }

            ReviewService reviewService = new ReviewServiceImpl();

            String ratingParam = request.getParameter("rating");
            Integer ratingFilter = null;
            if (ratingParam != null && !ratingParam.trim().isEmpty()) {
                try {
                    int parsed = Integer.parseInt(ratingParam.trim());
                    if (parsed >= 1 && parsed <= 5) {
                        ratingFilter = parsed;
                    }
                } catch (NumberFormatException ignored) {}
            }

            List<Review> reviews = reviewService.getReviewsByProductId(productId, ratingFilter);
            double averageRating = reviewService.getAverageRating(productId);
            int reviewCount = reviewService.getReviewCount(productId);
            Map<Integer, Integer> ratingCounts = reviewService.getReviewCountByRatingGroup(productId);

            boolean canReview = false;
            boolean hasPurchased = false;
            if (currentUser != null) {
                canReview = reviewService.canUserReviewProduct(currentUser.getId(), productId);
                hasPurchased = reviewService.hasUserPurchasedProduct(currentUser.getId(), productId);
            }

            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("ratingCounts", ratingCounts);
            request.setAttribute("currentRatingFilter", ratingFilter);
            request.setAttribute("canReview", canReview);
            request.setAttribute("hasPurchased", hasPurchased);
            request.getRequestDispatcher("/views/products/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
