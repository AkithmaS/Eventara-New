import '../repositories/auth_repository.dart';

/// Clears stored credentials — effectively logs the user out.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}
