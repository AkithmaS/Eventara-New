package com.eventara.notification.dto;

import com.eventara.notification.entity.NotificationType;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class NotificationResponse {

    private Long id;
    private String title;
    private String message;
    private NotificationType type;
    private boolean isRead;
    private Long referenceId;
    private String referenceType;
    private LocalDateTime createdAt;
}
