import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_routes.dart';

/// Shown on app startup while we check for a persisted token.
/// Redirects to the correct destination based on stored role.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(persistedSessionProvider);

    session.whenData((s) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (!s.isAuthenticated) {
          context.go('/landing');
          return;
        }
        switch (s.role) {
          case AppConstants.roleOrganizer:
            context.go(AppRoutes.organizerDashboard);
          case AppConstants.roleAdmin:
            context.go(AppRoutes.adminDashboard);
          default:
            context.go(AppRoutes.customerHome);
        }
      });
    });

    // While loading, show the branded splash.
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo mark
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B5CF6), Color(0xFFE07BB0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B5CF6).withValues(alpha: 0.45),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF9B8AFB), Color(0xFFE07BB0)],
              ).createShader(bounds),
              child: const Text(
                'Eventara',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF7B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
