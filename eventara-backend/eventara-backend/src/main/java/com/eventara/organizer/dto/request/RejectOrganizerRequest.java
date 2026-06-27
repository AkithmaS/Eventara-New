package com.eventara.organizer.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RejectOrganizerRequest {

    @NotBlank(message = "Rejection reason is required")
    private String reason;
}
