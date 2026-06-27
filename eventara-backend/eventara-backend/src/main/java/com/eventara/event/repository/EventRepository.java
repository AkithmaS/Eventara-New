package com.eventara.event.repository;

import com.eventara.common.enums.EventStatus;
import com.eventara.event.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long> {

    List<Event> findByOrganizerId(Long organizerId);

    List<Event> findByStatus(EventStatus status);

    List<Event> findByStatusAndCategoryId(EventStatus status, Long categoryId);

    List<Event> findByTitleContainingIgnoreCase(String keyword);

    List<Event> findByOrganizerIdAndStatus(Long organizerId, EventStatus status);
}
