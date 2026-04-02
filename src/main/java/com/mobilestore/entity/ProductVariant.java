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
public class ProductVariant {
    private Integer variantId;
    private String color;
    private String storage;
    private Long price;
    private Integer quantityInStock;
    private String variantImage;
    private Product product;
}
