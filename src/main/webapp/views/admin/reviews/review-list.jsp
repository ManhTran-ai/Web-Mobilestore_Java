<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đánh giá - Trang quản lý</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #f5f5f7;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: #1a1a1a;
            color: #ffffff;
            padding: 2rem 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 0 1.5rem 2rem;
            border-bottom: 1px solid #333;
            margin-bottom: 1rem;
        }

        .sidebar-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #ffffff;
        }

        .sidebar-header span {
            font-size: 0.875rem;
            color: #888;
        }

        .sidebar-nav {
            list-style: none;
        }

        .sidebar-nav li {
            margin: 0.25rem 0;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 0.875rem 1.5rem;
            color: #ccc;
            text-decoration: none;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background: #333;
            color: #ffffff;
        }

        .sidebar-nav a.active {
            border-left: 3px solid #0071e3;
        }

        .sidebar-nav .icon {
            margin-right: 0.75rem;
            font-size: 1.1rem;
        }

        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .header-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary {
            background: #0071e3 !important;
            color: #ffffff !important;
        }

        .btn-primary:hover {
            background: #0077ed !important;
        }

        .btn-danger {
            background: #ff3b30 !important;
            color: #ffffff !important;
        }

        .btn-danger:hover {
            background: #ff453a !important;
        }

        .btn-secondary {
            background: #e5e5ea !important;
            color: #1a1a1a !important;
        }

        .btn-secondary:hover {
            background: #d1d1d6 !important;
        }

        .btn-info {
            background: #5856d6 !important;
            color: #ffffff !important;
        }

        .btn-info:hover {
            background: #4b49c0 !important;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background: #d1f2eb;
            color: #0d6848;
            border: 1px solid #a3e4d7;
        }

        .alert-error {
            background: #fdecea;
            color: #c62828;
            border: 1px solid #f5c6cb;
        }

        .alert .close-btn {
            margin-left: auto;
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
            opacity: 0.5;
            transition: opacity 0.2s;
        }

        .alert .close-btn:hover {
            opacity: 1;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .stat-card .label {
            font-size: 0.85rem;
            color: #888;
            margin-bottom: 0.5rem;
        }

        .stat-card .value {
            font-size: 1.75rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .stat-card.primary .value {
            color: #0071e3;
        }

        .stat-card.success .value {
            color: #34c759;
        }

        .stat-card.warning .value {
            color: #ff9500;
        }

        .table-container {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .table-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e5ea;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a1a;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 1rem 1.25rem;
            text-align: left;
            border-bottom: 1px solid #e5e5ea;
        }

        .data-table th {
            background: #f5f5f7;
            font-weight: 600;
            color: #666;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table tbody tr {
            transition: background 0.2s;
        }

        .data-table tbody tr:hover {
            background: #fafafa;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .review-product {
            font-weight: 600;
            color: #0071e3;
            font-size: 0.95rem;
        }

        .review-user {
            font-weight: 500;
        }

        .review-comment {
            font-size: 0.9rem;
            color: #444;
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .review-date {
            color: #888;
            font-size: 0.85rem;
            white-space: nowrap;
        }

        .stars {
            color: #ff9500;
            font-size: 0.9rem;
            letter-spacing: 2px;
        }

        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.status-approved {
            background: #d4edda;
            color: #155724;
        }

        .actions {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #888;
        }

        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: #666;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal {
            background: #ffffff;
            border-radius: 16px;
            padding: 2rem;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalIn 0.3s ease;
        }

        @keyframes modalIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .modal-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .modal-icon.warning {
            color: #ff9500;
        }

        .modal-icon.success {
            color: #34c759;
        }

        .modal h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: #1a1a1a;
        }

        .modal p {
            color: #666;
            margin-bottom: 1.5rem;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .modal-actions .btn {
            min-width: 120px;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .data-table {
                font-size: 0.875rem;
            }

            .data-table th,
            .data-table td {
                padding: 0.75rem;
            }
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
                <li>
                    <a href="${pageContext.request.contextPath}/">
                        Trang chủ
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/products">
                        Sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders">
                        Đơn hàng
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/sliders">
                        Slider Images
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/reviews" class="active">
                        Đánh giá
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h1>Quản lý Đánh giá Sản phẩm</h1>
        </div>

        <c:if test="${param.success == 'approved'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Duyệt đánh giá thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.success == 'rejected'}">
            <div class="alert alert-success" id="alertSuccess">
                <span>&#10004;</span> Từ chối đánh giá thành công!
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'approve_failed'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không thể duyệt đánh giá.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'reject_failed'}">
            <div class="alert alert-error">
                <span>&#10008;</span> Không thể từ chối đánh giá.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_id'}">
            <div class="alert alert-error">
                <span>&#10008;</span> ID đánh giá không hợp lệ.
                <button class="close-btn" onclick="this.parentElement.style.display='none'">&times;</button>
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card warning">
                <div class="label">Chờ duyệt</div>
                <div class="value">${pendingReviews.size()}</div>
            </div>
            <div class="stat-card success">
                <div class="label">Đã duyệt</div>
                <div class="value">${allReviews.size() - pendingReviews.size()}</div>
            </div>
            <div class="stat-card primary">
                <div class="label">Tổng đánh giá</div>
                <div class="value">${allReviews.size()}</div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Chờ duyệt (${pendingReviews.size()})</h3>
            </div>
            <c:choose>
                <c:when test="${empty pendingReviews}">
                    <div class="empty-state">
                        <h3>Không có đánh giá nào chờ duyệt</h3>
                        <p>Tất cả đánh giá đã được xử lý.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="pendingTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sản phẩm</th>
                            <th>Người dùng</th>
                            <th>Rating</th>
                            <th>Nội dung</th>
                            <th>Phản hồi</th>
                            <th>Ngày</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="r" items="${pendingReviews}">
                            <tr data-review-id="${r.id}" data-product="${r.product.productName}" data-user="${r.user.username}">
                                <td>#${r.id}</td>
                                <td class="review-product">${r.product.productName}</td>
                                <td class="review-user">${r.user.username}</td>
                                <td>
                                    <span class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= r.rating}">&#9733;</c:when>
                                                <c:otherwise>&#9734;</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                </td>
                                <td class="review-comment" title="${r.comment}">
                                        ${not empty r.comment ? r.comment : '(Không có bình luận)'}
                                </td>
                                <td class="review-reply">
                                    <c:choose>
                                        <c:when test="${not empty r.adminReply}">
                                            <div class="reply-content">
                                                <strong>Admin:</strong> ${r.adminReply}
                                                <br><small style="color:#888;">
                                                    <fmt:formatDate value="${r.adminReplyAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="review-date">
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="actions">
                                    <button type="button"
                                            class="btn btn-primary btn-sm approve-btn"
                                            data-id="${r.id}"
                                            data-product="${r.product.productName}"
                                            title="Duyệt đánh giá">
                                        &#10004; Duyệt
                                    </button>
                                    <button type="button"
                                            class="btn btn-info btn-sm reply-btn"
                                            data-id="${r.id}"
                                            data-reply="${r.adminReply}"
                                            title="Phản hồi">
                                        &#128172; Reply
                                    </button>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${r.id}"
                                            data-product="${r.product.productName}"
                                            data-user="${r.user.username}"
                                            title="Xóa đánh giá">
                                        &#128465; Xóa
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3>Tất cả đánh giá (${allReviews.size()})</h3>
                <span style="font-size: 0.9rem; color: #888;">Hiển thị ${allReviews.size()} đánh giá</span>
            </div>
            <c:choose>
                <c:when test="${empty allReviews}">
                    <div class="empty-state">
                        <div class="icon">&#127909;</div>
                        <h3>Chưa có đánh giá nào</h3>
                        <p>Đánh giá sẽ xuất hiện khi khách hàng đánh giá sản phẩm.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table" id="allTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sản phẩm</th>
                            <th>Người dùng</th>
                            <th>Rating</th>
                            <th>Nội dung</th>
                            <th>Phản hồi</th>
                            <th>Ngày</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="r" items="${allReviews}">
                            <tr>
                                <td>#${r.id}</td>
                                <td class="review-product">${r.product.productName}</td>
                                <td class="review-user">${r.user.username}</td>
                                <td>
                                    <span class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= r.rating}">&#9733;</c:when>
                                                <c:otherwise>&#9734;</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                </td>
                                <td class="review-comment" title="${r.comment}">
                                        ${not empty r.comment ? r.comment : '(Không có bình luận)'}
                                </td>
                                <td class="review-reply">
                                    <c:choose>
                                        <c:when test="${not empty r.adminReply}">
                                            <div class="reply-content">
                                                <strong>Admin:</strong> ${r.adminReply}
                                                <br><small style="color:#888;">
                                                    <fmt:formatDate value="${r.adminReplyAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="review-date">
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <span class="status-badge ${r.isApproved ? 'status-approved' : 'status-pending'}">
                                            ${r.isApproved ? 'Đã duyệt' : 'Chờ duyệt'}
                                    </span>
                                </td>
                                <td class="actions">
                                    <c:if test="${not r.isApproved}">
                                        <button type="button"
                                                class="btn btn-primary btn-sm approve-btn"
                                                data-id="${r.id}"
                                                data-product="${r.product.productName}"
                                                title="Duyệt đánh giá">
                                            &#10004; Duyệt
                                        </button>
                                    </c:if>
                                    <button type="button"
                                            class="btn btn-info btn-sm reply-btn"
                                            data-id="${r.id}"
                                            data-reply="${r.adminReply}"
                                            title="Phản hồi">
                                        &#128172; Reply
                                    </button>
                                    <button type="button"
                                            class="btn btn-danger btn-sm delete-btn"
                                            data-id="${r.id}"
                                            data-product="${r.product.productName}"
                                            data-user="${r.user.username}"
                                            title="Xóa đánh giá">
                                        &#128465; Xóa
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

<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-icon warning">&#9888;</div>
        <h3>Xác nhận xóa đánh giá</h3>
        <p>Bạn có chắc chắn muốn xóa đánh giá #<span id="modalReviewId"></span>?</p>
        <p style="font-size: 0.85rem; color: #ff3b30;">Hành động này không thể hoàn tác!</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelDeleteBtn">Hủy bỏ</button>
            <form id="deleteForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-danger">Xóa đánh giá</button>
            </form>
        </div>
    </div>
</div>

<div class="modal-overlay" id="approveModal">
    <div class="modal">
        <div class="modal-icon success">&#10004;</div>
        <h3>Xác nhận duyệt đánh giá</h3>
        <p>Bạn có chắc chắn muốn duyệt đánh giá #<span id="modalApproveId"></span>?</p>
        <p style="font-size: 0.9rem; color: #666;">Đánh giá sẽ được hiển thị trên trang sản phẩm.</p>
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" id="cancelApproveBtn">Hủy bỏ</button>
            <form id="approveForm" method="POST" style="display: inline;">
                <button type="submit" class="btn btn-primary">Duyệt đánh giá</button>
            </form>
        </div>
    </div>
</div>

<div class="modal-overlay" id="replyModal">
    <div class="modal">
        <div class="modal-icon success">&#128172;</div>
        <h3>Phản hồi đánh giá #<span id="replyReviewId"></span></h3>
        <form id="replyForm" method="POST" action="${pageContext.request.contextPath}/admin/reviews/reply">
            <input type="hidden" name="id" id="replyIdInput">
            <div style="margin-bottom: 1rem;">
                <textarea name="adminReply" id="replyText" rows="4" style="width:100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 0.9rem; resize: vertical;"
                          placeholder="Nhập phản hồi của bạn..." required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" id="cancelReplyBtn">Hủy bỏ</button>
                <button type="submit" class="btn btn-info">Gửi phản hồi</button>
            </div>
        </form>
    </div>
</div>

<script>
    var contextPath = '${pageContext.request.contextPath}';

    var deleteModal = document.getElementById('deleteModal');
    var deleteForm = document.getElementById('deleteForm');
    var modalReviewId = document.getElementById('modalReviewId');
    var cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    var approveModal = document.getElementById('approveModal');
    var approveForm = document.getElementById('approveForm');
    var modalApproveId = document.getElementById('modalApproveId');
    var cancelApproveBtn = document.getElementById('cancelApproveBtn');

    var replyModal = document.getElementById('replyModal');
    var replyForm = document.getElementById('replyForm');
    var replyReviewId = document.getElementById('replyReviewId');
    var replyIdInput = document.getElementById('replyIdInput');
    var replyText = document.getElementById('replyText');
    var cancelReplyBtn = document.getElementById('cancelReplyBtn');

    document.querySelectorAll('.delete-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var reviewId = this.dataset.id;
            modalReviewId.textContent = reviewId;
            deleteForm.action = contextPath + '/admin/reviews/reject?id=' + reviewId;
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

    document.querySelectorAll('.reply-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            replyReviewId.textContent = this.dataset.id;
            replyIdInput.value = this.dataset.id;
            replyText.value = this.dataset.reply || '';
            replyModal.classList.add('active');
        });
    });

    cancelReplyBtn.addEventListener('click', function() {
        replyModal.classList.remove('active');
    });

    replyModal.addEventListener('click', function(e) {
        if (e.target === replyModal) {
            replyModal.classList.remove('active');
        }
    });

    document.querySelectorAll('.approve-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var reviewId = this.dataset.id;
            modalApproveId.textContent = reviewId;
            approveForm.action = contextPath + '/admin/reviews/approve?id=' + reviewId;
            approveModal.classList.add('active');
        });
    });

    cancelApproveBtn.addEventListener('click', function() {
        approveModal.classList.remove('active');
    });

    approveModal.addEventListener('click', function(e) {
        if (e.target === approveModal) {
            approveModal.classList.remove('active');
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (deleteModal.classList.contains('active')) {
                deleteModal.classList.remove('active');
            }
            if (approveModal.classList.contains('active')) {
                approveModal.classList.remove('active');
            }
            if (replyModal.classList.contains('active')) {
                replyModal.classList.remove('active');
            }
        }
    });

    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert-success');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() { alert.style.display = 'none'; }, 500);
        });
    }, 5000);
</script>
</body>
</html>
