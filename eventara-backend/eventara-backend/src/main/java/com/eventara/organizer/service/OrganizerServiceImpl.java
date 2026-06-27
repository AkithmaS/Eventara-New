package com.eventara.organizer.service;

import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.organizer.dto.request.UpdateOrganizerRequest;
import com.eventara.organizer.dto.response.OrganizerDashboardResponse;
import com.eventara.organizer.dto.response.OrganizerResponse;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class OrganizerServiceImpl implements OrganizerService {

    private final OrganizerRepository organizerRepository;
    private final UserRepository userRepository;

    // ── Get Profile ──────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public OrganizerResponse getOrganizerProfile(Long userId) {
        Organizer organizer = findByUserId(userId);
        return toResponse(organizer);
    }

    // ── Update Profile ───────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrganizerResponse updateOrganizerProfile(Long userId, UpdateOrganizerRequest request) {
        Organizer organizer = findByUserId(userId);

        organizer.setOrganizationName(request.getOrganizationName());
        organizer.setOrganizationType(request.getOrganizationType());
        organizer.setDescription(request.getDescription());
        organizer.setWebsiteUrl(request.getWebsiteUrl());

        return toResponse(organizerRepository.save(organizer));
    }

    // ── Dashboard ────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public OrganizerDashboardResponse getOrganizerDashboard(Long userId) {
        // Verify organizer exists
        findByUserId(userId);

        // Placeholder stats — will be wired to real queries once Event/Booking features are built
        return OrganizerDashboardResponse.builder()
                .totalEvents(0L)
                .totalBookings(0L)
                .totalRevenue(BigDecimal.ZERO)
                .totalAttendees(0L)
                .build();
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private Organizer findByUserId(Long userId) {
        return organizerRepository.findByUser_Id(userId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Organizer profile not found for user id: " + userId));
    }

    private OrganizerResponse toResponse(Organizer o) {
        User user = o.getUser();
        return OrganizerResponse.builder()
                .id(o.getId())
                .userId(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .profileImageUrl(user.getProfileImageUrl())
                .organizationName(o.getOrganizationName())
                .organizationType(o.getOrganizationType())
                .description(o.getDescription())
                .websiteUrl(o.getWebsiteUrl())
                .status(o.getStatus())
                .rejectionReason(o.getRejectionReason())
                .appliedAt(o.getAppliedAt())
                .reviewedAt(o.getReviewedAt())
                .createdAt(o.getCreatedAt())
                .updatedAt(o.getUpdatedAt())
                .build();
    }
}
