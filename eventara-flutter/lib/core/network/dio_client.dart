import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';

/// Singleton Dio instance pre-configured for the Eventara backend.
class DioClient {
  DioClient._();

  static DioClient? _instance;
  static DioClient get instance => _instance ??= DioClient._();

  late final Dio _dio = _buildDio();

  Dio get dio => _dio;

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.connectTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.receiveTimeoutSeconds),
        sendTimeout: const Duration(seconds: AppConstants.sendTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    // Attach auth interceptor.
    dio.interceptors.add(AuthInterceptor());

    // Pretty logging for debug builds only.
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());

    return dio;
  }

  /// Allows injecting a custom [AuthInterceptor] (e.g. with onUnauthorized
  /// callback wired to the router).
  void setAuthInterceptor(AuthInterceptor interceptor) {
    _dio.interceptors
        .removeWhere((i) => i is AuthInterceptor);
    _dio.interceptors.insert(0, interceptor);
  }
}
