package com.eventara.ticket.controller;

import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.common.response.ApiResponse;
import com.eventara.ticket.dto.response.TicketResponse;
import com.eventara.ticket.service.TicketService;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customer/tickets")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_CUSTOMER')")
public class TicketController {

    private final TicketService ticketService;
    private final UserRepository userRepository;

    // POST /api/customer/tickets/generate/{bookingId}
    @PostMapping("/generate/{bookingId}")
    public ResponseEntity<ApiResponse<TicketResponse>> generateTicket(
            @PathVariable Long bookingId) {
        return ResponseEntity.ok(ApiResponse.success(
                ticketService.generateTicket(bookingId), "Ticket generated successfully"));
    }

    // GET /api/customer/tickets
    @GetMapping
    public ResponseEntity<ApiResponse<List<TicketResponse>>> getCustomerTickets() {
        Long userId = resolveUserId();
        return ResponseEntity.ok(ApiResponse.success(
                ticketService.getCustomerTickets(userId), "Tickets fetched successfully"));
    }

    // GET /api/customer/tickets/booking/{bookingId}
    // !! Must be above /{ticketCode} to avoid route conflict
    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<ApiResponse<TicketResponse>> getTicketByBookingId(
            @PathVariable Long bookingId) {
        return ResponseEntity.ok(ApiResponse.success(
                ticketService.getTicketByBookingId(bookingId), "Ticket fetched successfully"));
    }

    // GET /api/customer/tickets/code/{ticketCode}
    // !! Renamed from /{ticketCode} to /code/{ticketCode} to avoid ambiguity
    @GetMapping("/code/{ticketCode}")
    public ResponseEntity<ApiResponse<TicketResponse>> getTicketByCode(
            @PathVariable String ticketCode) {
        return ResponseEntity.ok(ApiResponse.success(
                ticketService.getTicketByCode(ticketCode), "Ticket fetched successfully"));
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Long resolveUserId() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .map(User::getId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
