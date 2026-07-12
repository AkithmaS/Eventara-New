import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/register_model.dart';

/// Concrete implementation of [AuthRepository].
///
/// Responsibilities:
/// - Delegate network calls to [AuthRemoteDatasource].
/// - Persist / clear tokens via [SecureStorageService].
/// - Re-throw [AppException] subtypes so the notifier can surface them.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    AuthRemoteDatasource? remote,
    SecureStorageService? storage,
  })  : _remote = remote ?? AuthRemoteDatasource(),
        _storage = storage ?? SecureStorageService.instance;

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await _remote.login(email: email, password: password);
    final entity = model.toEntity();
    await _persistAuth(entity);
    return entity;
  }

  @override
  Future<AuthEntity> adminLogin({
    required String email,
    required String password,
  }) async {
    final model = await _remote.adminLogin(email: email, password: password);
    final entity = model.toEntity();
    await _persistAuth(entity);
    return entity;
  }

  @override
  Future<AuthEntity> register(RegisterModel model) async {
    final responseModel = await _remote.register(model);
    final entity = responseModel.toEntity();
    await _persistAuth(entity);
    return entity;
  }

  @override
  Future<void> applyOrganizer(OrganizerApplicationModel model) async {
    await _remote.applyOrganizer(model);
    // No token — application is pending review.
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<void> _persistAuth(AuthEntity entity) async {
    await _storage.saveAuthData(
      token: entity.token,
      refreshToken: entity.refreshToken,
      role: entity.role,
      email: entity.email,
      fullName: entity.fullName,
    );
  }
}
