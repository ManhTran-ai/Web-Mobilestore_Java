package com.mobilestore.service;

import com.mobilestore.entity.Review;
import java.util.List;

public interface ReviewService {
    List<Review> getReviewsByProductId(int productId);
    List<Review> getAllReviews();
    List<Review> getPendingReviewsForAdmin();
    boolean canUserReviewProduct(int userId, int productId);
    boolean hasUserPurchasedProduct(int userId, int productId);
    Review createReview(int userId, int productId, int rating, String comment);
    Review updateReview(int reviewId, int userId, int rating, String comment);
    boolean deleteReview(int reviewId, int userId);
    boolean approveReview(int reviewId);
    boolean rejectReview(int reviewId);
    boolean replyReview(int reviewId, String adminReply);
    double getAverageRating(int productId);
    int getReviewCount(int productId);
}
