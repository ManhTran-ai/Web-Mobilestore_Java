package com.mobilestore.service;

public interface ShippingService {
    long calculateShippingFee(int toDistrictId, String toWardCode);
}
