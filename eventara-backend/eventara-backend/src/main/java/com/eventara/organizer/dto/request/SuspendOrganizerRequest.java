package com.eventara.organizer.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SuspendOrganizerRequest {

    @NotBlank(message = "Suspension reason is required")
    private String reason;
}
