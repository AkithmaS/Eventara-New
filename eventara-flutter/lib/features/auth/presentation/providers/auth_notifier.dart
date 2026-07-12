import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/register_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

// ── State definition ──────────────────────────────────────────────────────────

/// Represents the complete auth state of the app.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthOrganizerApplySuccess extends AuthState {
  const AuthOrganizerApplySuccess();
}

// ── Providers ─────────────────────────────────────────────────────────────────

/// Provides the [AuthRepository] implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: AuthRemoteDatasource(),
    storage: SecureStorageService.instance,
  );
});

/// Manages the auth state for login / register / organizer-apply / logout.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  late final LoginUseCase _login;
  late final RegisterUseCase _register;
  late final LogoutUseCase _logout;

  AuthNotifier(this._repository) : super(const AuthInitial()) {
    _login = LoginUseCase(_repository);
    _register = RegisterUseCase(_repository);
    _logout = LogoutUseCase(_repository);
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _login(email: email, password: password);
      state = AuthAuthenticated(user);
    } on AppException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  // ── Admin Login ────────────────────────────────────────────────────────────

  Future<void> adminLogin({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.adminLogin(email: email, password: password);
      state = AuthAuthenticated(user);
    } on AppException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _register(
        RegisterModel(
          fullName: fullName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
        ),
      );
      state = AuthAuthenticated(user);
    } on AppException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  // ── Organizer apply ────────────────────────────────────────────────────────

  Future<void> applyOrganizer({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String businessName,
    required String businessDescription,
  }) async {
    state = const AuthLoading();
    try {
      await _repository.applyOrganizer(
        OrganizerApplicationModel(
          fullName: fullName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          businessName: businessName,
          businessDescription: businessDescription,
        ),
      );
      state = const AuthOrganizerApplySuccess();
    } on AppException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _logout();
    state = const AuthUnauthenticated();
  }

  // ── Reset error ────────────────────────────────────────────────────────────

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}
