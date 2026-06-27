package com.eventara.admin.service;

import com.eventara.admin.dto.request.CategoryRequest;
import com.eventara.admin.dto.response.*;
import com.eventara.admin.entity.AuditLog;
import com.eventara.admin.repository.AuditLogRepository;
import com.eventara.booking.repository.BookingRepository;
import com.eventara.common.enums.EventStatus;
import com.eventara.common.enums.OrganizerStatus;
import com.eventara.common.enums.Role;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.entity.Category;
import com.eventara.event.entity.Event;
import com.eventara.event.repository.CategoryRepository;
import com.eventara.event.repository.EventRepository;
import com.eventara.notification.entity.NotificationType;
import com.eventara.notification.service.NotificationService;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.ticket.repository.TicketRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
public class AdminServiceImpl implements AdminService {

    private final OrganizerRepository organizerRepository;
    private final EventRepository eventRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final BookingRepository bookingRepository;
    private final TicketRepository ticketRepository;
    private final AuditLogRepository auditLogRepository;
    private final NotificationService notificationService;

    public AdminServiceImpl(OrganizerRepository organizerRepository,
                            EventRepository eventRepository,
                            UserRepository userRepository,
                            CategoryRepository categoryRepository,
                            BookingRepository bookingRepository,
                            TicketRepository ticketRepository,
                            AuditLogRepository auditLogRepository,
                            @Lazy NotificationService notificationService) {
        this.organizerRepository = organizerRepository;
        this.eventRepository = eventRepository;
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
        this.bookingRepository = bookingRepository;
        this.ticketRepository = ticketRepository;
        this.auditLogRepository = auditLogRepository;
        this.notificationService = notificationService;
    }

    // ── Organizer Management ─────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<AdminOrganizerResponse> getPendingOrganizerApplications() {
        return organizerRepository.findByStatus(OrganizerStatus.PENDING).stream()
                .map(this::toOrganizerResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<AdminOrganizerResponse> getAllOrganizers() {
        return organizerRepository.findAll().stream()
                .map(this::toOrganizerResponse)
                .toList();
    }

    @Override
    @Transactional
    public AdminOrganizerResponse approveOrganizer(Long organizerId, String adminEmail) {
        Organizer organizer = findOrganizerById(organizerId);

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

        saveAuditLog(adminEmail, "APPROVED_ORGANIZER", "ORGANIZER", organizerId,
                "Approved organizer: " + user.getEmail());
        log.info("Admin {} approved organizer id={}", adminEmail, organizerId);

        // ── Notify organizer ─────────────────────────────────────────────────
        notificationService.createNotification(
                user.getId(),
                "Application Approved",
                "Congratulations! Your organizer application has been approved.",
                NotificationType.ORGANIZER_APPROVED,
                organizerId,
                "ORGANIZER");

        return toOrganizerResponse(saved);
    }

    @Override
    @Transactional
    public AdminOrganizerResponse rejectOrganizer(Long organizerId, String reason, String adminEmail) {
        Organizer organizer = findOrganizerById(organizerId);

        if (organizer.getStatus() == OrganizerStatus.REJECTED) {
            throw new BadRequestException("Organizer application is already rejected");
        }

        organizer.setStatus(OrganizerStatus.REJECTED);
        organizer.setRejectionReason(reason);
        organizer.setReviewedAt(LocalDateTime.now());

        Organizer saved = organizerRepository.save(organizer);

        saveAuditLog(adminEmail, "REJECTED_ORGANIZER", "ORGANIZER", organizerId,
                "Reason: " + reason);
        log.info("Admin {} rejected organizer id={}, reason={}", adminEmail, organizerId, reason);

        // ── Notify organizer ─────────────────────────────────────────────────
        notificationService.createNotification(
                organizer.getUser().getId(),
                "Application Rejected",
                "Your organizer application has been rejected. Reason: " + reason,
                NotificationType.ORGANIZER_REJECTED,
                organizerId,
                "ORGANIZER");

        return toOrganizerResponse(saved);
    }

    @Override
    @Transactional
    public AdminOrganizerResponse suspendOrganizer(Long organizerId, String reason, String adminEmail) {
        Organizer organizer = findOrganizerById(organizerId);

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

        saveAuditLog(adminEmail, "SUSPENDED_ORGANIZER", "ORGANIZER", organizerId,
                "Reason: " + reason);
        log.info("Admin {} suspended organizer id={}, reason={}", adminEmail, organizerId, reason);

        return toOrganizerResponse(saved);
    }

    @Override
    @Transactional
    public AdminOrganizerResponse reinstateOrganizer(Long organizerId, String adminEmail) {
        Organizer organizer = findOrganizerById(organizerId);

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

        saveAuditLog(adminEmail, "REINSTATED_ORGANIZER", "ORGANIZER", organizerId,
                "Reinstated organizer: " + user.getEmail());
        log.info("Admin {} reinstated organizer id={}", adminEmail, organizerId);

        return toOrganizerResponse(saved);
    }

    // ── Event Management ─────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<AdminEventResponse> getPendingEvents() {
        return eventRepository.findByStatus(EventStatus.SUBMITTED).stream()
                .map(this::toEventResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<AdminEventResponse> getAllEvents() {
        return eventRepository.findAll().stream()
                .map(this::toEventResponse)
                .toList();
    }

    @Override
    @Transactional
    public AdminEventResponse approveEvent(Long eventId, String adminEmail) {
        Event event = findEventById(eventId);

        if (event.getStatus() != EventStatus.SUBMITTED) {
            throw new BadRequestException("Only SUBMITTED events can be approved");
        }

        event.setStatus(EventStatus.PUBLISHED);
        Event saved = eventRepository.save(event);

        saveAuditLog(adminEmail, "APPROVED_EVENT", "EVENT", eventId,
                "Approved event: " + event.getTitle());
        log.info("Admin {} approved event id={}", adminEmail, eventId);

        // ── Notify organizer ─────────────────────────────────────────────────
        organizerRepository.findByUser_Id(event.getOrganizerId()).ifPresent(org ->
                notificationService.createNotification(
                        org.getUser().getId(),
                        "Event Approved",
                        "Your event \"" + event.getTitle() + "\" has been approved and is now live.",
                        NotificationType.EVENT_APPROVED,
                        eventId,
                        "EVENT"));

        return toEventResponse(saved);
    }

    @Override
    @Transactional
    public AdminEventResponse rejectEvent(Long eventId, String reason, String adminEmail) {
        Event event = findEventById(eventId);

        if (event.getStatus() != EventStatus.SUBMITTED) {
            throw new BadRequestException("Only SUBMITTED events can be rejected");
        }

        event.setStatus(EventStatus.REJECTED);
        event.setRejectionNotes(reason);
        Event saved = eventRepository.save(event);

        saveAuditLog(adminEmail, "REJECTED_EVENT", "EVENT", eventId,
                "Reason: " + reason);
        log.info("Admin {} rejected event id={}, reason={}", adminEmail, eventId, reason);

        // ── Notify organizer ─────────────────────────────────────────────────
        organizerRepository.findByUser_Id(event.getOrganizerId()).ifPresent(org ->
                notificationService.createNotification(
                        org.getUser().getId(),
                        "Event Rejected",
                        "Your event \"" + event.getTitle() + "\" was rejected. Reason: " + reason,
                        NotificationType.EVENT_REJECTED,
                        eventId,
                        "EVENT"));

        return toEventResponse(saved);
    }

    // ── User Management ──────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<AdminUserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::toUserResponse)
                .toList();
    }

    @Override
    @Transactional
    public AdminUserResponse deactivateUser(Long userId, String adminEmail) {
        User user = findUserById(userId);

        if (!user.isActive()) {
            throw new BadRequestException("User is already inactive");
        }

        user.setActive(false);
        User saved = userRepository.save(user);

        saveAuditLog(adminEmail, "DEACTIVATED_USER", "USER", userId,
                "Deactivated user: " + user.getEmail());
        log.info("Admin {} deactivated user id={}", adminEmail, userId);

        return toUserResponse(saved);
    }

    @Override
    @Transactional
    public AdminUserResponse reactivateUser(Long userId, String adminEmail) {
        User user = findUserById(userId);

        if (user.isActive()) {
            throw new BadRequestException("User is already active");
        }

        user.setActive(true);
        User saved = userRepository.save(user);

        saveAuditLog(adminEmail, "REACTIVATED_USER", "USER", userId,
                "Reactivated user: " + user.getEmail());
        log.info("Admin {} reactivated user id={}", adminEmail, userId);

        return toUserResponse(saved);
    }

    // ── Category Management ──────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<CategoryResponse> getAllCategories() {
        return categoryRepository.findAll().stream()
                .map(this::toCategoryResponse)
                .toList();
    }

    @Override
    @Transactional
    public CategoryResponse createCategory(CategoryRequest request, String adminEmail) {
        if (categoryRepository.findByName(request.getName()).isPresent()) {
            throw new BadRequestException("Category with name '" + request.getName() + "' already exists");
        }

        Category category = Category.builder()
                .name(request.getName())
                .icon(request.getIcon())
                .description(request.getDescription())
                .isActive(true)
                .build();

        Category saved = categoryRepository.save(category);

        saveAuditLog(adminEmail, "CREATED_CATEGORY", "CATEGORY", saved.getId(),
                "Created category: " + saved.getName());
        log.info("Admin {} created category id={}, name={}", adminEmail, saved.getId(), saved.getName());

        return toCategoryResponse(saved);
    }

    @Override
    @Transactional
    public CategoryResponse updateCategory(Long id, CategoryRequest request, String adminEmail) {
        Category category = findCategoryById(id);

        // Check name uniqueness only if the name is actually changing
        if (!category.getName().equals(request.getName())) {
            if (categoryRepository.findByName(request.getName()).isPresent()) {
                throw new BadRequestException("Category with name '" + request.getName() + "' already exists");
            }
        }

        category.setName(request.getName());
        category.setIcon(request.getIcon());
        category.setDescription(request.getDescription());
        Category saved = categoryRepository.save(category);

        saveAuditLog(adminEmail, "UPDATED_CATEGORY", "CATEGORY", id,
                "Updated category to: " + saved.getName());
        log.info("Admin {} updated category id={}", adminEmail, id);

        return toCategoryResponse(saved);
    }

    @Override
    @Transactional
    public CategoryResponse deactivateCategory(Long id, String adminEmail) {
        Category category = findCategoryById(id);

        if (!category.isActive()) {
            throw new BadRequestException("Category is already inactive");
        }

        category.setActive(false);
        Category saved = categoryRepository.save(category);

        saveAuditLog(adminEmail, "DEACTIVATED_CATEGORY", "CATEGORY", id,
                "Deactivated category: " + category.getName());
        log.info("Admin {} deactivated category id={}", adminEmail, id);

        return toCategoryResponse(saved);
    }

    // ── Analytics ────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public AnalyticsResponse getAnalytics() {
        long totalUsers         = userRepository.count();
        long totalOrganizers    = organizerRepository.count();
        long totalEvents        = eventRepository.count();
        long totalBookings      = bookingRepository.count();
        long totalTickets       = ticketRepository.count();
        long pendingOrganizers  = organizerRepository.findByStatus(OrganizerStatus.PENDING).size();
        long pendingEvents      = eventRepository.findByStatus(EventStatus.SUBMITTED).size();

        BigDecimal totalRevenue = bookingRepository.findAll().stream()
                .map(b -> b.getTotalAmount() != null ? b.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return AnalyticsResponse.builder()
                .totalUsers(totalUsers)
                .totalOrganizers(totalOrganizers)
                .totalEvents(totalEvents)
                .totalBookings(totalBookings)
                .totalTicketsIssued(totalTickets)
                .totalRevenue(totalRevenue)
                .pendingOrganizerApplications(pendingOrganizers)
                .pendingEventApprovals(pendingEvents)
                .build();
    }

    // ── Audit Log ────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<AuditLogResponse> getAuditLogs() {
        return auditLogRepository.findAllByOrderByPerformedAtDesc().stream()
                .map(this::toAuditLogResponse)
                .toList();
    }

    // ── Private Helpers ──────────────────────────────────────────────────────

    private void saveAuditLog(String actorEmail, String action, String targetType,
                               Long targetId, String details) {
        auditLogRepository.save(AuditLog.builder()
                .actorEmail(actorEmail)
                .action(action)
                .targetType(targetType)
                .targetId(targetId)
                .details(details)
                .build());
    }

    private Organizer findOrganizerById(Long id) {
        return organizerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Organizer not found with id: " + id));
    }

    private Event findEventById(Long id) {
        return eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));
    }

    private User findUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }

    private Category findCategoryById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
    }

    // Returns the first admin user's id, used by other services to notify admin
    public Long findAdminUserId() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == Role.ROLE_ADMIN)
                .map(User::getId)
                .findFirst()
                .orElse(null);
    }

    // ── Mappers ──────────────────────────────────────────────────────────────

    private AdminOrganizerResponse toOrganizerResponse(Organizer o) {
        User user = o.getUser();
        return AdminOrganizerResponse.builder()
                .id(o.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .organizerStatus(o.getStatus())
                .businessName(o.getOrganizationName())
                .appliedAt(o.getAppliedAt())
                .approvedAt(o.getReviewedAt())
                .isActive(user.isActive())
                .build();
    }

    private AdminEventResponse toEventResponse(Event e) {
        // Resolve organizer email
        String organizerName  = null;
        String organizerEmail = null;
        var organizerOpt = organizerRepository.findById(e.getOrganizerId());
        if (organizerOpt.isPresent()) {
            Organizer org = organizerOpt.get();
            organizerName  = org.getOrganizationName();
            organizerEmail = org.getUser().getEmail();
        }

        // Resolve category name
        String categoryName = null;
        if (e.getCategoryId() != null) {
            categoryName = categoryRepository.findById(e.getCategoryId())
                    .map(Category::getName)
                    .orElse(null);
        }

        return AdminEventResponse.builder()
                .id(e.getId())
                .title(e.getTitle())
                .description(e.getDescription())
                .category(categoryName)
                .organizerName(organizerName)
                .organizerEmail(organizerEmail)
                .eventDate(e.getEventDate())
                .venue(e.getVenueName())
                .eventType(e.getTicketType() != null ? e.getTicketType().name() : null)
                .eventStatus(e.getStatus().name())
                .ticketPrice(e.getGeneralAdmissionPrice())
                .capacity(e.getMaxCapacity())
                .createdAt(e.getCreatedAt())
                .submittedAt(e.getStatus() == EventStatus.SUBMITTED ? e.getUpdatedAt() : null)
                .build();
    }

    private AdminUserResponse toUserResponse(User u) {
        return AdminUserResponse.builder()
                .id(u.getId())
                .fullName(u.getFullName())
                .email(u.getEmail())
                .phoneNumber(u.getPhoneNumber())
                .role(u.getRole())
                .isActive(u.isActive())
                .isEmailVerified(u.isEmailVerified())
                .createdAt(u.getCreatedAt())
                .build();
    }

    private CategoryResponse toCategoryResponse(Category c) {
        return CategoryResponse.builder()
                .id(c.getId())
                .name(c.getName())
                .icon(c.getIcon())
                .description(c.getDescription())
                .isActive(c.isActive())
                .createdAt(c.getCreatedAt())
                .build();
    }

    private AuditLogResponse toAuditLogResponse(AuditLog a) {
        return AuditLogResponse.builder()
                .id(a.getId())
                .actorEmail(a.getActorEmail())
                .action(a.getAction())
                .targetType(a.getTargetType())
                .targetId(a.getTargetId())
                .details(a.getDetails())
                .performedAt(a.getPerformedAt())
                .build();
    }
}
