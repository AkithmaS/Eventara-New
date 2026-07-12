import '../entities/auth_entity.dart';
import '../../data/models/register_model.dart';

/// Abstract contract for the auth feature.
/// Implementations live in the data layer.
abstract interface class AuthRepository {
  /// Authenticate customer or organizer with email + password.
  Future<AuthEntity> login({
    required String email,
    required String password,
  });

  /// Authenticate admin accounts only.
  Future<AuthEntity> adminLogin({
    required String email,
    required String password,
  });

  /// Register a new customer account. Returns [AuthEntity] on success.
  Future<AuthEntity> register(RegisterModel model);

  /// Submit an organizer application. Returns void — no token is issued.
  Future<void> applyOrganizer(OrganizerApplicationModel model);

  /// Clear stored tokens (local logout — no server round-trip required).
  Future<void> logout();
}
