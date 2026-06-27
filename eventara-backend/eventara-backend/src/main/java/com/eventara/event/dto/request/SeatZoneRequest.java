package com.eventara.event.dto.request;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class SeatZoneRequest {

    private String zoneName;
    private String zoneColor;
    private BigDecimal price;
    private Integer totalSeats;
}
