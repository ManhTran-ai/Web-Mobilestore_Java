package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Integer id;
    private String username;
    private String password;
    private String roleName;
    private String oauthProvider;
    private String oauthId;
    private String email;
    private String shippingAddress;
    private String customerPhone;
    private String note;
    private Integer districtId;
    private String wardCode;
}
