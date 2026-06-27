package com.eventara.booking.service;

import com.eventara.booking.dto.request.CreateBookingRequest;
import com.eventara.booking.dto.request.LockSeatsRequest;
import com.eventara.booking.dto.response.BookingResponse;
import com.eventara.booking.dto.response.SeatResponse;
import com.eventara.booking.entity.Booking;
import com.eventara.booking.entity.Seat;
import com.eventara.booking.entity.SeatStatus;
import com.eventara.booking.repository.BookingRepository;
import com.eventara.booking.repository.SeatRepository;
import com.eventara.common.enums.BookingStatus;
import com.eventara.common.enums.TicketType;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ForbiddenException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.entity.Event;
import com.eventara.event.repository.EventRepository;
import com.eventara.event.repository.SeatZoneRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.Year;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

    private final BookingRepository bookingRepository;
    private final SeatRepository seatRepository;
    private final EventRepository eventRepository;
    private final SeatZoneRepository seatZoneRepository;

    private static final Random RANDOM = new Random();

    // ── Lock Seats ───────────────────────────────────────────────────────────

    @Override
    @Transactional
    public List<SeatResponse> lockSeats(Long userId, LockSeatsRequest request) {
        LocalDateTime lockExpiry = LocalDateTime.now().plusMinutes(5);

        List<Seat> seats = request.getSeatIds().stream()
                .map(seatId -> {
                    Seat seat = seatRepository.findById(seatId)
                            .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));

                    if (seat.getStatus() != SeatStatus.AVAILABLE) {
                        throw new BadRequestException(
                                "Seat " + seatId + " is not available (status: " + seat.getStatus() + ")");
                    }

                    seat.setStatus(SeatStatus.LOCKED);
                    seat.setLockedByUserId(userId);
                    seat.setLockedUntil(lockExpiry);
                    return seat;
                })
                .toList();

        seatRepository.saveAll(seats);
        return seats.stream().map(this::toSeatResponse).toList();
    }

    // ── Create Booking ───────────────────────────────────────────────────────

    @Override
    @Transactional
    public BookingResponse createBooking(Long userId, CreateBookingRequest request) {
        Event event = eventRepository.findById(request.getEventId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Event not found: " + request.getEventId()));

        String seatDetails = null;
        BigDecimal totalAmount;
        int quantity;

        if (event.getTicketType() == TicketType.SEATED) {
            if (request.getSeatIds() == null || request.getSeatIds().isEmpty()) {
                throw new BadRequestException("Seat IDs are required for seated events");
            }

            List<Seat> seats = request.getSeatIds().stream()
                    .map(seatId -> {
                        Seat seat = seatRepository.findById(seatId)
                                .orElseThrow(() -> new ResourceNotFoundException("Seat not found: " + seatId));

                        if (seat.getStatus() != SeatStatus.LOCKED
                                || !userId.equals(seat.getLockedByUserId())) {
                            throw new BadRequestException(
                                    "Seat " + seatId + " is not locked by you");
                        }
                        return seat;
                    })
                    .toList();

            // Calculate total from zone prices
            totalAmount = seats.stream()
                    .map(seat -> {
                        if (seat.getZoneId() != null) {
                            return seatZoneRepository.findById(seat.getZoneId())
                                    .map(zone -> zone.getPrice())
                                    .orElse(BigDecimal.ZERO);
                        }
                        return BigDecimal.ZERO;
                    })
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Build readable seat details
            seatDetails = seats.stream()
                    .map(s -> "Row " + s.getRowLabel() + " Seat " + s.getSeatNumber())
                    .collect(Collectors.joining(", "));

            // Mark seats as BOOKED
            seats.forEach(s -> {
                s.setStatus(SeatStatus.BOOKED);
                s.setLockedByUserId(null);
                s.setLockedUntil(null);
            });
            seatRepository.saveAll(seats);
            quantity = seats.size();

        } else {
            // GENERAL_ADMISSION
            if (request.getQuantity() == null || request.getQuantity() <= 0) {
                throw new BadRequestException("Quantity is required for general admission events");
            }
            if (event.getGeneralAdmissionPrice() == null) {
                throw new BadRequestException("Event does not have a general admission price set");
            }

            quantity = request.getQuantity();
            totalAmount = event.getGeneralAdmissionPrice()
                    .multiply(BigDecimal.valueOf(quantity));
        }

        String reference = generateReference();

        Booking booking = Booking.builder()
                .customerId(userId)
                .eventId(event.getId())
                .seatDetails(seatDetails)
                .quantity(quantity)
                .totalAmount(totalAmount)
                .status(BookingStatus.CONFIRMED)
                .bookingReference(reference)
                .build();

        return toBookingResponse(bookingRepository.save(booking), event);
    }

    // ── Cancel Booking ───────────────────────────────────────────────────────

    @Override
    @Transactional
    public BookingResponse cancelBooking(Long bookingId, Long userId) {
        Booking booking = findBookingById(bookingId);

        if (!booking.getCustomerId().equals(userId)) {
            throw new ForbiddenException("You do not have permission to cancel this booking");
        }

        booking.setStatus(BookingStatus.CANCELLED);
        bookingRepository.save(booking);

        booking.setStatus(BookingStatus.REFUNDED);
        bookingRepository.save(booking);

        // Release seats back to AVAILABLE if this was a seated booking
        if (booking.getSeatDetails() != null) {
            List<Seat> seatsToRelease = seatRepository.findByEventId(booking.getEventId())
                    .stream()
                    .filter(s -> s.getStatus() == SeatStatus.BOOKED
                            && booking.getSeatDetails().contains(
                                    "Row " + s.getRowLabel() + " Seat " + s.getSeatNumber()))
                    .toList();

            seatsToRelease.forEach(s -> {
                s.setStatus(SeatStatus.AVAILABLE);
                s.setLockedByUserId(null);
                s.setLockedUntil(null);
            });
            seatRepository.saveAll(seatsToRelease);
        }

        Event event = eventRepository.findById(booking.getEventId()).orElse(null);
        return toBookingResponse(booking, event);
    }

    // ── Customer Bookings ────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<BookingResponse> getCustomerBookings(Long userId) {
        return bookingRepository.findByCustomerIdOrderByCreatedAtDesc(userId).stream()
                .map(b -> {
                    Event event = eventRepository.findById(b.getEventId()).orElse(null);
                    return toBookingResponse(b, event);
                })
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public BookingResponse getBookingById(Long bookingId) {
        Booking booking = findBookingById(bookingId);
        Event event = eventRepository.findById(booking.getEventId()).orElse(null);
        return toBookingResponse(booking, event);
    }

    // ── Organizer: Bookings by Event ─────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<BookingResponse> getBookingsByEvent(Long eventId) {
        Event event = eventRepository.findById(eventId).orElse(null);
        return bookingRepository.findByEventId(eventId).stream()
                .map(b -> toBookingResponse(b, event))
                .toList();
    }

    // ── Cancel All Bookings for Event ────────────────────────────────────────

    @Override
    @Transactional
    public void cancelAllBookingsForEvent(Long eventId) {
        List<Booking> bookings = bookingRepository.findByEventId(eventId);

        bookings.forEach(b -> {
            b.setStatus(BookingStatus.CANCELLED);
            bookingRepository.save(b);
            b.setStatus(BookingStatus.REFUNDED);
            bookingRepository.save(b);
        });

        // Release all seats for the event
        List<Seat> seats = seatRepository.findByEventId(eventId);
        seats.forEach(s -> {
            s.setStatus(SeatStatus.AVAILABLE);
            s.setLockedByUserId(null);
            s.setLockedUntil(null);
        });
        seatRepository.saveAll(seats);

        log.info("Cancelled {} bookings and released seats for eventId={}", bookings.size(), eventId);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private Booking findBookingById(Long bookingId) {
        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found: " + bookingId));
    }

    private String generateReference() {
        int year = Year.now().getValue();
        int suffix = 10000 + RANDOM.nextInt(90000); // 5 digits: 10000–99999
        return "BK-" + year + "-" + suffix;
    }

    private SeatResponse toSeatResponse(Seat seat) {
        return SeatResponse.builder()
                .id(seat.getId())
                .eventId(seat.getEventId())
                .rowLabel(seat.getRowLabel())
                .seatNumber(seat.getSeatNumber())
                .status(seat.getStatus().name())
                .zoneId(seat.getZoneId())
                .build();
    }

    private BookingResponse toBookingResponse(Booking booking, Event event) {
        return BookingResponse.builder()
                .id(booking.getId())
                .bookingReference(booking.getBookingReference())
                .eventId(booking.getEventId())
                .eventName(event != null ? event.getTitle() : null)
                .eventDate(event != null && event.getEventDate() != null
                        ? event.getEventDate().toString() : null)
                .venueName(event != null ? event.getVenueName() : null)
                .seatDetails(booking.getSeatDetails())
                .quantity(booking.getQuantity())
                .totalAmount(booking.getTotalAmount())
                .status(booking.getStatus().name())
                .bookingDate(booking.getBookingDate())
                .build();
    }
}
