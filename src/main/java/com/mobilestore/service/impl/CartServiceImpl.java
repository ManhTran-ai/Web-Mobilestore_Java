package com.mobilestore.service.impl;

import com.mobilestore.dao.CartDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.entity.CartItem;
import com.mobilestore.service.CartService;
import java.util.List;

public class CartServiceImpl implements CartService {
    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    public List<CartItem> findByUserId(Integer userId) {
        return cartDAO.findByUserId(userId);
    }

    @Override
    public boolean addItem(Integer userId, Integer productId, int quantity) {
        try {
            cartDAO.upsertCartItem(userId, productId, quantity);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public void upsertCartItem(Integer userId, Integer productId, Integer quantity) {
        cartDAO.upsertCartItem(userId, productId, quantity);
    }

    @Override
    public void deleteCartItem(Integer userId, Integer productId) {
        cartDAO.deleteCartItem(userId, productId);
    }

    @Override
    public void clearCart(Integer userId) {
        cartDAO.clearCartByUser(userId);
    }

    @Override
    public void clearCartByUser(Integer userId) {
        cartDAO.clearCartByUser(userId);
    }
}
