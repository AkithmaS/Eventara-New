package com.eventara.organizer.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateOrganizerRequest {

    @NotBlank(message = "Organization name is required")
    private String organizationName;

    private String organizationType;

    private String description;

    private String websiteUrl;
}
