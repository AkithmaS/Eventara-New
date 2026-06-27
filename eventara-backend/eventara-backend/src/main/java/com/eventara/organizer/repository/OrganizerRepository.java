package com.eventara.organizer.repository;

import com.eventara.common.enums.OrganizerStatus;
import com.eventara.organizer.entity.Organizer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface OrganizerRepository extends JpaRepository<Organizer, Long> {

    Optional<Organizer> findByUser_Id(Long userId);

    List<Organizer> findByStatus(OrganizerStatus status);

    boolean existsByUser_Id(Long userId);
}
