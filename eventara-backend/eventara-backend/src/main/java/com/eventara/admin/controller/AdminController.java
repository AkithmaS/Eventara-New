package com.eventara.admin.controller;

import com.eventara.admin.dto.request.CategoryRequest;
import com.eventara.admin.dto.request.RejectRequest;
import com.eventara.admin.dto.request.SuspendRequest;
import com.eventara.admin.dto.response.*;
import com.eventara.admin.service.AdminService;
import com.eventara.common.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
public class AdminController {

    private final AdminService adminService;

    // ── Organizer Endpoints ──────────────────────────────────────────────────

    // GET /api/admin/organizers/pending
    @GetMapping("/organizers/pending")
    public ResponseEntity<ApiResponse<List<AdminOrganizerResponse>>> getPendingOrganizers() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getPendingOrganizerApplications(),
                "Pending organizer applications retrieved"));
    }

    // GET /api/admin/organizers
    @GetMapping("/organizers")
    public ResponseEntity<ApiResponse<List<AdminOrganizerResponse>>> getAllOrganizers() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAllOrganizers(),
                "All organizers retrieved"));
    }

    // PUT /api/admin/organizers/{id}/approve
    @PutMapping("/organizers/{id}/approve")
    public ResponseEntity<ApiResponse<AdminOrganizerResponse>> approveOrganizer(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.approveOrganizer(id, admin.getUsername()),
                "Organizer approved successfully"));
    }

    // PUT /api/admin/organizers/{id}/reject
    @PutMapping("/organizers/{id}/reject")
    public ResponseEntity<ApiResponse<AdminOrganizerResponse>> rejectOrganizer(
            @PathVariable Long id,
            @Valid @RequestBody RejectRequest request,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.rejectOrganizer(id, request.getReason(), admin.getUsername()),
                "Organizer rejected"));
    }

    // PUT /api/admin/organizers/{id}/suspend
    @PutMapping("/organizers/{id}/suspend")
    public ResponseEntity<ApiResponse<AdminOrganizerResponse>> suspendOrganizer(
            @PathVariable Long id,
            @Valid @RequestBody SuspendRequest request,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.suspendOrganizer(id, request.getReason(), admin.getUsername()),
                "Organizer suspended"));
    }

    // PUT /api/admin/organizers/{id}/reinstate
    @PutMapping("/organizers/{id}/reinstate")
    public ResponseEntity<ApiResponse<AdminOrganizerResponse>> reinstateOrganizer(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.reinstateOrganizer(id, admin.getUsername()),
                "Organizer reinstated successfully"));
    }

    // ── Event Endpoints ──────────────────────────────────────────────────────

    // GET /api/admin/events/pending
    @GetMapping("/events/pending")
    public ResponseEntity<ApiResponse<List<AdminEventResponse>>> getPendingEvents() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getPendingEvents(),
                "Pending events retrieved"));
    }

    // GET /api/admin/events
    @GetMapping("/events")
    public ResponseEntity<ApiResponse<List<AdminEventResponse>>> getAllEvents() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAllEvents(),
                "All events retrieved"));
    }

    // PUT /api/admin/events/{id}/approve
    @PutMapping("/events/{id}/approve")
    public ResponseEntity<ApiResponse<AdminEventResponse>> approveEvent(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.approveEvent(id, admin.getUsername()),
                "Event approved and published"));
    }

    // PUT /api/admin/events/{id}/reject
    @PutMapping("/events/{id}/reject")
    public ResponseEntity<ApiResponse<AdminEventResponse>> rejectEvent(
            @PathVariable Long id,
            @Valid @RequestBody RejectRequest request,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.rejectEvent(id, request.getReason(), admin.getUsername()),
                "Event rejected"));
    }

    // ── User Endpoints ───────────────────────────────────────────────────────

    // GET /api/admin/users
    @GetMapping("/users")
    public ResponseEntity<ApiResponse<List<AdminUserResponse>>> getAllUsers() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAllUsers(),
                "All users retrieved"));
    }

    // PUT /api/admin/users/{id}/deactivate
    @PutMapping("/users/{id}/deactivate")
    public ResponseEntity<ApiResponse<AdminUserResponse>> deactivateUser(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.deactivateUser(id, admin.getUsername()),
                "User deactivated"));
    }

    // PUT /api/admin/users/{id}/reactivate
    @PutMapping("/users/{id}/reactivate")
    public ResponseEntity<ApiResponse<AdminUserResponse>> reactivateUser(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.reactivateUser(id, admin.getUsername()),
                "User reactivated"));
    }

    // ── Category Endpoints ───────────────────────────────────────────────────

    // GET /api/admin/categories
    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllCategories() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAllCategories(),
                "Categories retrieved"));
    }

    // POST /api/admin/categories
    @PostMapping("/categories")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(
            @Valid @RequestBody CategoryRequest request,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        adminService.createCategory(request, admin.getUsername()),
                        "Category created"));
    }

    // PUT /api/admin/categories/{id}
    @PutMapping("/categories/{id}")
    public ResponseEntity<ApiResponse<CategoryResponse>> updateCategory(
            @PathVariable Long id,
            @Valid @RequestBody CategoryRequest request,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.updateCategory(id, request, admin.getUsername()),
                "Category updated"));
    }

    // PUT /api/admin/categories/{id}/deactivate
    @PutMapping("/categories/{id}/deactivate")
    public ResponseEntity<ApiResponse<CategoryResponse>> deactivateCategory(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails admin) {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.deactivateCategory(id, admin.getUsername()),
                "Category deactivated"));
    }

    // ── Analytics ────────────────────────────────────────────────────────────

    // GET /api/admin/analytics
    @GetMapping("/analytics")
    public ResponseEntity<ApiResponse<AnalyticsResponse>> getAnalytics() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAnalytics(),
                "Analytics retrieved"));
    }

    // ── Audit Log ────────────────────────────────────────────────────────────

    // GET /api/admin/audit-logs
    @GetMapping("/audit-logs")
    public ResponseEntity<ApiResponse<List<AuditLogResponse>>> getAuditLogs() {
        return ResponseEntity.ok(ApiResponse.success(
                adminService.getAuditLogs(),
                "Audit logs retrieved"));
    }
}
