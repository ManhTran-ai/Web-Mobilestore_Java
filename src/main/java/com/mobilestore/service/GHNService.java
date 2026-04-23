package com.mobilestore.service;

import com.mobilestore.entity.ShippingStep;
import java.util.List;

public interface GHNService {
    List<ShippingStep> getShippingHistory(String trackingNumber);
}
