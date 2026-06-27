package com.eventara.event.controller;

import com.eventara.common.enums.EventStatus;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.common.response.ApiResponse;
import com.eventara.event.dto.request.CreateEventRequest;
import com.eventara.event.dto.request.SeatZoneRequest;
import com.eventara.event.dto.response.EventResponse;
import com.eventara.event.service.EventService;
import com.eventara.user.repository.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/organizer/events")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_ORGANIZER')")
public class OrganizerEventController {

    private final EventService eventService;
    private final UserRepository userRepository;

    // GET /api/organizer/events
    @GetMapping
    public ResponseEntity<ApiResponse<List<EventResponse>>> getOrganizerEvents() {
        Long organizerId = resolveOrganizerId();
        return ResponseEntity.ok(ApiResponse.success(
                eventService.getOrganizerEvents(organizerId), "Events fetched successfully"));
    }

    // GET /api/organizer/events/status?status=DRAFT
    @GetMapping("/status")
    public ResponseEntity<ApiResponse<List<EventResponse>>> getOrganizerEventsByStatus(
            @RequestParam EventStatus status) {
        Long organizerId = resolveOrganizerId();
        return ResponseEntity.ok(ApiResponse.success(
                eventService.getOrganizerEventsByStatus(organizerId, status), "Events fetched successfully"));
    }

    // POST /api/organizer/events
    @PostMapping
    public ResponseEntity<ApiResponse<EventResponse>> createEvent(
            @Valid @RequestBody CreateEventRequest request) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.createEvent(organizerId, request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(response, "Event created successfully"));
    }

    // PUT /api/organizer/events/{id}
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<EventResponse>> updateEvent(
            @PathVariable Long id,
            @Valid @RequestBody CreateEventRequest request) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.updateEvent(id, organizerId, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Event updated successfully"));
    }

    // POST /api/organizer/events/{id}/submit
    @PostMapping("/{id}/submit")
    public ResponseEntity<ApiResponse<EventResponse>> submitForReview(@PathVariable Long id) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.submitForReview(id, organizerId);
        return ResponseEntity.ok(ApiResponse.success(response, "Event submitted for review"));
    }

    // POST /api/organizer/events/{id}/cancel
    @PostMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<EventResponse>> cancelEvent(@PathVariable Long id) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.cancelEvent(id, organizerId);
        return ResponseEntity.ok(ApiResponse.success(response, "Event cancelled successfully"));
    }

    // POST /api/organizer/events/{id}/seatmap
    @PostMapping("/{id}/seatmap")
    public ResponseEntity<ApiResponse<EventResponse>> saveSeatMap(
            @PathVariable Long id,
            @RequestBody String seatMapJson) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.saveSeatMap(id, organizerId, seatMapJson);
        return ResponseEntity.ok(ApiResponse.success(response, "Seat map saved successfully"));
    }

    // POST /api/organizer/events/{id}/pricing
    @PostMapping("/{id}/pricing")
    public ResponseEntity<ApiResponse<EventResponse>> saveZonePricing(
            @PathVariable Long id,
            @RequestBody List<SeatZoneRequest> zones) {
        Long organizerId = resolveOrganizerId();
        EventResponse response = eventService.saveZonePricing(id, organizerId, zones);
        return ResponseEntity.ok(ApiResponse.success(response, "Zone pricing saved successfully"));
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Long resolveOrganizerId() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"))
                .getId();
    }
}
