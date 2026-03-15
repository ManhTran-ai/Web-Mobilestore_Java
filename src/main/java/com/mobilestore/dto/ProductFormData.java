package com.mobilestore.dto;

import jakarta.validation.constraints.*;
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

    @NotBlank(message = "Product name is required")
    @Size(max = 255, message = "Product name must be less than 255 characters")
    private String productName;

    @NotBlank(message = "Manufacturer is required")
    @Size(max = 100, message = "Manufacturer must be less than 100 characters")
    private String manufacturer;

    @NotBlank(message = "Product condition is required")
    private String productCondition;

    @NotNull(message = "Price is required")
    @Min(value = 1, message = "Price must be greater than 0")
    private Long price;

    @NotNull(message = "Quantity in stock is required")
    @Min(value = 0, message = "Quantity cannot be negative")
    private Integer quantityInStock;

    private String productInfo;
    private String newCategoryName;
    private Integer categoryId;
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
