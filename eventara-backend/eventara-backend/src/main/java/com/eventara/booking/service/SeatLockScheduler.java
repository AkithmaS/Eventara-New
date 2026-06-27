package com.eventara.booking.service;

import com.eventara.booking.entity.Seat;
import com.eventara.booking.entity.SeatStatus;
import com.eventara.booking.repository.SeatRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class SeatLockScheduler {

    private final SeatRepository seatRepository;

    @Scheduled(fixedRate = 60000)
    public void releaseExpiredLocks() {
        List<Seat> expiredSeats = seatRepository.findExpiredLockedSeats(LocalDateTime.now());

        if (expiredSeats.isEmpty()) {
            return;
        }

        expiredSeats.forEach(seat -> {
            seat.setStatus(SeatStatus.AVAILABLE);
            seat.setLockedByUserId(null);
            seat.setLockedUntil(null);
        });

        seatRepository.saveAll(expiredSeats);
        log.info("Released {} expired seat lock(s)", expiredSeats.size());
    }
}
