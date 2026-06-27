package com.eventara.event.repository;

import com.eventara.event.entity.SeatZone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface SeatZoneRepository extends JpaRepository<SeatZone, Long> {

    List<SeatZone> findByEventId(Long eventId);

    @Transactional
    void deleteByEventId(Long eventId);
}
