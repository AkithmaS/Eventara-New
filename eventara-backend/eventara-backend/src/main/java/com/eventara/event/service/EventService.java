package com.eventara.event.service;

import com.eventara.common.enums.EventStatus;
import com.eventara.event.dto.request.CreateEventRequest;
import com.eventara.event.dto.request.SeatZoneRequest;
import com.eventara.event.dto.response.EventResponse;

import java.util.List;

public interface EventService {

    EventResponse createEvent(Long organizerId, CreateEventRequest request);

    EventResponse updateEvent(Long eventId, Long organizerId, CreateEventRequest request);

    EventResponse submitForReview(Long eventId, Long organizerId);

    EventResponse cancelEvent(Long eventId, Long organizerId);

    List<EventResponse> getPublishedEvents(Long categoryId, String keyword);

    List<EventResponse> getOrganizerEvents(Long organizerId);

    List<EventResponse> getOrganizerEventsByStatus(Long organizerId, EventStatus status);

    EventResponse getEventById(Long eventId);

    EventResponse saveSeatMap(Long eventId, Long organizerId, String seatMapJson);

    EventResponse saveZonePricing(Long eventId, Long organizerId, List<SeatZoneRequest> zones);
}
