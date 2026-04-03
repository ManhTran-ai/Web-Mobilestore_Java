package com.mobilestore.dto;

import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ProductFormData {
    private Integer id;

    private String productName;
    private String manufacturer;
    private String productCondition;
    private Long discount;
    private String productInfo;
    private String newCategoryName;
    private Integer categoryId;
    private List<VariantFormData> variants = new ArrayList<>();
    private List<String> errors = new ArrayList<>();

    public boolean isValid() {
        return errors.isEmpty();
    }

    public void addError(String error) {
        errors.add(error);
    }

    public List<String> getErrors() {
        return errors;
    }
}
