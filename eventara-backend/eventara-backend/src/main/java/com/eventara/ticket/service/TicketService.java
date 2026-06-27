package com.eventara.ticket.service;

import com.eventara.ticket.dto.response.TicketResponse;

import java.util.List;

public interface TicketService {

    TicketResponse generateTicket(Long bookingId);

    TicketResponse getTicketByBookingId(Long bookingId);

    List<TicketResponse> getCustomerTickets(Long userId);

    TicketResponse getTicketByCode(String ticketCode);
}
