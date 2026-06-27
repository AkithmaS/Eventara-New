package com.eventara.event.service;

import com.eventara.booking.service.BookingService;
import com.eventara.common.enums.EventStatus;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ForbiddenException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.dto.request.CreateEventRequest;
import com.eventara.event.dto.request.SeatZoneRequest;
import com.eventara.event.dto.response.EventResponse;
import com.eventara.event.dto.response.SeatZoneResponse;
import com.eventara.event.entity.Category;
import com.eventara.event.entity.Event;
import com.eventara.event.entity.SeatZone;
import com.eventara.event.repository.CategoryRepository;
import com.eventara.event.repository.EventRepository;
import com.eventara.event.repository.SeatZoneRepository;
import com.eventara.notification.entity.NotificationType;
import com.eventara.notification.service.NotificationService;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Stream;

@Slf4j
@Service
public class EventServiceImpl implements EventService {

    private final EventRepository eventRepository;
    private final SeatZoneRepository seatZoneRepository;
    private final CategoryRepository categoryRepository;
    private final OrganizerRepository organizerRepository;
    private final BookingService bookingService;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public EventServiceImpl(EventRepository eventRepository,
                            SeatZoneRepository seatZoneRepository,
                            CategoryRepository categoryRepository,
                            OrganizerRepository organizerRepository,
                            @Lazy BookingService bookingService,
                            UserRepository userRepository,
                            @Lazy NotificationService notificationService) {
        this.eventRepository = eventRepository;
        this.seatZoneRepository = seatZoneRepository;
        this.categoryRepository = categoryRepository;
        this.organizerRepository = organizerRepository;
        this.bookingService = bookingService;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    // ── Create ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse createEvent(Long organizerId, CreateEventRequest request) {
        Event event = Event.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .organizerId(organizerId)
                .categoryId(request.getCategoryId())
                .eventDate(request.getEventDate())
                .endDate(request.getEndDate())
                .venueName(request.getVenueName())
                .venueAddress(request.getVenueAddress())
                .city(request.getCity())
                .bannerImageUrl(request.getBannerImageUrl())
                .ticketType(request.getTicketType())
                .maxCapacity(request.getMaxCapacity())
                .generalAdmissionPrice(request.getGeneralAdmissionPrice())
                .status(EventStatus.DRAFT)
                .build();

        return toResponse(eventRepository.save(event));
    }

    // ── Update ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse updateEvent(Long eventId, Long organizerId, CreateEventRequest request) {
        Event event = findById(eventId);
        verifyOwnership(event, organizerId);

        if (event.getStatus() != EventStatus.DRAFT && event.getStatus() != EventStatus.REJECTED) {
            throw new BadRequestException("Only DRAFT or REJECTED events can be updated");
        }

        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setCategoryId(request.getCategoryId());
        event.setEventDate(request.getEventDate());
        event.setEndDate(request.getEndDate());
        event.setVenueName(request.getVenueName());
        event.setVenueAddress(request.getVenueAddress());
        event.setCity(request.getCity());
        event.setBannerImageUrl(request.getBannerImageUrl());
        event.setTicketType(request.getTicketType());
        event.setMaxCapacity(request.getMaxCapacity());
        event.setGeneralAdmissionPrice(request.getGeneralAdmissionPrice());

        return toResponse(eventRepository.save(event));
    }

    // ── Submit for Review ────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse submitForReview(Long eventId, Long organizerId) {
        Event event = findById(eventId);
        verifyOwnership(event, organizerId);

        if (event.getStatus() != EventStatus.DRAFT && event.getStatus() != EventStatus.REJECTED) {
            throw new BadRequestException("Only DRAFT or REJECTED events can be submitted for review");
        }

        event.setStatus(EventStatus.SUBMITTED);
        Event saved = eventRepository.save(event);

        // ── Notify admin: new event submission ───────────────────────────────
        String organizerName = organizerRepository.findByUser_Id(organizerId)
                .map(Organizer::getOrganizationName)
                .orElse("An organizer");

        userRepository.findAll().stream()
                .filter(u -> u.getRole() == com.eventara.common.enums.Role.ROLE_ADMIN)
                .map(User::getId)
                .findFirst()
                .ifPresent(adminId -> notificationService.createNotification(
                        adminId,
                        "New Event Submission",
                        "\"" + event.getTitle() + "\" has been submitted for review by "
                                + organizerName + ".",
                        NotificationType.NEW_EVENT_SUBMISSION,
                        event.getId(),
                        "EVENT"));

        return toResponse(saved);
    }

    // ── Cancel ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse cancelEvent(Long eventId, Long organizerId) {
        Event event = findById(eventId);
        verifyOwnership(event, organizerId);

        event.setStatus(EventStatus.CANCELLED);
        EventResponse response = toResponse(eventRepository.save(event));

        // Cancel all bookings for this event
        bookingService.cancelAllBookingsForEvent(eventId);

        return response;
    }

    // ── Public: Published Events ─────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> getPublishedEvents(Long categoryId, String keyword) {
        Stream<Event> stream;

        if (categoryId != null) {
            stream = eventRepository.findByStatusAndCategoryId(EventStatus.PUBLISHED, categoryId).stream();
        } else {
            stream = eventRepository.findByStatus(EventStatus.PUBLISHED).stream();
        }

        if (keyword != null && !keyword.isBlank()) {
            String lower = keyword.toLowerCase();
            stream = stream.filter(e -> e.getTitle().toLowerCase().contains(lower));
        }

        return stream.map(this::toResponse).toList();
    }

    // ── Organizer Events ─────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> getOrganizerEvents(Long organizerId) {
        return eventRepository.findByOrganizerId(organizerId).stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> getOrganizerEventsByStatus(Long organizerId, EventStatus status) {
        return eventRepository.findByOrganizerIdAndStatus(organizerId, status).stream()
                .map(this::toResponse)
                .toList();
    }

    // ── Get By Id ────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public EventResponse getEventById(Long eventId) {
        return toResponse(findById(eventId));
    }

    // ── Seat Map ─────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse saveSeatMap(Long eventId, Long organizerId, String seatMapJson) {
        Event event = findById(eventId);
        verifyOwnership(event, organizerId);

        event.setSeatMapJson(seatMapJson);
        return toResponse(eventRepository.save(event));
    }

    // ── Zone Pricing ─────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse saveZonePricing(Long eventId, Long organizerId, List<SeatZoneRequest> zones) {
        Event event = findById(eventId);
        verifyOwnership(event, organizerId);

        seatZoneRepository.deleteByEventId(eventId);

        List<SeatZone> newZones = zones.stream()
                .map(z -> SeatZone.builder()
                        .eventId(eventId)
                        .zoneName(z.getZoneName())
                        .zoneColor(z.getZoneColor())
                        .price(z.getPrice())
                        .totalSeats(z.getTotalSeats())
                        .build())
                .toList();

        seatZoneRepository.saveAll(newZones);
        return toResponse(eventRepository.save(event));
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private Event findById(Long eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
    }

    private void verifyOwnership(Event event, Long organizerId) {
        if (!event.getOrganizerId().equals(organizerId)) {
            throw new ForbiddenException("You do not have permission to modify this event");
        }
    }

    EventResponse toResponse(Event event) {
        // Resolve organizer name
        String organizerName = organizerRepository.findByUser_Id(event.getOrganizerId())
                .map(Organizer::getOrganizationName)
                .orElse(null);

        // Resolve category
        String categoryName = null;
        String categoryIcon = null;
        if (event.getCategoryId() != null) {
            var cat = categoryRepository.findById(event.getCategoryId()).orElse(null);
            if (cat != null) {
                categoryName = cat.getName();
                categoryIcon = cat.getIcon();
            }
        }

        // Resolve seat zones
        List<SeatZoneResponse> zones = seatZoneRepository.findByEventId(event.getId())
                .stream()
                .map(z -> SeatZoneResponse.builder()
                        .id(z.getId())
                        .zoneName(z.getZoneName())
                        .zoneColor(z.getZoneColor())
                        .price(z.getPrice())
                        .totalSeats(z.getTotalSeats())
                        .build())
                .toList();

        return EventResponse.builder()
                .id(event.getId())
                .title(event.getTitle())
                .description(event.getDescription())
                .organizerId(event.getOrganizerId())
                .organizerName(organizerName)
                .categoryId(event.getCategoryId())
                .categoryName(categoryName)
                .categoryIcon(categoryIcon)
                .eventDate(event.getEventDate())
                .endDate(event.getEndDate())
                .venueName(event.getVenueName())
                .venueAddress(event.getVenueAddress())
                .city(event.getCity())
                .bannerImageUrl(event.getBannerImageUrl())
                .status(event.getStatus().name())
                .ticketType(event.getTicketType() != null ? event.getTicketType().name() : null)
                .maxCapacity(event.getMaxCapacity())
                .generalAdmissionPrice(event.getGeneralAdmissionPrice())
                .seatMapJson(event.getSeatMapJson())
                .rejectionNotes(event.getRejectionNotes())
                .seatZones(zones)
                .createdAt(event.getCreatedAt())
                .build();
    }
}
