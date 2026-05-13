package com.mobilestore.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Review {
    private Integer id;
    private User user;
    private Product product;
    private Integer rating;
    private String comment;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Boolean isApproved;
    private String adminReply;
    private Timestamp adminReplyAt;
}
