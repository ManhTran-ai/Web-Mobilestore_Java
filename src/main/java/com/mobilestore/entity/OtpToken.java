package com.mobilestore.entity;

import java.time.LocalDateTime;

public class OtpToken {
    private int id;
    private String email;
    private String otpCode;
    private LocalDateTime createdAt;
    private LocalDateTime expiredAt;
    private boolean isUsed;
    private int attemptCount;

    public OtpToken() {}

    public OtpToken(String email, String otpCode, LocalDateTime expiredAt) {
        this.email = email;
        this.otpCode = otpCode;
        this.expiredAt = expiredAt;
        this.isUsed = false;
        this.attemptCount = 0;
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiredAt);
    }

    public boolean isMaxAttemptReached() {
        return this.attemptCount >= 3;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getExpiredAt() { return expiredAt; }
    public void setExpiredAt(LocalDateTime expiredAt) { this.expiredAt = expiredAt; }
    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean used) { isUsed = used; }
    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }
}
