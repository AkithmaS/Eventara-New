/// Centralized route path constants for the Eventara app.
class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const organizerApply = '/organizer-apply';

  // ── Customer ──────────────────────────────────────────────────────────────
  static const customerHome = '/customer/home';
  static const customerAllEvents = '/customer/all-events';
  static const customerEventDetail = '/customer/event-detail/:id';
  static const customerSeatMap = '/customer/seat-map/:id';
  static const customerPayment = '/customer/payment/:id';
  static const customerBookingConfirmation = '/customer/booking-confirmation/:id';
  static const customerMyTickets = '/customer/my-tickets';
  static const customerBookingHistory = '/customer/booking-history';
  static const customerProfile = '/customer/profile';

  // ── Organizer ─────────────────────────────────────────────────────────────
  static const organizerDashboard = '/organizer/dashboard';
  static const organizerMyEvents = '/organizer/my-events';
  static const organizerCreateEvent = '/organizer/create-event';
  static const organizerEditEvent = '/organizer/edit-event/:id';
  static const organizerEventSubmissions = '/organizer/event-submissions';
  static const organizerBookings = '/organizer/bookings';
  static const organizerQRScanner = '/organizer/qr-scanner';
  static const organizerSeatMapEditor = '/organizer/seat-map-editor/:id';
  static const organizerPricingSetup = '/organizer/pricing-setup/:id';
  static const organizerReports = '/organizer/reports';
  static const organizerProfile = '/organizer/profile';

  // ── Admin ──────────────────────────────────────────────────────────────
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminEvents = '/admin/events';
  static const adminSettings = '/admin/settings';
  static const adminOrganizerApplications = '/admin/organizer-applications';
  static const adminCategories = '/admin/categories';
  static const adminAnalytics = '/admin/analytics';
  static const adminAuditLog = '/admin/audit-log';
  static const adminCustomerDetail = '/admin/users/customer-detail/:id';
  static const adminOrganizerDetail = '/admin/users/organizer-detail/:id';
  static const adminEventDetail = '/admin/events/event-detail/:id';

  // ── Helpers to build parameterised paths ─────────────────────────────────
  static String buildCustomerEventDetail(String id) => '/customer/event-detail/$id';
  static String buildCustomerSeatMap(String id) => '/customer/seat-map/$id';
  static String buildCustomerPayment(String id) => '/customer/payment/$id';
  static String buildCustomerBookingConfirmation(
    String id, {
    required String eventName,
    required String eventDate,
    required String venue,
    required String holderName,
    required String seatsCount,
    required String totalPrice,
  }) =>
      '/customer/booking-confirmation/$id?eventName=$eventName&eventDate=$eventDate&venue=$venue&holderName=$holderName&seatsCount=$seatsCount&totalPrice=$totalPrice';
  static String buildOrganizerEditEvent(String id) => '/organizer/edit-event/$id';
  static String buildOrganizerSeatMapEditor(String id) => '/organizer/seat-map-editor/$id';
  static String buildOrganizerPricingSetup(String id) => '/organizer/pricing-setup/$id';
  static String buildAdminCustomerDetail(String id) => '/admin/users/customer-detail/$id';
  static String buildAdminOrganizerDetail(String id) => '/admin/users/organizer-detail/$id';
  static String buildAdminEventDetail(String id) => '/admin/events/event-detail/$id';
  static String buildAdminEventsPending() => '/admin/events?tabIndex=pending';
  static String buildAdminUsersPending() => '/admin/users?orgStatus=Pending';
}
