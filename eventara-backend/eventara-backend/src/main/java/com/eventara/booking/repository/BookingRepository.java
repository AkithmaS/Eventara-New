package com.eventara.booking.repository;

import com.eventara.booking.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByCustomerId(Long customerId);

    List<Booking> findByEventId(Long eventId);

    Optional<Booking> findByBookingReference(String reference);

    List<Booking> findByCustomerIdOrderByCreatedAtDesc(Long customerId);
}
