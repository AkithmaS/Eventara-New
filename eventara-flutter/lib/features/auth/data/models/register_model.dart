import 'package:equatable/equatable.dart';

/// Maps to the backend RegisterRequest payload:
/// ```json
/// {
///   "fullName": "...",
///   "email": "...",
///   "password": "...",
///   "phoneNumber": "..."
/// }
/// ```
class RegisterModel extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      };

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber];
}

/// Maps to the backend OrganizerApplicationRequest payload:
/// ```json
/// {
///   "fullName": "...",
///   "email": "...",
///   "password": "...",
///   "phoneNumber": "...",
///   "businessName": "...",
///   "businessDescription": "..."
/// }
/// ```
class OrganizerApplicationModel extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String businessName;
  final String businessDescription;

  const OrganizerApplicationModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.businessName,
    required this.businessDescription,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'businessName': businessName,
        'businessDescription': businessDescription,
      };

  @override
  List<Object?> get props =>
      [fullName, email, password, phoneNumber, businessName, businessDescription];
}
