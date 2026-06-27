package com.eventara.booking.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CreateBookingRequest {

    @NotNull(message = "Event ID is required")
    private Long eventId;

    // For SEATED events — seat IDs previously locked
    private List<Long> seatIds;

    // For GENERAL_ADMISSION events
    private Integer quantity;
}
