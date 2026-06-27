package com.eventara.organizer.service;

import com.eventara.common.enums.OrganizerStatus;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.organizer.dto.response.OrganizerResponse;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminOrganizerServiceImpl implements AdminOrganizerService {

    private final OrganizerRepository organizerRepository;
    private final UserRepository userRepository;

    // ── List Applications ────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<OrganizerResponse> getAllApplications(OrganizerStatus status) {
        List<Organizer> organizers = (status != null)
                ? organizerRepository.findByStatus(status)
                : organizerRepository.findAll();

        return organizers.stream()
                .map(this::toResponse)
                .toList();
    }

    // ── Approve ──────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrganizerResponse approveOrganizer(Long organizerId) {
        Organizer organizer = findById(organizerId);

        if (organizer.getStatus() == OrganizerStatus.APPROVED) {
            throw new BadRequestException("Organizer is already approved");
        }

        organizer.setStatus(OrganizerStatus.APPROVED);
        organizer.setRejectionReason(null);
        organizer.setReviewedAt(LocalDateTime.now());

        User user = organizer.getUser();
        user.setActive(true);
        userRepository.save(user);

        Organizer saved = organizerRepository.save(organizer);

        // TODO: send approval notification email
        log.info("Organizer approved: organizerId={}, userId={}", organizerId, user.getId());

        return toResponse(saved);
    }

    // ── Reject ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrganizerResponse rejectOrganizer(Long organizerId, String reason) {
        Organizer organizer = findById(organizerId);

        if (organizer.getStatus() == OrganizerStatus.REJECTED) {
            throw new BadRequestException("Organizer application is already rejected");
        }

        organizer.setStatus(OrganizerStatus.REJECTED);
        organizer.setRejectionReason(reason);
        organizer.setReviewedAt(LocalDateTime.now());

        Organizer saved = organizerRepository.save(organizer);

        // TODO: send rejection notification email
        log.info("Organizer rejected: organizerId={}, reason={}", organizerId, reason);

        return toResponse(saved);
    }

    // ── Suspend ──────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrganizerResponse suspendOrganizer(Long organizerId, String reason) {
        Organizer organizer = findById(organizerId);

        if (organizer.getStatus() == OrganizerStatus.SUSPENDED) {
            throw new BadRequestException("Organizer is already suspended");
        }

        organizer.setStatus(OrganizerStatus.SUSPENDED);
        organizer.setRejectionReason(reason);
        organizer.setReviewedAt(LocalDateTime.now());

        User user = organizer.getUser();
        user.setActive(false);
        userRepository.save(user);

        Organizer saved = organizerRepository.save(organizer);

        // TODO: send suspension notification email
        log.info("Organizer suspended: organizerId={}, reason={}", organizerId, reason);

        return toResponse(saved);
    }

    // ── Reinstate ────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrganizerResponse reinstateOrganizer(Long organizerId) {
        Organizer organizer = findById(organizerId);

        if (organizer.getStatus() == OrganizerStatus.APPROVED) {
            throw new BadRequestException("Organizer is already active");
        }

        organizer.setStatus(OrganizerStatus.APPROVED);
        organizer.setRejectionReason(null);
        organizer.setReviewedAt(LocalDateTime.now());

        User user = organizer.getUser();
        user.setActive(true);
        userRepository.save(user);

        Organizer saved = organizerRepository.save(organizer);

        // TODO: send reinstatement notification email
        log.info("Organizer reinstated: organizerId={}", organizerId);

        return toResponse(saved);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private Organizer findById(Long organizerId) {
        return organizerRepository.findById(organizerId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Organizer not found with id: " + organizerId));
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
