# Eventara — Spring Boot Backend

Event ticket booking REST API with JWT-RBAC, seat locking, QR ticketing.

---

## Backend File Tree

```
eventara-backend/
├── pom.xml                                              # Maven build — all dependencies declared here
├── Dockerfile                                           # Multi-stage build (JDK 21 builder → JRE runtime)
├── .env.example                                         # Template for environment variables
│
├── src/
│   ├── main/
│   │   ├── java/com/eventara/
│   │   │   │
│   │   │   ├── EventaraApplication.java               # @SpringBootApplication entry point + Admin seed
│   │   │   │
│   │   │   ├── auth/                                   # ── FEATURE: Auth ──────────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── AuthController.java             # POST /auth/register, /login, /refresh, /logout
│   │   │   │   ├── service/
│   │   │   │   │   ├── AuthService.java                # Interface
│   │   │   │   │   └── impl/
│   │   │   │   │       └── AuthServiceImpl.java        # register, login, refresh, revoke
│   │   │   │   ├── repository/
│   │   │   │   │   └── RefreshTokenRepository.java     # JPA — refresh token store
│   │   │   │   ├── entity/
│   │   │   │   │   └── RefreshToken.java               # @Entity: token, user, expiryDate
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   ├── LoginRequest.java
│   │   │   │   │   │   ├── RegisterRequest.java
│   │   │   │   │   │   └── RefreshTokenRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       └── AuthResponse.java           # accessToken, refreshToken, role
│   │   │   │   └── security/
│   │   │   │       ├── SecurityConfig.java             # JWT filter chain + role URL rules
│   │   │   │       ├── JwtTokenProvider.java           # generate/validate HMAC-SHA256 tokens
│   │   │   │       ├── JwtAuthenticationFilter.java    # OncePerRequestFilter
│   │   │   │       └── CustomUserDetailsService.java   # loadUserByUsername
│   │   │   │
│   │   │   ├── user/                                   # ── FEATURE: User ──────────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── UserController.java             # /users/me, /admin/users/**
│   │   │   │   ├── service/
│   │   │   │   │   ├── UserService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── UserServiceImpl.java
│   │   │   │   ├── repository/
│   │   │   │   │   └── UserRepository.java             # findByEmail, findAllByRole
│   │   │   │   ├── entity/
│   │   │   │   │   └── User.java                       # @Entity: id, email, role, status
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   └── UpdateProfileRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       └── UserProfileResponse.java
│   │   │   │   ├── mapper/
│   │   │   │   │   └── UserMapper.java                 # MapStruct: User → UserProfileResponse
│   │   │   │   └── enums/
│   │   │   │       ├── Role.java                       # ROLE_CUSTOMER, ROLE_ORGANIZER, ROLE_ADMIN
│   │   │   │       └── UserStatus.java                 # ACTIVE, BANNED, PENDING_APPROVAL, SUSPENDED
│   │   │   │
│   │   │   ├── organizer/                              # ── FEATURE: Organizer ─────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── OrganizerController.java        # /organizer/dashboard, /admin/organizers/**
│   │   │   │   ├── service/
│   │   │   │   │   ├── OrganizerService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── OrganizerServiceImpl.java
│   │   │   │   ├── repository/
│   │   │   │   │   └── OrganizerRepository.java        # findByUser_Id, findAllByStatus
│   │   │   │   ├── entity/
│   │   │   │   │   └── OrganizerProfile.java           # @Entity: org name, docs, status
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   └── OrganizerApplicationRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       ├── OrganizerProfileResponse.java
│   │   │   │   │       └── OrganizerDashboardResponse.java # KPI stats
│   │   │   │   ├── mapper/
│   │   │   │   │   └── OrganizerMapper.java
│   │   │   │   └── enums/
│   │   │   │       └── OrganizerStatus.java            # PENDING, APPROVED, REJECTED, SUSPENDED
│   │   │   │
│   │   │   ├── event/                                  # ── FEATURE: Event ─────────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── EventController.java            # Public + /organizer/events + /admin/events
│   │   │   │   ├── service/
│   │   │   │   │   ├── EventService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── EventServiceImpl.java       # Enforces status transition rules
│   │   │   │   ├── repository/
│   │   │   │   │   ├── EventRepository.java
│   │   │   │   │   ├── EventCategoryRepository.java
│   │   │   │   │   ├── SeatRepository.java             # releaseExpiredLocks (@Scheduled)
│   │   │   │   │   └── PricingTierRepository.java
│   │   │   │   ├── entity/
│   │   │   │   │   ├── Event.java                      # @Entity: title, status, organizer FK
│   │   │   │   │   ├── EventCategory.java              # @Entity: name, slug, iconUrl
│   │   │   │   │   ├── SeatSection.java                # @Entity: section layout, row labels
│   │   │   │   │   ├── Seat.java                       # @Entity: seatNumber, status, lockedUntil
│   │   │   │   │   └── PricingTier.java                # @Entity: VIP/GENERAL/EARLY_BIRD, price
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   └── CreateEventRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       ├── EventSummaryResponse.java   # List cards
│   │   │   │   │       └── EventDetailResponse.java    # Full detail
│   │   │   │   ├── mapper/
│   │   │   │   │   └── EventMapper.java
│   │   │   │   └── enums/
│   │   │   │       ├── EventStatus.java                # DRAFT→SUBMITTED→UNDER_REVIEW→PUBLISHED→REJECTED→COMPLETED
│   │   │   │       └── SeatStatus.java                 # AVAILABLE, LOCKED, BOOKED
│   │   │   │
│   │   │   ├── booking/                                # ── FEATURE: Booking ───────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── BookingController.java          # /bookings/**, /organizer/events/{id}/bookings
│   │   │   │   ├── service/
│   │   │   │   │   ├── BookingService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── BookingServiceImpl.java     # @Transactional seat lock + @Scheduled expiry
│   │   │   │   ├── repository/
│   │   │   │   │   └── BookingRepository.java          # findExpiredPendingBookings
│   │   │   │   ├── entity/
│   │   │   │   │   ├── Booking.java                    # @Entity: ref, status, expiresAt, paymentStatus
│   │   │   │   │   └── BookingItem.java                # @Entity: per-seat line item with ticket
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   ├── CreateBookingRequest.java   # seatIds + pricingTierId
│   │   │   │   │   │   └── PaymentRequest.java         # simulated payment
│   │   │   │   │   └── response/
│   │   │   │   │       └── BookingResponse.java
│   │   │   │   ├── mapper/
│   │   │   │   │   └── BookingMapper.java
│   │   │   │   └── enums/
│   │   │   │       ├── BookingStatus.java              # PENDING_PAYMENT, CONFIRMED, CANCELLED, EXPIRED
│   │   │   │       └── PaymentStatus.java              # UNPAID, PAID, REFUNDED, FAILED
│   │   │   │
│   │   │   ├── ticket/                                 # ── FEATURE: Ticket ────────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── TicketController.java           # GET /tickets/**, POST /organizer/tickets/verify
│   │   │   │   ├── service/
│   │   │   │   │   ├── TicketService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── TicketServiceImpl.java      # ZXing QR generation
│   │   │   │   ├── repository/
│   │   │   │   │   └── TicketRepository.java           # findByQrHash (O(1) lookup)
│   │   │   │   ├── entity/
│   │   │   │   │   └── Ticket.java                     # @Entity: qrHash, status, scannedAt
│   │   │   │   ├── dto/
│   │   │   │   │   ├── request/
│   │   │   │   │   │   └── VerifyTicketRequest.java
│   │   │   │   │   └── response/
│   │   │   │   │       ├── TicketResponse.java
│   │   │   │   │       └── TicketVerificationResponse.java # isValid, holderName
│   │   │   │   ├── mapper/
│   │   │   │   │   └── TicketMapper.java
│   │   │   │   └── enums/
│   │   │   │       └── TicketStatus.java               # VALID, USED, CANCELLED, EXPIRED
│   │   │   │
│   │   │   ├── admin/                                  # ── FEATURE: Admin ─────────────────────────────
│   │   │   │   ├── controller/
│   │   │   │   │   └── AdminController.java            # /admin/analytics, /audit-logs, /settings, /categories
│   │   │   │   ├── service/
│   │   │   │   │   ├── AdminService.java
│   │   │   │   │   └── impl/
│   │   │   │   │       └── AdminServiceImpl.java
│   │   │   │   ├── repository/
│   │   │   │   │   ├── AuditLogRepository.java
│   │   │   │   │   └── SystemSettingsRepository.java
│   │   │   │   ├── entity/
│   │   │   │   │   ├── AuditLog.java                   # @Entity: append-only action log
│   │   │   │   │   └── SystemSettings.java             # @Entity: singleton platform config
│   │   │   │   └── dto/
│   │   │   │       └── response/
│   │   │   │           └── PlatformAnalyticsResponse.java
│   │   │   │
│   │   │   ├── notification/                           # ── FEATURE: Notification ──────────────────────
│   │   │   │   ├── service/
│   │   │   │   │   ├── NotificationService.java        # Interface: email/push triggers
│   │   │   │   │   └── impl/
│   │   │   │   │       └── EmailNotificationServiceImpl.java # Spring Mail + Thymeleaf templates
│   │   │   │   ├── repository/
│   │   │   │   │   └── NotificationLogRepository.java
│   │   │   │   ├── entity/
│   │   │   │   │   └── NotificationLog.java
│   │   │   │   └── enums/
│   │   │   │       └── NotificationType.java           # EMAIL, PUSH
│   │   │   │
│   │   │   └── common/                                 # ── SHARED ─────────────────────────────────────
│   │   │       ├── entity/
│   │   │       │   └── BaseEntity.java                 # @MappedSuperclass: UUID id, createdAt, updatedAt
│   │   │       ├── response/
│   │   │       │   ├── ApiResponse.java                # Generic wrapper: success, data, errorCode
│   │   │       │   └── PagedResponse.java              # Pagination wrapper
│   │   │       ├── exception/
│   │   │       │   ├── GlobalExceptionHandler.java     # @RestControllerAdvice — maps exceptions → HTTP codes
│   │   │       │   ├── ResourceNotFoundException.java  # → 404
│   │   │       │   ├── BusinessException.java          # → 409/400
│   │   │       │   └── UnauthorizedException.java      # → 401
│   │   │       ├── config/
│   │   │       │   ├── AuditConfig.java                # @EnableJpaAuditing + AuditorAware
│   │   │       │   ├── CacheConfig.java                # @EnableCaching (Caffeine)
│   │   │       │   └── OpenApiConfig.java              # SpringDoc OpenAPI 3 config
│   │   │       └── util/
│   │   │           ├── QrCodeUtil.java                 # ZXing wrapper
│   │   │           ├── BookingReferenceUtil.java        # "EVT-XXXXXXXX" generator
│   │   │           └── SlugUtil.java                   # URL-safe slug generator
│   │   │
│   │   └── resources/
│   │       ├── application.yml                         # Base config (profile-agnostic)
│   │       ├── application-dev.yml                     # Dev overrides (show-sql, Swagger enabled)
│   │       ├── application-prod.yml                    # Prod overrides (Swagger off, pool tuning)
│   │       ├── db/
│   │       │   └── migration/                          # Flyway versioned migrations
│   │       │       ├── V1__create_users_table.sql
│   │       │       ├── V2__create_organizer_profiles_table.sql
│   │       │       ├── V3__create_events_tables.sql
│   │       │       ├── V4__create_bookings_tables.sql
│   │       │       ├── V5__create_tickets_table.sql
│   │       │       ├── V6__create_audit_logs_table.sql
│   │       │       └── V7__seed_admin_and_categories.sql
│   │       └── templates/
│   │           └── email/                              # Thymeleaf HTML email templates
│   │               ├── booking-confirmation.html
│   │               ├── ticket-ready.html
│   │               └── organizer-approval.html
│   │
│   └── test/
│       └── java/com/eventara/
│           ├── auth/
│           │   ├── AuthServiceTest.java                # Unit: register, login, refresh
│           │   └── AuthControllerIntegrationTest.java  # @SpringBootTest MockMvc
│           ├── event/
│           │   └── EventServiceTest.java               # Unit: create, status transitions
│           ├── booking/
│           │   └── BookingServiceTest.java             # Unit: seat lock, payment, expiry
│           └── ticket/
│               └── TicketServiceTest.java              # Unit: QR generation, verify
```
