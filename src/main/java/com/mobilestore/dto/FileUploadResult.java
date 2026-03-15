package com.mobilestore.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class FileUploadResult {
    private boolean success;
    private String filePath;
    private String errorMessage;
}
