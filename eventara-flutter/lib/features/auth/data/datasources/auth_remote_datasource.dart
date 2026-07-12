import 'package:dio/dio.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/register_model.dart';

/// Performs raw HTTP calls to the auth endpoints.
/// Throws [AppException] subtypes on failure.
class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// POST /api/auth/login  (customers & organizers only)
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      _assertSuccess(response);
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('AUTH ERROR: $e');
      throw _mapDioError(e);
    }
  }

  /// POST /api/auth/admin/login  (admins only)
  Future<AuthResponseModel> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.adminLogin,
        data: {'email': email, 'password': password},
      );
      _assertSuccess(response);
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('ADMIN AUTH ERROR: $e');
      throw _mapDioError(e);
    }
  }

  /// POST /api/auth/register
  Future<AuthResponseModel> register(RegisterModel model) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: model.toJson(),
      );
      _assertSuccess(response);
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// POST /api/auth/organizer/apply
  Future<void> applyOrganizer(OrganizerApplicationModel model) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.organizerApply,
        data: model.toJson(),
      );
      _assertSuccess(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Throws [ServerException] when the backend returns success: false.
  void _assertSuccess(Response response) {
    final body = response.data;
    if (body is Map<String, dynamic> && body['success'] == false) {
      final msg = body['message'] as String? ?? 'Request failed.';
      throw ServerException(msg);
    }
  }

  AppException _mapDioError(DioException e) {
    // Backend error body may carry a human-readable message.
    String? backendMessage;
    if (e.response?.data is Map<String, dynamic>) {
      backendMessage =
          (e.response!.data as Map<String, dynamic>)['message'] as String?;
    }

    switch (e.response?.statusCode) {
      case 400:
        return ValidationException(backendMessage ?? 'Invalid request data.');
      case 401:
        return UnauthorizedException(
            backendMessage ?? 'Invalid credentials.');
      case 404:
        return NotFoundException(backendMessage ?? 'Resource not found.');
      default:
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode >= 500) {
          return ServerException(
              backendMessage ?? 'Server error. Please try again.');
        }
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return const NetworkException('Request timed out. Please try again.');
        }
        if (e.type == DioExceptionType.connectionError) {
          // ignore: avoid_print
          print('AUTH ERROR: $e');
          return NetworkException(
              'Cannot reach the server. $e');
        }
        // ignore: avoid_print
        print('AUTH ERROR: $e');
        return UnknownException(backendMessage ?? e.message ?? 'Unknown error.');
    }
  }
}
