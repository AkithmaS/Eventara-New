import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around SharedPreferences for token + user data persistence.
///
/// Note: flutter_secure_storage is disabled for Windows dev builds due to
/// a space-in-path limitation. SharedPreferences is used instead.
/// Switch to flutter_secure_storage for production mobile builds.
class SecureStorageService {
  SecureStorageService._();

  static SecureStorageService? _instance;
  static SecureStorageService get instance =>
      _instance ??= SecureStorageService._();

  // ── Token ──────────────────────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  // ── User metadata ──────────────────────────────────────────────────────────

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userRoleKey);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userEmailKey);
  }

  Future<void> saveUserFullName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userFullNameKey, name);
  }

  Future<String?> getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userFullNameKey);
  }

  /// Save all auth data in a single call.
  Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    required String role,
    required String email,
    required String fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(AppConstants.tokenKey, token),
      prefs.setString(AppConstants.refreshTokenKey, refreshToken),
      prefs.setString(AppConstants.userRoleKey, role),
      prefs.setString(AppConstants.userEmailKey, email),
      prefs.setString(AppConstants.userFullNameKey, fullName),
    ]);
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  /// Clears all stored auth data.
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(AppConstants.tokenKey),
      prefs.remove(AppConstants.refreshTokenKey),
      prefs.remove(AppConstants.userRoleKey),
      prefs.remove(AppConstants.userEmailKey),
      prefs.remove(AppConstants.userFullNameKey),
    ]);
  }
}
