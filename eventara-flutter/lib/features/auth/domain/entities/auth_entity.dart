import 'package:equatable/equatable.dart';

/// Domain entity representing a successfully authenticated user.
/// This is the clean, framework-agnostic model used in the domain layer.
class AuthEntity extends Equatable {
  final String token;
  final String refreshToken;
  final String email;
  final String role;
  final String fullName;

  const AuthEntity({
    required this.token,
    required this.refreshToken,
    required this.email,
    required this.role,
    required this.fullName,
  });

  bool get isCustomer => role == 'ROLE_CUSTOMER';
  bool get isOrganizer => role == 'ROLE_ORGANIZER';
  bool get isAdmin => role == 'ROLE_ADMIN';

  @override
  List<Object?> get props => [token, refreshToken, email, role, fullName];
}
