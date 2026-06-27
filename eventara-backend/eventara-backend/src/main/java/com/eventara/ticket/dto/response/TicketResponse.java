package com.eventara.ticket.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TicketResponse {

    private Long id;
    private String ticketCode;
    private String bookingReference;

    // Event info
    private Long eventId;
    private String eventName;
    private String eventDate;
    private String venue;

    // Customer info
    private String customerName;

    // Booking info
    private String seatDetails;
    private Integer quantity;
    private BigDecimal totalAmount;

    // Ticket state
    private String status;
    private LocalDateTime issuedAt;

    // QR code as base64-encoded PNG
    private String qrCodeBase64;
}
