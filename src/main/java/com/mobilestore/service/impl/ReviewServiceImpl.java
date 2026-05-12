package com.mobilestore.service.impl;

import com.mobilestore.dao.ReviewDAO;
import com.mobilestore.entity.Product;
import com.mobilestore.entity.Review;
import com.mobilestore.entity.User;
import com.mobilestore.service.ReviewService;

import java.util.List;

public class ReviewServiceImpl implements ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        return reviewDAO.findByProductId(productId);
    }

    @Override
    public List<Review> getAllReviews() {
        return reviewDAO.findAll();
    }

    @Override
    public List<Review> getPendingReviewsForAdmin() {
        return reviewDAO.findPendingReviews();
    }

    @Override
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        if (userId <= 0 || productId <= 0) return false;
        return reviewDAO.hasUserPurchasedProduct(userId, productId);
    }

    @Override
    public boolean canUserReviewProduct(int userId, int productId) {
        if (userId <= 0 || productId <= 0) return false;
        boolean purchased = reviewDAO.hasUserPurchasedProduct(userId, productId);
        boolean alreadyReviewed = reviewDAO.hasUserReviewedProduct(userId, productId);
        return purchased && !alreadyReviewed;
    }

    @Override
    public Review createReview(int userId, int productId, int rating, String comment) {
        if (rating < 1 || rating > 5) return null;
        if (!canUserReviewProduct(userId, productId)) return null;

        User user = new User();
        user.setId(userId);

        Product product = new Product();
        product.setProductId(productId);

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setRating(rating);
        review.setComment(comment != null ? comment.trim() : null);
        review.setIsApproved(false);

        return reviewDAO.save(review);
    }

    @Override
    public Review updateReview(int reviewId, int userId, int rating, String comment) {
        if (rating < 1 || rating > 5) return null;
        if (reviewId <= 0 || userId <= 0) return null;

        Review existing = reviewDAO.findById(reviewId);
        if (existing == null || existing.getUser().getId() != userId) return null;

        existing.setRating(rating);
        existing.setComment(comment != null ? comment.trim() : null);
        existing.setIsApproved(false);
        return reviewDAO.save(existing);
    }

    @Override
    public boolean deleteReview(int reviewId, int userId) {
        if (reviewId <= 0 || userId <= 0) return false;
        Review existing = reviewDAO.findById(reviewId);
        if (existing == null || existing.getUser().getId() != userId) return false;
        return reviewDAO.delete(reviewId);
    }

    @Override
    public boolean approveReview(int reviewId) {
        if (reviewId <= 0) return false;
        return reviewDAO.approveReview(reviewId);
    }

    @Override
    public boolean rejectReview(int reviewId) {
        if (reviewId <= 0) return false;
        return reviewDAO.rejectReview(reviewId);
    }

    @Override
    public boolean replyReview(int reviewId, String adminReply) {
        if (reviewId <= 0 || adminReply == null) return false;
        return reviewDAO.updateAdminReply(reviewId, adminReply.trim());
    }

    @Override
    public double getAverageRating(int productId) {
        return reviewDAO.getAverageRating(productId);
    }

    @Override
    public int getReviewCount(int productId) {
        return reviewDAO.getReviewCount(productId);
    }
}
