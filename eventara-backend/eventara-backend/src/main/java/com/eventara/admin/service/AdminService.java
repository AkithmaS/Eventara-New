package com.eventara.admin.service;

import com.eventara.admin.dto.request.CategoryRequest;
import com.eventara.admin.dto.response.*;

import java.util.List;

public interface AdminService {

    // ── Organizer Management ─────────────────────────────────────────────────
    List<AdminOrganizerResponse> getPendingOrganizerApplications();
    List<AdminOrganizerResponse> getAllOrganizers();
    AdminOrganizerResponse approveOrganizer(Long organizerId, String adminEmail);
    AdminOrganizerResponse rejectOrganizer(Long organizerId, String reason, String adminEmail);
    AdminOrganizerResponse suspendOrganizer(Long organizerId, String reason, String adminEmail);
    AdminOrganizerResponse reinstateOrganizer(Long organizerId, String adminEmail);

    // ── Event Management ─────────────────────────────────────────────────────
    List<AdminEventResponse> getPendingEvents();
    List<AdminEventResponse> getAllEvents();
    AdminEventResponse approveEvent(Long eventId, String adminEmail);
    AdminEventResponse rejectEvent(Long eventId, String reason, String adminEmail);

    // ── User Management ──────────────────────────────────────────────────────
    List<AdminUserResponse> getAllUsers();
    AdminUserResponse deactivateUser(Long userId, String adminEmail);
    AdminUserResponse reactivateUser(Long userId, String adminEmail);

    // ── Category Management ──────────────────────────────────────────────────
    List<CategoryResponse> getAllCategories();
    CategoryResponse createCategory(CategoryRequest request, String adminEmail);
    CategoryResponse updateCategory(Long id, CategoryRequest request, String adminEmail);
    CategoryResponse deactivateCategory(Long id, String adminEmail);

    // ── Analytics ────────────────────────────────────────────────────────────
    AnalyticsResponse getAnalytics();

    // ── Audit Log ────────────────────────────────────────────────────────────
    List<AuditLogResponse> getAuditLogs();
}
