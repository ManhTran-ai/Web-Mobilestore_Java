package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Product {
    private Integer productId;
    private String productName;
    private String manufacturer;
    private String productCondition;
    private Long price;
    private String image;
    private String productInfo;
    private Integer quantityInStock;
    private Category category;
    private Long discount;
}
