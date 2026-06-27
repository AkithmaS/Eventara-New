package com.eventara.event.service;

import com.eventara.common.enums.EventStatus;
import com.eventara.event.dto.response.EventResponse;

import java.util.List;

public interface AdminEventService {

    List<EventResponse> getEventsByStatus(EventStatus status);

    List<EventResponse> getAllEvents();

    EventResponse approveEvent(Long eventId);

    EventResponse rejectEvent(Long eventId, String notes);
}
