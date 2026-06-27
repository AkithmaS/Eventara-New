package com.eventara.event.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EventResponse {

    private Long id;
    private String title;
    private String description;
    private Long organizerId;
    private String organizerName;
    private Long categoryId;
    private String categoryName;
    private String categoryIcon;
    private LocalDateTime eventDate;
    private LocalDateTime endDate;
    private String venueName;
    private String venueAddress;
    private String city;
    private String bannerImageUrl;
    private String status;
    private String ticketType;
    private Integer maxCapacity;
    private BigDecimal generalAdmissionPrice;
    private String seatMapJson;
    private String rejectionNotes;
    private List<SeatZoneResponse> seatZones;
    private LocalDateTime createdAt;
}
