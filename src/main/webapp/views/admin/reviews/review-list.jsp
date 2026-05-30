<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đánh giá - Trang quản lý</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-layout.css">
    <style>
        .review-product { font-weight: 600; color: #0071e3; font-size: 0.95rem; }
        .review-user { font-weight: 500; }
        .review-comment { font-size: 0.9rem; color: #444; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .review-date { color: #888; font-size: 0.85rem; white-space: nowrap; }
        .stars { color: #ff9500; font-size: 0.9rem; letter-spacing: 2px; }
        .status-badge { display: inline-block; padding: 0.375rem 0.75rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .status-badge.status-pending { background: #fff3cd; color: #856404; }
        .status-badge.status-approved { background: #d4edda; color: #155724; }
        .actions { display: flex; gap: 0.5rem; flex-wrap: wrap; }

        .modal-product-name { font-weight: 600; color: #1a1a1a; }
    </style>
</head>
<body>
<div class="admin-container">
    <c:set var="activeMenu" value="reviews" scope="request"/>
    <jsp:include page="/views/common/admin-header.jsp"/>

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

        <div class="table-container" style="margin-bottom: 2rem;">
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
                            <tr data-review-id="${r.id}">
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
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.adminReply}">
                                            <div><strong>Admin:</strong> ${r.adminReply}</div>
                                            <small style="color:#888;">
                                                <fmt:formatDate value="${r.adminReplyAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="review-date">
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="actions">
                                    <button type="button" class="btn btn-primary btn-sm approve-btn" data-id="${r.id}">&#10004; Duyệt</button>
                                    <button type="button" class="btn btn-info btn-sm reply-btn" data-id="${r.id}" data-reply="${r.adminReply}">💬 Reply</button>
                                    <button type="button" class="btn btn-danger btn-sm delete-btn" data-id="${r.id}">🗑️ Xóa</button>
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
                <span class="table-info">Hiển thị ${allReviews.size()} đánh giá</span>
            </div>
            <c:choose>
                <c:when test="${empty allReviews}">
                    <div class="empty-state">
                        <div class="icon">🎬</div>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.adminReply}">
                                            <div><strong>Admin:</strong> ${r.adminReply}</div>
                                            <small style="color:#888;">
                                                <fmt:formatDate value="${r.adminReplyAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
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
                                        <button type="button" class="btn btn-primary btn-sm approve-btn" data-id="${r.id}">&#10004; Duyệt</button>
                                    </c:if>
                                    <button type="button" class="btn btn-info btn-sm reply-btn" data-id="${r.id}" data-reply="${r.adminReply}">💬 Reply</button>
                                    <button type="button" class="btn btn-danger btn-sm delete-btn" data-id="${r.id}">🗑️ Xóa</button>
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
        <div class="modal-icon warning">⚠️</div>
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
        <div class="modal-icon success">💬</div>
        <h3>Phản hồi đánh giá #<span id="replyReviewId"></span></h3>
        <form id="replyForm" method="POST" action="${pageContext.request.contextPath}/admin/reviews/reply">
            <input type="hidden" name="id" id="replyIdInput">
            <div style="margin-bottom: 1rem;">
                <textarea name="adminReply" id="replyText" rows="4" style="width:100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 0.9rem; resize: vertical;" placeholder="Nhập phản hồi của bạn..." required></textarea>
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
    var replyIdInput = document.getElementById('replyIdInput');
    var replyText = document.getElementById('replyText');
    var cancelReplyBtn = document.getElementById('cancelReplyBtn');

    document.querySelectorAll('.delete-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            modalReviewId.textContent = this.dataset.id;
            deleteForm.action = contextPath + '/admin/reviews/reject?id=' + this.dataset.id;
            deleteModal.classList.add('active');
        });
    });

    cancelDeleteBtn.addEventListener('click', function() { deleteModal.classList.remove('active'); });
    deleteModal.addEventListener('click', function(e) { if (e.target === deleteModal) deleteModal.classList.remove('active'); });

    document.querySelectorAll('.reply-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            replyIdInput.value = this.dataset.id;
            replyText.value = this.dataset.reply || '';
            replyModal.classList.add('active');
        });
    });

    cancelReplyBtn.addEventListener('click', function() { replyModal.classList.remove('active'); });
    replyModal.addEventListener('click', function(e) { if (e.target === replyModal) replyModal.classList.remove('active'); });

    document.querySelectorAll('.approve-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            modalApproveId.textContent = this.dataset.id;
            approveForm.action = contextPath + '/admin/reviews/approve?id=' + this.dataset.id;
            approveModal.classList.add('active');
        });
    });

    cancelApproveBtn.addEventListener('click', function() { approveModal.classList.remove('active'); });
    approveModal.addEventListener('click', function(e) { if (e.target === approveModal) approveModal.classList.remove('active'); });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            deleteModal.classList.remove('active');
            approveModal.classList.remove('active');
            replyModal.classList.remove('active');
        }
    });

    setTimeout(function() {
        document.querySelectorAll('.alert-success').forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() { alert.style.display = 'none'; }, 500);
        });
    }, 5000);
</script>
</body>
</html>
