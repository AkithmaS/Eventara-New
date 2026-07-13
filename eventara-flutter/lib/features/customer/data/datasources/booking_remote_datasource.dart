import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/booking_model.dart';
import '../models/ticket_model.dart';

/// Fetches booking and ticket data from the authenticated customer endpoints.
class BookingRemoteDatasource {
  final Dio _dio;

  BookingRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ── Seat locking ───────────────────────────────────────────────────────────

  /// POST /api/customer/bookings/lock-seats
  Future<void> lockSeats({
    required int eventId,
    required List<int> seatIds,
  }) async {
    await _dio.post(
      ApiEndpoints.lockSeats,
      data: {'eventId': eventId, 'seatIds': seatIds},
    );
  }

  // ── Bookings ───────────────────────────────────────────────────────────────

  /// POST /api/customer/bookings
  Future<BookingModel> createBooking({
    required int eventId,
    List<int>? seatIds,
    int? quantity,
  }) async {
    final body = <String, dynamic>{'eventId': eventId};
    if (seatIds != null && seatIds.isNotEmpty) body['seatIds'] = seatIds;
    if (quantity != null) body['quantity'] = quantity;

    final response = await _dio.post(ApiEndpoints.createBooking, data: body);
    final data = _extractData(response.data);
    return BookingModel.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/customer/bookings
  Future<List<BookingModel>> getMyBookings() async {
    final response = await _dio.get(ApiEndpoints.myBookings);
    final data = _extractData(response.data);
    if (data is List) {
      return data
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// GET /api/customer/bookings/{id}
  Future<BookingModel> getBookingById(int id) async {
    final response = await _dio.get(ApiEndpoints.bookingById(id.toString()));
    final data = _extractData(response.data);
    return BookingModel.fromJson(data as Map<String, dynamic>);
  }

  /// POST /api/customer/bookings/{id}/cancel
  Future<BookingModel> cancelBooking(int id) async {
    final response =
        await _dio.post(ApiEndpoints.cancelBooking(id.toString()));
    final data = _extractData(response.data);
    return BookingModel.fromJson(data as Map<String, dynamic>);
  }

  // ── Tickets ────────────────────────────────────────────────────────────────

  /// POST /api/customer/tickets/generate/{bookingId}
  Future<TicketModel> generateTicket(int bookingId) async {
    final response = await _dio.post(
      ApiEndpoints.generateTicket(bookingId.toString()),
    );
    final data = _extractData(response.data);
    return TicketModel.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/customer/tickets
  Future<List<TicketModel>> getMyTickets() async {
    final response = await _dio.get(ApiEndpoints.myTickets);
    final data = _extractData(response.data);
    if (data is List) {
      return data
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// GET /api/customer/tickets/booking/{bookingId}
  Future<TicketModel> getTicketByBookingId(int bookingId) async {
    final response = await _dio.get(
      ApiEndpoints.ticketByBookingId(bookingId.toString()),
    );
    final data = _extractData(response.data);
    return TicketModel.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/customer/tickets/code/{ticketCode}
  Future<TicketModel> getTicketByCode(String code) async {
    final response = await _dio.get(ApiEndpoints.ticketByCode(code));
    final data = _extractData(response.data);
    return TicketModel.fromJson(data as Map<String, dynamic>);
  }

  /// Unwraps the backend envelope: { "data": ..., "message": ..., "success": ... }
  dynamic _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }
}
