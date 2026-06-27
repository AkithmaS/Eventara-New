# Eventara — Flutter Frontend

Mobile app for browsing events, booking seats, and scanning QR tickets.
Role-based navigation driven by JWT claims via Riverpod + go_router.

---

## Flutter File Tree

```
eventara-flutter/
├── pubspec.yaml                                         # All dependencies (annotated)
├── .env                                                 # API_BASE_URL (flutter_dotenv — gitignored)
├── android/                                             # Platform placeholder (Flutter-managed)
├── ios/                                                 # Platform placeholder (Flutter-managed)
│
├── lib/
│   │
│   ├── main.dart                                        # ProviderScope → MaterialApp.router (go_router)
│   │
│   ├── core/                                            # ── CORE ──────────────────────────────────────
│   │   ├── theme/
│   │   │   ├── app_theme.dart                           # Material 3 light/dark ThemeData
│   │   │   └── app_colors.dart                          # Brand color palette
│   │   ├── router/
│   │   │   ├── app_router.dart                          # GoRouter config — Riverpod redirect logic
│   │   │   ├── app_routes.dart                          # Route path constants
│   │   │   └── route_guards.dart                        # authGuard, roleGuard callbacks
│   │   ├── network/
│   │   │   ├── dio_client.dart                          # Singleton Dio + interceptors stack
│   │   │   ├── auth_interceptor.dart                    # Attaches Bearer token to requests
│   │   │   └── api_endpoints.dart                       # Endpoint path constants
│   │   ├── storage/
│   │   │   └── secure_storage_service.dart              # JWT read/write (flutter_secure_storage)
│   │   ├── providers/
│   │   │   ├── auth_state_provider.dart                 # @riverpod AuthState (isAuth, role, userId)
│   │   │   └── connectivity_provider.dart               # @riverpod Stream<ConnectivityResult>
│   │   ├── error/
│   │   │   ├── app_exception.dart                       # Sealed exception hierarchy
│   │   │   └── failure.dart                             # Failure type (optional Either pattern)
│   │   ├── constants/
│   │   │   └── app_constants.dart                       # Global constants
│   │   └── utils/
│   │       ├── date_formatter.dart
│   │       └── currency_formatter.dart
│   │
│   ├── features/
│   │   │
│   │   ├── auth/                                        # ── FEATURE: Auth ──────────────────────────────
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_datasource.dart      # Dio: login, register, refresh, logout
│   │   │   │   ├── models/
│   │   │   │   │   ├── auth_response_model.dart         # @freezed — accessToken, refreshToken, role
│   │   │   │   │   └── register_model.dart              # @freezed — registration payload
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── auth_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart             # Abstract interface
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_notifier.dart               # AsyncNotifierProvider — login/register state
│   │   │       ├── pages/
│   │   │       │   ├── splash_page.dart                 # Token check → role-based redirect
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── organizer_apply_page.dart        # Multi-step organizer application
│   │   │       └── widgets/
│   │   │           └── auth_form_field.dart
│   │   │
│   │   ├── customer/                                    # ── FEATURE: Customer ──────────────────────────
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── event_remote_datasource.dart     # GET /events, /events/{id}, /events/search
│   │   │   │   │   └── booking_remote_datasource.dart   # POST /bookings, pay, cancel, history
│   │   │   │   ├── models/
│   │   │   │   │   ├── event_model.dart                 # @freezed
│   │   │   │   │   ├── booking_model.dart               # @freezed
│   │   │   │   │   └── ticket_model.dart                # @freezed
│   │   │   │   └── repositories/
│   │   │   │       └── event_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── event_entity.dart
│   │   │   │   │   └── booking_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── event_repository.dart            # Abstract
│   │   │   │   │   └── booking_repository.dart          # Abstract
│   │   │   │   └── usecases/
│   │   │   │       ├── get_events_usecase.dart
│   │   │   │       └── create_booking_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── events_provider.dart             # @riverpod AsyncNotifier (paginated events)
│   │   │       │   └── booking_notifier.dart            # Manages seat lock countdown + payment
│   │   │       ├── pages/
│   │   │       │   ├── home_page.dart                   # Browse events (search, filter, grid)
│   │   │       │   ├── event_detail_page.dart           # Full event + "Book Now"
│   │   │       │   ├── seat_map_page.dart               # Interactive seat grid + countdown
│   │   │       │   ├── checkout_page.dart               # Order summary
│   │   │       │   ├── payment_page.dart                # Simulated payment form
│   │   │       │   ├── booking_confirmation_page.dart   # Success + reference
│   │   │       │   ├── ticket_display_page.dart         # QR code (qr_flutter)
│   │   │       │   ├── booking_history_page.dart        # Past/upcoming bookings
│   │   │       │   └── profile_page.dart                # Edit profile + logout
│   │   │       └── widgets/
│   │   │           ├── event_card.dart                  # Event grid/list card
│   │   │           └── seat_widget.dart                 # Individual seat cell (color-coded)
│   │   │
│   │   ├── organizer/                                   # ── FEATURE: Organizer ─────────────────────────
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── organizer_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── organizer_event_model.dart       # @freezed — event with submission status
│   │   │   │   └── repositories/
│   │   │   │       └── (organizer_repository_impl.dart)
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── (organizer_entity.dart)
│   │   │   │   ├── repositories/
│   │   │   │   │   └── organizer_repository.dart        # Abstract
│   │   │   │   └── usecases/
│   │   │   │       └── (create_event_usecase.dart, verify_ticket_usecase.dart)
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── organizer_event_notifier.dart    # CRUD + submit for review
│   │   │       └── pages/
│   │   │           ├── dashboard_page.dart              # KPI cards + quick links
│   │   │           ├── create_event_page.dart           # Multi-step event form
│   │   │           ├── edit_event_page.dart
│   │   │           ├── seat_map_editor_page.dart        # Visual seat layout builder
│   │   │           ├── pricing_setup_page.dart          # Add/edit pricing tiers
│   │   │           ├── event_submissions_page.dart      # Submitted events + status
│   │   │           ├── event_bookings_list_page.dart    # Bookings per event
│   │   │           ├── qr_scanner_page.dart             # mobile_scanner + verify API
│   │   │           └── organizer_reports_page.dart      # Revenue/tickets charts
│   │   │
│   │   └── admin/                                       # ── FEATURE: Admin ─────────────────────────────
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── admin_remote_datasource.dart     # All /admin/* Dio calls
│   │       │   ├── models/
│   │       │   │   └── analytics_model.dart             # @freezed
│   │       │   └── repositories/
│   │       │       └── admin_repository_impl.dart
│   │       ├── domain/
│   │       │   └── repositories/
│   │       │       └── admin_repository.dart            # Abstract
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── admin_notifier.dart              # Approve/reject/ban/publish actions
│   │           └── pages/
│   │               ├── dashboard_page.dart              # Platform KPI summary
│   │               ├── organizer_applications_page.dart # Pending approvals
│   │               ├── event_approvals_page.dart        # UNDER_REVIEW events
│   │               ├── user_management_page.dart        # Ban/unban users
│   │               ├── category_management_page.dart    # CRUD categories
│   │               ├── analytics_page.dart              # Platform charts
│   │               ├── audit_log_page.dart              # Action history
│   │               └── settings_page.dart               # System settings
│   │
│   └── shared/                                          # ── SHARED WIDGETS ─────────────────────────────
│       └── widgets/
│           ├── app_button.dart                          # Primary/secondary/outlined button
│           ├── app_bottom_nav.dart                      # Role-specific bottom navigation
│           ├── loading_widget.dart                      # Shimmer skeleton loader
│           ├── error_widget.dart                        # Error + retry button
│           ├── empty_state_widget.dart                  # Empty list illustration
│           └── status_badge.dart                        # Color-coded status chip
│
└── test/
    └── features/
        ├── auth/
        │   └── auth_notifier_test.dart                  # ProviderContainer unit tests
        └── customer/
            ├── events_provider_test.dart
            └── booking_notifier_test.dart
```
