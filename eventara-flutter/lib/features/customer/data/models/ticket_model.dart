import '../../domain/entities/booking_entity.dart';

/// JSON-serializable model matching the backend TicketResponse.
class TicketModel {
  final int id;
  final String ticketCode;
  final String bookingReference;
  final int eventId;
  final String eventName;
  final String eventDate;
  final String venue;
  final String customerName;
  final String? seatDetails;
  final int quantity;
  final double totalAmount;
  final String status;
  final String issuedAt;
  final String? qrCodeBase64;

  const TicketModel({
    required this.id,
    required this.ticketCode,
    required this.bookingReference,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.venue,
    required this.customerName,
    this.seatDetails,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.issuedAt,
    this.qrCodeBase64,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as int,
      ticketCode: json['ticketCode'] as String? ?? '',
      bookingReference: json['bookingReference'] as String? ?? '',
      eventId: json['eventId'] as int? ?? 0,
      eventName: json['eventName'] as String? ?? '',
      eventDate: json['eventDate'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      seatDetails: json['seatDetails'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      totalAmount: _toDouble(json['totalAmount']),
      status: json['status'] as String? ?? 'VALID',
      issuedAt: json['issuedAt'] as String? ?? '',
      qrCodeBase64: json['qrCodeBase64'] as String?,
    );
  }

  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      ticketCode: ticketCode,
      bookingReference: bookingReference,
      eventId: eventId,
      eventName: eventName,
      eventDate: eventDate,
      venue: venue,
      customerName: customerName,
      seatDetails: seatDetails,
      quantity: quantity,
      totalAmount: totalAmount,
      status: status,
      issuedAt: issuedAt,
      qrCodeBase64: qrCodeBase64,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
