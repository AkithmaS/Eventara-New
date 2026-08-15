# Eventara — Full-Stack Event Ticket Booking System

**Stack:** Flutter (mobile) + Spring Boot (REST API) + PostgreSQL + JWT RBAC

**Roles:**
- `ROLE_CUSTOMER` — self-registered, books tickets, views QR tickets
- `ROLE_ORGANIZER` — admin-approved, creates/manages events, scans QR at entry
- `ROLE_ADMIN` — DB-seeded, approves organizers & events, governs platform

---

## Repository Structure

```
Eventara/
├── eventara-backend/    # Spring Boot REST API
└── eventara-flutter/    # Flutter mobile app
```

See `eventara-backend/README.md` and `eventara-flutter/README.md` for full file trees.

---

## Key Dependency List

### Spring Boot Backend (pom.xml)

| Dependency | Purpose |
|---|---|
| `spring-boot-starter-web` | REST API layer |
| `spring-boot-starter-security` | Spring Security framework |
| `spring-boot-starter-data-jpa` | JPA + Hibernate ORM |
| `spring-boot-starter-validation` | Bean Validation (JSR-380) |
| `spring-boot-starter-mail` | Email notifications |
| `spring-boot-starter-cache` | Caffeine-backed seat lock cache |
| `spring-boot-starter-actuator` | Health/metrics endpoints |
| `postgresql` | PostgreSQL JDBC driver |
| `jjwt-api` + `jjwt-impl` + `jjwt-jackson` v0.12.5 | JWT issue/validate (HMAC-SHA256) |
| `lombok` | Boilerplate reduction (@Data, @Builder) |
| `mapstruct` + `mapstruct-processor` v1.5.5 | Entity ↔ DTO mapping |
| `zxing:core` + `zxing:javase` v3.5.3 | QR code image generation |
| `flyway-core` | Versioned DB migrations |
| `springdoc-openapi-starter-webmvc-ui` v2.5.0 | Swagger UI / OpenAPI 3 |
| `spring-security-test` | Security-aware MockMvc tests |

---

### Flutter Frontend (pubspec.yaml)

| Package | Version | Purpose |
|---|---|---|
| `go_router` | ^13.2.0 | Declarative routing with redirect guards |
| `flutter_riverpod` | ^2.5.1 | State management core |
| `riverpod_annotation` | ^2.3.5 | Annotation-based provider generation |
| `riverpod_generator` | ^2.4.3 | Code-gen for @riverpod providers |
| `hooks_riverpod` | ^2.5.1 | useProvider hooks |
| `freezed` | ^2.5.2 | Immutable data classes + union types |
| `freezed_annotation` | ^2.4.1 | Annotations for freezed |
| `json_serializable` | ^6.8.0 | JSON serialization code-gen |
| `json_annotation` | ^4.9.0 | Annotations for json_serializable |
| `dio` | ^5.4.3 | HTTP client with interceptors |
| `flutter_secure_storage` | ^9.0.0 | JWT storage (Keychain/Keystore) |
| `shared_preferences` | ^2.2.3 | Non-sensitive local preferences |
| `qr_flutter` | ^4.1.0 | QR code display widget |
| `mobile_scanner` | ^5.1.0 | Camera QR code scanner (organizer) |
| `flutter_svg` | ^2.0.10+1 | SVG asset rendering |
| `cached_network_image` | ^3.3.1 | Network image caching |
| `shimmer` | ^3.0.0 | Skeleton loading effect |
| `intl` | ^0.19.0 | Date/number/currency formatting |
| `flutter_dotenv` | ^5.1.0 | .env file loader |
| `build_runner` | ^2.4.9 | Code generation runner |
| `riverpod_lint` + `custom_lint` | ^2.3.10 | Riverpod-specific lint rules |

---

## Architecture Summary

### Backend — Package-by-Feature + Layered
```
Controller → Service (interface + impl) → Repository → Entity
```
- Each feature (`auth`, `user`, `organizer`, `event`, `booking`, `ticket`, `admin`, `notification`) is fully self-contained
- `common/` holds shared base entity, exception handler, response wrappers, and utils
- JWT filter chain in `auth/security/` with `@PreAuthorize` on controllers for fine-grained RBAC

### Frontend — Clean Architecture + Feature-First
```
Presentation (providers + pages + widgets)
    ↓
Domain (entities + usecases + abstract repositories)
    ↓
Data (models + datasources + repository impls)
```
- `core/` holds app-wide concerns: router, theme, DI, network, storage, error handling
- `go_router` redirect reads `authStateProvider` (Riverpod) which decodes the stored JWT role claim
- Each role gets its own home screen and bottom navigation via `ShellRoute`

---

## Event Lifecycle

```
DRAFT → SUBMITTED → UNDER_REVIEW → PUBLISHED
                              ↘ REJECTED
PUBLISHED → COMPLETED
```

## Booking Lifecycle

```
(seat selected) → PENDING_PAYMENT [5-min lock TTL]
                      ↓ pay
                 CONFIRMED → (entry scan) TICKET.USED
                      ↓ cancel / expire
               CANCELLED / EXPIRED
```
