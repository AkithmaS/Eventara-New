package com.eventara.booking.controller;

import com.eventara.booking.dto.request.CancelBookingRequest;
import com.eventara.booking.dto.request.CreateBookingRequest;
import com.eventara.booking.dto.request.LockSeatsRequest;
import com.eventara.booking.dto.response.BookingResponse;
import com.eventara.booking.dto.response.SeatResponse;
import com.eventara.booking.service.BookingService;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.common.response.ApiResponse;
import com.eventara.user.entity.User;
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
@RequestMapping("/api/customer/bookings")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_CUSTOMER')")
public class BookingController {

    private final BookingService bookingService;
    private final UserRepository userRepository;

    // POST /api/customer/bookings/lock-seats
    @PostMapping("/lock-seats")
    public ResponseEntity<ApiResponse<List<SeatResponse>>> lockSeats(
            @Valid @RequestBody LockSeatsRequest request) {

        Long userId = resolveUserId();
        List<SeatResponse> seats = bookingService.lockSeats(userId, request);
        return ResponseEntity.ok(ApiResponse.success(seats, "Seats locked for 5 minutes"));
    }

    // POST /api/customer/bookings
    @PostMapping
    public ResponseEntity<ApiResponse<BookingResponse>> createBooking(
            @Valid @RequestBody CreateBookingRequest request) {

        Long userId = resolveUserId();
        BookingResponse booking = bookingService.createBooking(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(booking, "Booking confirmed successfully"));
    }

    // GET /api/customer/bookings
    @GetMapping
    public ResponseEntity<ApiResponse<List<BookingResponse>>> getMyBookings() {
        Long userId = resolveUserId();
        return ResponseEntity.ok(ApiResponse.success(
                bookingService.getCustomerBookings(userId), "Bookings fetched successfully"));
    }

    // GET /api/customer/bookings/{id}
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<BookingResponse>> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(
                bookingService.getBookingById(id), "Booking fetched successfully"));
    }

    // POST /api/customer/bookings/{id}/cancel
    @PostMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<BookingResponse>> cancelBooking(
            @PathVariable Long id,
            @RequestBody(required = false) CancelBookingRequest request) {

        Long userId = resolveUserId();
        BookingResponse booking = bookingService.cancelBooking(id, userId);
        return ResponseEntity.ok(ApiResponse.success(booking, "Booking cancelled and refunded"));
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Long resolveUserId() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .map(User::getId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
