import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App-wide constants for Eventara.
class AppConstants {
  AppConstants._();

  // ── Network ────────────────────────────────────────────────────────────────
  /// Base URL is loaded from .env → API_BASE_URL.
  /// Fallback to localhost for Flutter web / iOS sim.
  static String get baseUrl =>
      dotenv.maybeGet('API_BASE_URL') ?? 'http://localhost:8080';

  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;

  // ── Storage keys ───────────────────────────────────────────────────────────
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userEmailKey = 'user_email';
  static const String userFullNameKey = 'user_full_name';

  // ── Role values (as returned by backend) ──────────────────────────────────
  static const String roleCustomer = 'ROLE_CUSTOMER';
  static const String roleOrganizer = 'ROLE_ORGANIZER';
  static const String roleAdmin = 'ROLE_ADMIN';

  // ── Pagination ─────────────────────────────────────────────────────────────
  static const int pageSizeDefault = 20;

  // ── Seat locking ──────────────────────────────────────────────────────────
  static const int seatLockDurationMinutes = 10;

  // ── Animations ────────────────────────────────────────────────────────────
  static const int animationDurationMs = 300;

  // ── Upload limits ──────────────────────────────────────────────────────────
  static const int maxImageUploadSizeMb = 10;
}
