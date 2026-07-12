/// Sealed exception hierarchy for Eventara network/domain errors.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection. Please check your network.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired. Please log in again.']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error. Please try again later.']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred.']);
}
