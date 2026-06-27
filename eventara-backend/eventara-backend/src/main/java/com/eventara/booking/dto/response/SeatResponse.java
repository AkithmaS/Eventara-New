package com.eventara.booking.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SeatResponse {

    private Long id;
    private Long eventId;
    private String rowLabel;
    private Integer seatNumber;
    private String status;
    private Long zoneId;
}
