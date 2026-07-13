import '../entities/booking_entity.dart';

/// Abstract contract for booking and ticket data access.
abstract class BookingRepository {
  // ── Seat locking ───────────────────────────────────────────────────────────
  Future<void> lockSeats({required int eventId, required List<int> seatIds});

  // ── Bookings ───────────────────────────────────────────────────────────────
  Future<BookingEntity> createBooking({
    required int eventId,
    List<int>? seatIds,
    int? quantity,
  });

  Future<List<BookingEntity>> getMyBookings();
  Future<BookingEntity> getBookingById(int id);
  Future<BookingEntity> cancelBooking(int id);

  // ── Tickets ────────────────────────────────────────────────────────────────
  Future<TicketEntity> generateTicket(int bookingId);
  Future<List<TicketEntity>> getMyTickets();
  Future<TicketEntity> getTicketByBookingId(int bookingId);
  Future<TicketEntity> getTicketByCode(String code);
}
