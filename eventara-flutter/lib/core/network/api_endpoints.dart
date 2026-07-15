/// Centralized API endpoint paths matching the Spring Boot backend.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth (public) ──────────────────────────────────────────────────────────
  static const String login = '/api/auth/login';
  static const String adminLogin = '/api/auth/admin/login';
  static const String register = '/api/auth/register';
  static const String organizerApply = '/api/auth/organizer/apply';
  static const String refreshToken = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';

  // ── User ──────────────────────────────────────────────────────────────────
  static const String userProfile = '/api/users/me';
  static const String updateProfile = '/api/users/me';
  static const String changePassword = '/api/users/me/change-password';

  // ── Events (public) ───────────────────────────────────────────────────────
  static const String events = '/api/events';
  static String eventById(String id) => '/api/events/$id';
  static const String eventCategories = '/api/events/categories';
  static const String featuredEvents = '/api/events/featured';
  static const String searchEvents = '/api/events/search';

  // ── Organizer ─────────────────────────────────────────────────────────────
  static const String organizerProfile = '/api/organizer/profile';
  static const String organizerDashboard = '/api/organizer/dashboard';
  static const String organizerEvents = '/api/organizer/events';
  static const String organizerEventsByStatus = '/api/organizer/events/status';
  static const String organizerCreateEvent = '/api/organizer/events';
  static String organizerUpdateEvent(String id) => '/api/organizer/events/$id';
  static String organizerEventById(String id) => '/api/organizer/events/$id';
  static String organizerSubmitEvent(String id) => '/api/organizer/events/$id/submit';
  static String organizerCancelEvent(String id) => '/api/organizer/events/$id/cancel';
  static String organizerSeatMap(String id) => '/api/organizer/events/$id/seatmap';
  static String organizerPricingZones(String id) => '/api/organizer/events/$id/pricing';
  static String seatMapEditor(String eventId) => '/api/organizer/events/$eventId/seats';
  static String pricingSetup(String eventId) => '/api/organizer/events/$eventId/pricing';
  static const String organizerReports = '/api/organizer/reports';
  static String submitEvent(String id) => '/api/organizer/events/$id/submit';

  // ── Customer Bookings ─────────────────────────────────────────────────────
  static const String lockSeats = '/api/customer/bookings/lock-seats';
  static const String createBooking = '/api/customer/bookings';
  static const String myBookings = '/api/customer/bookings';
  static String bookingById(String id) => '/api/customer/bookings/$id';
  static String cancelBooking(String id) => '/api/customer/bookings/$id/cancel';

  // ── Customer Tickets ──────────────────────────────────────────────────────
  static String generateTicket(String bookingId) =>
      '/api/customer/tickets/generate/$bookingId';
  static const String myTickets = '/api/customer/tickets';
  static String ticketByBookingId(String bookingId) =>
      '/api/customer/tickets/booking/$bookingId';
  static String ticketByCode(String ticketCode) =>
      '/api/customer/tickets/code/$ticketCode';

  // ── Legacy aliases kept for backward-compat ───────────────────────────────
  static String bookingQr(String id) => '/api/customer/bookings/$id/qr';
  static const String bookingHistory = '/api/customer/bookings';

  // ── Seat Map ──────────────────────────────────────────────────────────────
  static String seatMap(String eventId) => '/api/events/$eventId/seats';
  static String lockSeat(String eventId) => '/api/events/$eventId/seats/lock';
  static String unlockSeat(String eventId) => '/api/events/$eventId/seats/unlock';

  // ── Admin ─────────────────────────────────────────────────────────────────
  static const String adminUsers = '/api/admin/users';
  static String adminUserById(String id) => '/api/admin/users/$id';
  static const String adminEvents = '/api/admin/events';
  static String adminEventById(String id) => '/api/admin/events/$id';
  static String approveEvent(String id) => '/api/admin/events/$id/approve';
  static String rejectEvent(String id) => '/api/admin/events/$id/reject';
  static const String adminOrganizerApplications = '/api/admin/organizer-applications';
  static String approveOrganizer(String id) =>
      '/api/admin/organizer-applications/$id/approve';
  static String rejectOrganizer(String id) =>
      '/api/admin/organizer-applications/$id/reject';
  static const String adminCategories = '/api/admin/categories';
  static const String adminAnalytics = '/api/admin/analytics';
  static const String adminAuditLog = '/api/admin/audit-log';
  static const String adminDashboard = '/api/admin/dashboard';
}
