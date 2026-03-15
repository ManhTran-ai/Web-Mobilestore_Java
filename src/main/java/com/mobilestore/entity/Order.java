package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Order {
    private Integer orderId;
    private String orderStatus;
    private Date orderDate;
    private Double totalAmount;
    private User user;
    private List<OrderDetail> details;
    private String shippingAddress;
    private String customerPhone;
    private String note;
    private String paymentMethod;
    private String paymentStatus;
    private String vnpTransactionId;
    private String vnpOrderId;
}
