// DioClient — singleton Dio instance
// Base URL from flutter_dotenv
// Interceptors: AuthInterceptor (attach Bearer token),
//               RefreshInterceptor (auto-refresh on 401),
//               ErrorInterceptor (map DioError → AppException)
