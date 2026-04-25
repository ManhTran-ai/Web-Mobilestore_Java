package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SliderImage {
    private Integer id;
    private String imageUrl;
    private Boolean isActive;

    public boolean isActive() {
        return Boolean.TRUE.equals(isActive);
    }
}
