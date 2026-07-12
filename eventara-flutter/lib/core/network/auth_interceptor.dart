import 'package:dio/dio.dart';
import '../network/api_endpoints.dart';
import '../storage/secure_storage_service.dart';

/// Attaches the Bearer token to every outgoing request.
/// On a 401 response, clears stored credentials and signals the app to
/// navigate back to login. The actual navigation is handled by
/// [authStateProvider] reacting to the cleared storage.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;

  /// Optional callback invoked on 401 so the router can redirect.
  final void Function()? onUnauthorized;

  AuthInterceptor({
    SecureStorageService? storage,
    this.onUnauthorized,
  }) : _storage = storage ?? SecureStorageService.instance;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip attaching token for public auth endpoints.
    final path = options.path;
    final isPublic = path == ApiEndpoints.login ||
        path == ApiEndpoints.register ||
        path == ApiEndpoints.organizerApply;

    if (!isPublic) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Clear all stored credentials.
      await _storage.deleteAll();
      // Notify the app (router refresh / provider invalidation).
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
