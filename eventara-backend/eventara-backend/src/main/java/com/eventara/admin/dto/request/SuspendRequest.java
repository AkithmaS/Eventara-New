package com.eventara.admin.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SuspendRequest {

    @NotBlank(message = "Suspension reason is required")
    private String reason;
}
