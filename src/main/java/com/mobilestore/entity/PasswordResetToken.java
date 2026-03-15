package com.mobilestore.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetToken {
    private Integer id;
    private String token;
    private Integer userId;
    private String email;
    private LocalDateTime expiresAt;
    private boolean used;
    private LocalDateTime createdAt;
}
