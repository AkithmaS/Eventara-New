import '../../data/models/register_model.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the customer registration business rule.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<AuthEntity> call(RegisterModel model) =>
      _repository.register(model);
}
