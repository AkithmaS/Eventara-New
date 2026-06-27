package com.eventara.booking.repository;

import com.eventara.booking.entity.Seat;
import com.eventara.booking.entity.SeatStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface SeatRepository extends JpaRepository<Seat, Long> {

    List<Seat> findByEventId(Long eventId);

    List<Seat> findByEventIdAndStatus(Long eventId, SeatStatus status);

    Optional<Seat> findByEventIdAndRowLabelAndSeatNumber(Long eventId, String rowLabel, Integer seatNumber);

    List<Seat> findByLockedByUserIdAndStatus(Long userId, SeatStatus status);

    @Query("SELECT s FROM Seat s WHERE s.status = 'LOCKED' AND s.lockedUntil < :now")
    List<Seat> findExpiredLockedSeats(@Param("now") LocalDateTime now);
}
