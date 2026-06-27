package com.eventara.admin.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class AdminEventResponse {

    private Long id;
    private String title;
    private String description;
    private String category;
    private String organizerName;
    private String organizerEmail;
    private LocalDateTime eventDate;
    private String venue;
    private String eventType;
    private String eventStatus;
    private BigDecimal ticketPrice;
    private Integer capacity;
    private LocalDateTime createdAt;
    private LocalDateTime submittedAt;
}
