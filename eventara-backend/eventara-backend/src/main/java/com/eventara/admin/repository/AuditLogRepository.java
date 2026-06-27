package com.eventara.admin.repository;

import com.eventara.admin.entity.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    List<AuditLog> findAllByOrderByPerformedAtDesc();

    List<AuditLog> findByActorEmail(String email);

    List<AuditLog> findByTargetTypeAndTargetId(String targetType, Long targetId);
}
