import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/create_booking_usecase.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  final BookingEntity booking;
  const BookingSuccess(this.booking);
}

class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const BookingsLoaded(this.bookings);
}

class TicketGenerated extends BookingState {
  final TicketEntity ticket;
  const TicketGenerated(this.ticket);
}

class TicketsLoaded extends BookingState {
  final List<TicketEntity> tickets;
  const TicketsLoaded(this.tickets);
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
}

// ── Providers ─────────────────────────────────────────────────────────────────

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl();
});

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingNotifier(repository);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

class BookingNotifier extends StateNotifier<BookingState> {
  final BookingRepository _repository;
  final CreateBookingUseCase _createBooking;

  BookingNotifier(this._repository)
      : _createBooking = CreateBookingUseCase(_repository),
        super(const BookingInitial());

  Future<BookingEntity?> createBooking({
    required int eventId,
    List<int>? seatIds,
    int? quantity,
  }) async {
    state = const BookingLoading();
    try {
      final booking = await _createBooking(
        eventId: eventId,
        seatIds: seatIds,
        quantity: quantity,
      );
      state = BookingSuccess(booking);
      return booking;
    } catch (e) {
      state = BookingError(_errorMessage(e));
      return null;
    }
  }

  Future<void> loadMyBookings() async {
    state = const BookingLoading();
    try {
      final bookings = await _repository.getMyBookings();
      state = BookingsLoaded(bookings);
    } catch (e) {
      state = BookingError(_errorMessage(e));
    }
  }

  Future<BookingEntity?> cancelBooking(int id) async {
    state = const BookingLoading();
    try {
      final booking = await _repository.cancelBooking(id);
      // Reload list after cancellation.
      await loadMyBookings();
      return booking;
    } catch (e) {
      state = BookingError(_errorMessage(e));
      return null;
    }
  }

  Future<TicketEntity?> generateTicket(int bookingId) async {
    state = const BookingLoading();
    try {
      final ticket = await _repository.generateTicket(bookingId);
      state = TicketGenerated(ticket);
      return ticket;
    } catch (e) {
      state = BookingError(_errorMessage(e));
      return null;
    }
  }

  Future<void> loadMyTickets() async {
    state = const BookingLoading();
    try {
      final tickets = await _repository.getMyTickets();
      state = TicketsLoaded(tickets);
    } catch (e) {
      state = BookingError(_errorMessage(e));
    }
  }

  void reset() {
    state = const BookingInitial();
  }

  String _errorMessage(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}
