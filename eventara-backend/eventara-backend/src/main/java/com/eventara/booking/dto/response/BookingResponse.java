package com.eventara.booking.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingResponse {

    private Long id;
    private String bookingReference;
    private Long eventId;
    private String eventName;
    private String eventDate;
    private String venueName;
    private String seatDetails;
    private Integer quantity;
    private BigDecimal totalAmount;
    private String status;
    private LocalDateTime bookingDate;
}
