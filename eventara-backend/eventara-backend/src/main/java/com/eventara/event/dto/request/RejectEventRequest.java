package com.eventara.event.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RejectEventRequest {

    @NotBlank(message = "Rejection notes are required")
    private String notes;
}
