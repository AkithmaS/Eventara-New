package com.eventara.ticket.service;

import com.eventara.booking.entity.Booking;
import com.eventara.booking.repository.BookingRepository;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.entity.Event;
import com.eventara.event.repository.EventRepository;
import com.eventara.ticket.dto.response.TicketResponse;
import com.eventara.ticket.entity.Ticket;
import com.eventara.ticket.entity.TicketStatus;
import com.eventara.ticket.repository.TicketRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Year;
import java.util.List;
import java.util.Random;

@Slf4j
@Service
@RequiredArgsConstructor
public class TicketServiceImpl implements TicketService {

    private final TicketRepository ticketRepository;
    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final QRCodeService qrCodeService;

    private static final Random RANDOM = new Random();

    // ── Generate Ticket ──────────────────────────────────────────────────────

    @Override
    @Transactional
    public TicketResponse generateTicket(Long bookingId) {
        // Idempotent — return existing ticket if already generated
        return ticketRepository.findByBookingId(bookingId)
                .map(existing -> toResponse(existing, null))
                .orElseGet(() -> createTicket(bookingId));
    }

    private TicketResponse createTicket(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + bookingId));

        User customer = userRepository.findById(booking.getCustomerId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "User not found: " + booking.getCustomerId()));

        Event event = eventRepository.findById(booking.getEventId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Event not found: " + booking.getEventId()));

        String ticketCode = generateTicketCode();

        // QR data encodes ticket code + booking reference + event id
        String qrData = ticketCode + "|" + booking.getBookingReference() + "|" + event.getId();
        String qrBase64 = qrCodeService.generateQRCode(qrData);

        Ticket ticket = Ticket.builder()
                .booking(booking)
                .customer(customer)
                .ticketCode(ticketCode)
                .qrCodeData(qrBase64)
                .status(TicketStatus.VALID)
                .build();

        Ticket saved = ticketRepository.save(ticket);
        log.info("Ticket generated: {} for bookingId={}", ticketCode, bookingId);

        return toResponse(saved, event);
    }

    // ── Get by Booking ───────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public TicketResponse getTicketByBookingId(Long bookingId) {
        Ticket ticket = ticketRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Ticket not found for bookingId: " + bookingId));

        Event event = eventRepository.findById(ticket.getBooking().getEventId()).orElse(null);
        return toResponse(ticket, event);
    }

    // ── Customer Tickets ─────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<TicketResponse> getCustomerTickets(Long userId) {
        return ticketRepository.findByCustomerId(userId).stream()
                .map(ticket -> {
                    Event event = eventRepository
                            .findById(ticket.getBooking().getEventId()).orElse(null);
                    return toResponse(ticket, event);
                })
                .toList();
    }

    // ── Get by Code ──────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public TicketResponse getTicketByCode(String ticketCode) {
        Ticket ticket = ticketRepository.findByTicketCode(ticketCode)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Ticket not found with code: " + ticketCode));

        Event event = eventRepository.findById(ticket.getBooking().getEventId()).orElse(null);
        return toResponse(ticket, event);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private String generateTicketCode() {
        int year = Year.now().getValue();
        int suffix = 10000 + RANDOM.nextInt(90000);
        return "TK-" + year + "-" + suffix;
    }

    private TicketResponse toResponse(Ticket ticket, Event event) {
        Booking booking = ticket.getBooking();
        User customer = ticket.getCustomer();

        // Resolve event lazily if not passed in
        if (event == null) {
            event = eventRepository.findById(booking.getEventId()).orElse(null);
        }

        return TicketResponse.builder()
                .id(ticket.getId())
                .ticketCode(ticket.getTicketCode())
                .bookingReference(booking.getBookingReference())
                .eventId(booking.getEventId())
                .eventName(event != null ? event.getTitle() : null)
                .eventDate(event != null && event.getEventDate() != null
                        ? event.getEventDate().toString() : null)
                .venue(event != null ? event.getVenueName() : null)
                .customerName(customer.getFullName())
                .seatDetails(booking.getSeatDetails() != null
                        ? booking.getSeatDetails() : "General Admission")
                .quantity(booking.getQuantity())
                .totalAmount(booking.getTotalAmount())
                .status(ticket.getStatus().name())
                .issuedAt(ticket.getIssuedAt())
                .qrCodeBase64(ticket.getQrCodeData())
                .build();
    }
}
