package com.eventara.organizer.service;

import com.eventara.organizer.dto.request.UpdateOrganizerRequest;
import com.eventara.organizer.dto.response.OrganizerDashboardResponse;
import com.eventara.organizer.dto.response.OrganizerResponse;

public interface OrganizerService {

    OrganizerResponse getOrganizerProfile(Long userId);

    OrganizerResponse updateOrganizerProfile(Long userId, UpdateOrganizerRequest request);

    OrganizerDashboardResponse getOrganizerDashboard(Long userId);
}
