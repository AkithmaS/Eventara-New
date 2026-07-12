import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage_service.dart';
import 'app_routes.dart';

/// Reads the stored role and redirects unauthorized access.
/// Returns `null` if the user is allowed through.

Future<String?> customerGuard(GoRouterState state) async {
  final role = await SecureStorageService.instance.getUserRole();
  if (role == null || role.isEmpty) return AppRoutes.login;
  if (role != AppConstants.roleCustomer) return AppRoutes.login;
  return null;
}

Future<String?> organizerGuard(GoRouterState state) async {
  final role = await SecureStorageService.instance.getUserRole();
  if (role == null || role.isEmpty) return AppRoutes.login;
  if (role != AppConstants.roleOrganizer) return AppRoutes.login;
  return null;
}

Future<String?> adminGuard(GoRouterState state) async {
  final role = await SecureStorageService.instance.getUserRole();
  if (role == null || role.isEmpty) return AppRoutes.adminLogin;
  if (role != AppConstants.roleAdmin) return AppRoutes.adminLogin;
  return null;
}
