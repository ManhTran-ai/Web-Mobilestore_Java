package com.mobilestore.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ValidationResult {
    private boolean valid;
    private String errorCode;

}
