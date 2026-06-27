package com.eventara.notification.repository;

import com.eventara.notification.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> findByRecipientIdOrderByCreatedAtDesc(Long userId);

    List<Notification> findByRecipientIdAndIsReadFalse(Long userId);

    long countByRecipientIdAndIsReadFalse(Long userId);
}
