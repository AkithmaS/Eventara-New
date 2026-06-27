package com.eventara.notification.service;

import com.eventara.notification.dto.NotificationResponse;
import com.eventara.notification.entity.NotificationType;

import java.util.List;

public interface NotificationService {

    // ── Reading ──────────────────────────────────────────────────────────────

    List<NotificationResponse> getMyNotifications(Long userId);

    List<NotificationResponse> getUnreadNotifications(Long userId);

    long getUnreadCount(Long userId);

    // ── Marking ──────────────────────────────────────────────────────────────

    void markAsRead(Long notificationId, Long userId);

    void markAllAsRead(Long userId);

    // ── Internal creation (called by other services) ─────────────────────────

    void createNotification(Long recipientId, String title, String message,
                            NotificationType type, Long referenceId, String referenceType);
}
