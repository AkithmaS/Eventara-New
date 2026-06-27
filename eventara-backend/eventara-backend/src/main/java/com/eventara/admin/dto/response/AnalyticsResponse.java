package com.eventara.admin.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class AnalyticsResponse {

    private long totalUsers;
    private long totalOrganizers;
    private long totalEvents;
    private long totalBookings;
    private long totalTicketsIssued;
    private BigDecimal totalRevenue;
    private long pendingOrganizerApplications;
    private long pendingEventApprovals;
}
