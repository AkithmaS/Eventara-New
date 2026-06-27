package com.eventara.organizer.dto.response;

import com.eventara.common.enums.OrganizerStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrganizerResponse {

    private Long id;

    // User fields
    private Long userId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String profileImageUrl;

    // Organizer fields
    private String organizationName;
    private String organizationType;
    private String description;
    private String websiteUrl;
    private OrganizerStatus status;
    private String rejectionReason;
    private LocalDateTime appliedAt;
    private LocalDateTime reviewedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
