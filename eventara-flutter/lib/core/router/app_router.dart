import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/organizer_apply_page.dart';
import '../../features/customer/presentation/pages/home_page.dart';
import '../../features/customer/presentation/pages/all_events.dart';
import '../../features/customer/presentation/pages/event_detail_page.dart';
import '../../features/customer/presentation/pages/seat_map_page.dart';
import '../../features/customer/presentation/pages/payment_page.dart';
import '../../features/customer/presentation/pages/booking_confirmation_page.dart';
import '../../features/customer/presentation/pages/ticket_display_page.dart';
import '../../features/customer/presentation/pages/booking_history_page.dart';
import '../../features/customer/presentation/pages/profile_page.dart';
import '../../features/organizer/presentation/pages/dashboard_page.dart';
import '../../features/organizer/presentation/pages/create_event_page.dart';
import '../../features/organizer/presentation/pages/edit_event_page.dart';
import '../../features/organizer/presentation/pages/myevents.dart';
import '../../features/organizer/presentation/pages/event_submissions_page.dart';
import '../../features/organizer/presentation/pages/event_bookings_list_page.dart';
import '../../features/organizer/presentation/pages/qr_scanner_page.dart';
import '../../features/organizer/presentation/pages/seat_map_editor_page.dart';
import '../../features/organizer/presentation/pages/pricing_setup_page.dart';
import '../../features/organizer/presentation/pages/organizer_reports_page.dart';
import '../../features/organizer/presentation/pages/organizer_profile_page.dart';
import '../../features/admin/presentation/pages/dashboard_page.dart' as admin;
import '../../features/admin/presentation/pages/organizer_applications_page.dart' as admin_apps;
import '../../features/admin/presentation/pages/category_management_page.dart' as admin_categories;
import '../../features/admin/presentation/pages/analytics_page.dart' as admin_analytics;
import '../../features/admin/presentation/pages/audit_log_page.dart' as admin_audit_log;
import '../../features/admin/presentation/pages/settings_page.dart' as admin_settings;
import '../../features/admin/presentation/pages/user_management_page.dart' as admin_users;
import '../../features/admin/presentation/pages/customer_detail_page.dart' as admin_customer_detail;
import '../../features/admin/presentation/pages/organizer_detail_page.dart' as admin_organizer_detail;
import '../../features/admin/presentation/pages/event_detail_page.dart' as admin_event_detail;
import '../../features/admin/presentation/pages/event_approvals_page.dart' as admin_events;
import '../../features/landing/landing_page.dart';
import 'app_routes.dart';

/// Set to true during UI development to bypass auth checks.
/// Flip to false once login/JWT flow is wired up.
const bool _bypassGuard = true;

/// Reads the stored JWT role from SharedPreferences.
Future<String?> _readRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_role'); // stored as 'ROLE_CUSTOMER', 'ROLE_ORGANIZER', etc.
}

/// Redirect callback for customer routes.
Future<String?> _customerGuard(GoRouterState state) async {
  if (_bypassGuard) return null; // ← remove when auth is ready
  final role = await _readRole();
  if (role == null) return AppRoutes.login;
  if (role != 'ROLE_CUSTOMER') return AppRoutes.login;
  return null;
}

/// Redirect callback for organizer routes.
Future<String?> _organizerGuard(GoRouterState state) async {
  if (_bypassGuard) return null; // ← remove when auth is ready
  final role = await _readRole();
  if (role == null) return AppRoutes.login;
  if (role != 'ROLE_ORGANIZER') return AppRoutes.login;
  return null;
}

/// Redirect callback for admin routes.
Future<String?> _adminGuard(GoRouterState state) async {
  if (_bypassGuard) return null; // ← remove when auth is ready
  final role = await _readRole();
  if (role == null) return AppRoutes.login;
  if (role != 'ROLE_ADMIN') return AppRoutes.login;
  return null;
}

// ── Router provider ───────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── Landing ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const LandingPage(),
      ),

      // ── Auth ─────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.organizerApply,
        builder: (context, state) => const OrganizerApplyPage(),
      ),

      // ── Customer shell ────────────────────────────────────────────────────────
      // All /customer/* routes live here. Each route redirects if not authorised.
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            name: 'customerHome',
            path: AppRoutes.customerHome,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            name: 'customerAllEvents',
            path: AppRoutes.customerAllEvents,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) => const AllEventsPage(),
          ),
          GoRoute(
            name: 'customerEventDetail',
            path: AppRoutes.customerEventDetail,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return EventDetailPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'customerSeatMap',
            path: AppRoutes.customerSeatMap,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return SeatMapPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'customerPayment',
            path: AppRoutes.customerPayment,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return PaymentPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'customerBookingConfirmation',
            path: AppRoutes.customerBookingConfirmation,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return BookingConfirmationPage(
                bookingRef: id,
                eventName: state.uri.queryParameters['eventName'] ?? '',
                eventDate: state.uri.queryParameters['eventDate'] ?? '',
                venue: state.uri.queryParameters['venue'] ?? '',
                holderName: state.uri.queryParameters['holderName'] ?? '',
                seatsCount: state.uri.queryParameters['seatsCount'] ?? '1',
                totalPrice: state.uri.queryParameters['totalPrice'] ?? '0',
              );
            },
          ),
          GoRoute(
            name: 'customerMyTickets',
            path: AppRoutes.customerMyTickets,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) => const TicketDisplayPage(),
          ),
          GoRoute(
            name: 'customerBookingHistory',
            path: AppRoutes.customerBookingHistory,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) => const BookingHistoryPage(),
          ),
          GoRoute(
            name: 'customerProfile',
            path: AppRoutes.customerProfile,
            redirect: (context, state) async => _customerGuard(state),
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // ── Organizer shell ───────────────────────────────────────────────────────
      // All /organizer/* routes live here. Each route redirects if not authorised.
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            name: 'organizerDashboard',
            path: AppRoutes.organizerDashboard,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const OrganizerDashboardPage(),
          ),
          GoRoute(
            name: 'organizerMyEvents',
            path: AppRoutes.organizerMyEvents,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const MyEventsPage(),
          ),
          GoRoute(
            name: 'organizerCreateEvent',
            path: AppRoutes.organizerCreateEvent,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const CreateEventPage(),
          ),
          GoRoute(
            name: 'organizerEditEvent',
            path: AppRoutes.organizerEditEvent,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return EditEventPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'organizerEventSubmissions',
            path: AppRoutes.organizerEventSubmissions,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const EventSubmissionsPage(),
          ),
          GoRoute(
            name: 'organizerBookings',
            path: AppRoutes.organizerBookings,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const EventBookingsListPage(),
          ),
          GoRoute(
            name: 'organizerQRScanner',
            path: AppRoutes.organizerQRScanner,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const QRScannerPage(),
          ),
          GoRoute(
            name: 'organizerSeatMapEditor',
            path: AppRoutes.organizerSeatMapEditor,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return SeatMapEditorPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'organizerPricingSetup',
            path: AppRoutes.organizerPricingSetup,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return PricingSetupPage(eventId: id);
            },
          ),
          GoRoute(
            name: 'organizerReports',
            path: AppRoutes.organizerReports,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const OrganizerReportsPage(),
          ),
          GoRoute(
            name: 'organizerProfile',
            path: AppRoutes.organizerProfile,
            redirect: (context, state) async => _organizerGuard(state),
            builder: (context, state) => const OrganizerProfilePage(),
          ),
        ],
      ),

      // ── Admin shell ────────────────────────────────────────────────────────
      // All /admin/* routes live here. Each route redirects if not authorised.
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            name: 'adminDashboard',
            path: AppRoutes.adminDashboard,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin.AdminDashboardPage(),
          ),
          GoRoute(
            name: 'adminUsers',
            path: AppRoutes.adminUsers,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) {
              final orgStatus = state.uri.queryParameters['orgStatus'];
              return admin_users.UserManagementPage(initialOrganizerStatus: orgStatus);
            },
          ),
          GoRoute(
            name: 'adminEvents',
            path: AppRoutes.adminEvents,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) {
              final tabIndex = state.uri.queryParameters['tabIndex'];
              return admin_events.EventApprovalsPage(initialTabIndex: tabIndex);
            },
          ),
          GoRoute(
            name: 'adminSettings',
            path: AppRoutes.adminSettings,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin_settings.AdminSettingsPage(),
          ),
          GoRoute(
            name: 'adminOrganizerApplications',
            path: AppRoutes.adminOrganizerApplications,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin_apps.OrganizerApplicationsPage(),
          ),
          GoRoute(
            name: 'adminCategories',
            path: AppRoutes.adminCategories,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin_categories.CategoryManagementPage(),
          ),
          GoRoute(
            name: 'adminAnalytics',
            path: AppRoutes.adminAnalytics,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin_analytics.AnalyticsPage(),
          ),
          GoRoute(
            name: 'adminAuditLog',
            path: AppRoutes.adminAuditLog,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) => const admin_audit_log.AuditLogPage(),
          ),
          GoRoute(
            name: 'adminCustomerDetail',
            path: AppRoutes.adminCustomerDetail,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return admin_customer_detail.CustomerDetailPage(customerId: id);
            },
          ),
          GoRoute(
            name: 'adminOrganizerDetail',
            path: AppRoutes.adminOrganizerDetail,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return admin_organizer_detail.OrganizerDetailPage(organizerId: id);
            },
          ),
          GoRoute(
            name: 'adminEventDetail',
            path: AppRoutes.adminEventDetail,
            redirect: (context, state) async => _adminGuard(state),
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return admin_event_detail.AdminEventDetailPage(eventId: id);
            },
          ),
        ],
      ),
    ],

    // Global error page
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
});
