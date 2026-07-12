import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

/// Data model mirroring the backend AuthResponse:
/// ```json
/// {
///   "data": {
///     "token": "...",
///     "refreshToken": "...",
///     "email": "...",
///     "role": "ROLE_CUSTOMER",
///     "fullName": "..."
///   },
///   "message": "Login successful",
///   "success": true
/// }
/// ```
class AuthResponseModel extends Equatable {
  final String token;
  final String refreshToken;
  final String email;
  final String role;
  final String fullName;

  const AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.email,
    required this.role,
    required this.fullName,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend wraps the payload in a "data" field.
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return AuthResponseModel(
      token: data['token'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'email': email,
        'role': role,
        'fullName': fullName,
      };

  /// Convert to the domain entity used in upper layers.
  AuthEntity toEntity() => AuthEntity(
        token: token,
        refreshToken: refreshToken,
        email: email,
        role: role,
        fullName: fullName,
      );

  @override
  List<Object?> get props => [token, refreshToken, email, role, fullName];
}
