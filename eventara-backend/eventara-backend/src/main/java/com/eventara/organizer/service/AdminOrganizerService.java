package com.eventara.organizer.service;

import com.eventara.common.enums.OrganizerStatus;
import com.eventara.organizer.dto.response.OrganizerResponse;

import java.util.List;

public interface AdminOrganizerService {

    List<OrganizerResponse> getAllApplications(OrganizerStatus status);

    OrganizerResponse approveOrganizer(Long organizerId);

    OrganizerResponse rejectOrganizer(Long organizerId, String reason);

    OrganizerResponse suspendOrganizer(Long organizerId, String reason);

    OrganizerResponse reinstateOrganizer(Long organizerId);
}
