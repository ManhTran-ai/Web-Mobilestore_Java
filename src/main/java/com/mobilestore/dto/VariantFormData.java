package com.mobilestore.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class VariantFormData {
    private Integer variantId;
    private Integer variantIndex;
    private String color;
    private String storage;
    private Long price;
    private Integer quantityInStock;
    private String uploadedImageFile;
}
