import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../storage/secure_storage_service.dart';
import '../constants/app_constants.dart';

// ── Persisted session state ───────────────────────────────────────────────────

/// Holds the current user's session data read from storage.
class SessionState {
  final bool isAuthenticated;
  final String? role;
  final String? email;
  final String? fullName;

  const SessionState({
    required this.isAuthenticated,
    this.role,
    this.email,
    this.fullName,
  });

  const SessionState.unauthenticated()
      : isAuthenticated = false,
        role = null,
        email = null,
        fullName = null;

  bool get isCustomer => role == AppConstants.roleCustomer;
  bool get isOrganizer => role == AppConstants.roleOrganizer;
  bool get isAdmin => role == AppConstants.roleAdmin;
}

// ── Provider that reads stored session on app start ───────────────────────────

/// Async provider that reads the persisted session from storage.
/// Used by the splash page to decide the initial route.
final persistedSessionProvider = FutureProvider<SessionState>((ref) async {
  final storage = SecureStorageService.instance;
  final token = await storage.getToken();

  if (token == null || token.isEmpty) {
    return const SessionState.unauthenticated();
  }

  final role = await storage.getUserRole();
  final email = await storage.getUserEmail();
  final fullName = await storage.getUserFullName();

  return SessionState(
    isAuthenticated: true,
    role: role,
    email: email,
    fullName: fullName,
  );
});

// ── Reactive session derived from AuthNotifier ────────────────────────────────

/// Derives the live [SessionState] from [authNotifierProvider].
/// Useful for role-based UI rendering throughout the app.
final currentSessionProvider = Provider<SessionState>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return switch (authState) {
    AuthAuthenticated(:final user) => SessionState(
        isAuthenticated: true,
        role: user.role,
        email: user.email,
        fullName: user.fullName,
      ),
    _ => const SessionState.unauthenticated(),
  };
});

/// Convenience provider — returns the role string or null.
final currentRoleProvider = Provider<String?>((ref) {
  return ref.watch(currentSessionProvider).role;
});
