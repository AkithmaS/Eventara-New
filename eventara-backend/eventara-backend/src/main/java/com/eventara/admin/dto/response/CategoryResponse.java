package com.eventara.admin.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class CategoryResponse {

    private Long id;
    private String name;
    private String icon;
    private String description;
    private boolean isActive;
    private LocalDateTime createdAt;
}
