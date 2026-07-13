import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

/// Creates a booking for an event.
class CreateBookingUseCase {
  final BookingRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<BookingEntity> call({
    required int eventId,
    List<int>? seatIds,
    int? quantity,
  }) {
    return _repository.createBooking(
      eventId: eventId,
      seatIds: seatIds,
      quantity: quantity,
    );
  }
}
