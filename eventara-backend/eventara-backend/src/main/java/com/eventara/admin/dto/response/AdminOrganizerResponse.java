package com.eventara.admin.dto.response;

import com.eventara.common.enums.OrganizerStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class AdminOrganizerResponse {

    private Long id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private OrganizerStatus organizerStatus;
    private String businessName;
    private LocalDateTime appliedAt;
    private LocalDateTime approvedAt;
    private boolean isActive;
}
