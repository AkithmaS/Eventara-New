package com.eventara.booking.service;

import com.eventara.booking.dto.request.CreateBookingRequest;
import com.eventara.booking.dto.request.LockSeatsRequest;
import com.eventara.booking.dto.response.BookingResponse;
import com.eventara.booking.dto.response.SeatResponse;

import java.util.List;

public interface BookingService {

    List<SeatResponse> lockSeats(Long userId, LockSeatsRequest request);

    BookingResponse createBooking(Long userId, CreateBookingRequest request);

    BookingResponse cancelBooking(Long bookingId, Long userId);

    List<BookingResponse> getCustomerBookings(Long userId);

    BookingResponse getBookingById(Long bookingId);

    List<BookingResponse> getBookingsByEvent(Long eventId);

    void cancelAllBookingsForEvent(Long eventId);
}
