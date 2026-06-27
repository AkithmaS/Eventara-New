package com.eventara.event.dto.request;

import com.eventara.common.enums.TicketType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class CreateEventRequest {

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    private LocalDateTime eventDate;

    private LocalDateTime endDate;

    @NotBlank(message = "Venue name is required")
    private String venueName;

    private String venueAddress;

    private String city;

    private Long categoryId;

    @NotNull(message = "Ticket type is required")
    private TicketType ticketType;

    private Integer maxCapacity;

    private BigDecimal generalAdmissionPrice;

    private String bannerImageUrl;
}
