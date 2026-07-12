import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the login business rule.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<AuthEntity> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}
