package com.eventara.event.service;

import com.eventara.common.enums.EventStatus;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.dto.response.EventResponse;
import com.eventara.event.entity.Event;
import com.eventara.event.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminEventServiceImpl implements AdminEventService {

    private final EventRepository eventRepository;
    private final EventServiceImpl eventServiceImpl;

    public AdminEventServiceImpl(EventRepository eventRepository,
                                 @Lazy EventServiceImpl eventServiceImpl) {
        this.eventRepository = eventRepository;
        this.eventServiceImpl = eventServiceImpl;
    }

    // ── List All ─────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> getAllEvents() {
        return eventRepository.findAll().stream()
                .map(eventServiceImpl::toResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> getEventsByStatus(EventStatus status) {
        return eventRepository.findByStatus(status).stream()
                .map(eventServiceImpl::toResponse)
                .toList();
    }

    // ── Approve ──────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse approveEvent(Long eventId) {
        Event event = findById(eventId);

        if (event.getStatus() != EventStatus.SUBMITTED) {
            throw new BadRequestException("Only SUBMITTED events can be approved");
        }

        event.setStatus(EventStatus.PUBLISHED);
        return eventServiceImpl.toResponse(eventRepository.save(event));
    }

    // ── Reject ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public EventResponse rejectEvent(Long eventId, String notes) {
        Event event = findById(eventId);

        if (event.getStatus() != EventStatus.SUBMITTED) {
            throw new BadRequestException("Only SUBMITTED events can be rejected");
        }

        event.setStatus(EventStatus.REJECTED);
        event.setRejectionNotes(notes);
        return eventServiceImpl.toResponse(eventRepository.save(event));
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Event findById(Long eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
    }
}
