package com.mobilestore.service;

import com.mobilestore.entity.CartItem;
import java.util.List;

public interface CartService {
    List<CartItem> findByUserId(Integer userId);
    boolean addItem(Integer userId, Integer variantId, int quantity);
    void upsertCartItem(Integer userId, Integer variantId, Integer quantity);
    void deleteCartItem(Integer userId, Integer variantId);
    void clearCart(Integer userId);
    void clearCartByUser(Integer userId);
}
