package com.eventara.admin.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class AuditLogResponse {

    private Long id;
    private String actorEmail;
    private String action;
    private String targetType;
    private Long targetId;
    private String details;
    private LocalDateTime performedAt;
}
