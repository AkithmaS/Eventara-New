package com.eventara.booking.controller;

import com.eventara.booking.dto.response.BookingResponse;
import com.eventara.booking.service.BookingService;
import com.eventara.common.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/organizer/bookings")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_ORGANIZER')")
public class OrganizerBookingController {

    private final BookingService bookingService;

    // GET /api/organizer/bookings?eventId=123
    @GetMapping
    public ResponseEntity<ApiResponse<List<BookingResponse>>> getBookingsByEvent(
            @RequestParam Long eventId) {

        return ResponseEntity.ok(ApiResponse.success(
                bookingService.getBookingsByEvent(eventId), "Bookings fetched successfully"));
    }
}
