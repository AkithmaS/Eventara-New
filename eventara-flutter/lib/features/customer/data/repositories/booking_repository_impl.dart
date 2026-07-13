import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

/// Implements [BookingRepository] by delegating to [BookingRemoteDatasource].
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _remote;

  BookingRepositoryImpl({BookingRemoteDatasource? remote})
      : _remote = remote ?? BookingRemoteDatasource();

  @override
  Future<void> lockSeats({
    required int eventId,
    required List<int> seatIds,
  }) async {
    await _remote.lockSeats(eventId: eventId, seatIds: seatIds);
  }

  @override
  Future<BookingEntity> createBooking({
    required int eventId,
    List<int>? seatIds,
    int? quantity,
  }) async {
    final model = await _remote.createBooking(
      eventId: eventId,
      seatIds: seatIds,
      quantity: quantity,
    );
    return model.toEntity();
  }

  @override
  Future<List<BookingEntity>> getMyBookings() async {
    final models = await _remote.getMyBookings();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BookingEntity> getBookingById(int id) async {
    final model = await _remote.getBookingById(id);
    return model.toEntity();
  }

  @override
  Future<BookingEntity> cancelBooking(int id) async {
    final model = await _remote.cancelBooking(id);
    return model.toEntity();
  }

  @override
  Future<TicketEntity> generateTicket(int bookingId) async {
    final model = await _remote.generateTicket(bookingId);
    return model.toEntity();
  }

  @override
  Future<List<TicketEntity>> getMyTickets() async {
    final models = await _remote.getMyTickets();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TicketEntity> getTicketByBookingId(int bookingId) async {
    final model = await _remote.getTicketByBookingId(bookingId);
    return model.toEntity();
  }

  @override
  Future<TicketEntity> getTicketByCode(String code) async {
    final model = await _remote.getTicketByCode(code);
    return model.toEntity();
  }
}
