package com.eventara.organizer.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrganizerDashboardResponse {

    private long totalEvents;
    private long totalBookings;
    private BigDecimal totalRevenue;
    private long totalAttendees;
}
