import '../../domain/entities/booking_entity.dart';

/// JSON-serializable model matching the backend BookingResponse.
class BookingModel {
  final int id;
  final String bookingReference;
  final int eventId;
  final String eventName;
  final int customerId;
  final String customerName;
  final String? seatDetails;
  final int quantity;
  final double totalAmount;
  final String status;
  final String createdAt;

  const BookingModel({
    required this.id,
    required this.bookingReference,
    required this.eventId,
    required this.eventName,
    required this.customerId,
    required this.customerName,
    this.seatDetails,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      bookingReference: json['bookingReference'] as String? ?? '',
      eventId: json['eventId'] as int? ?? 0,
      eventName: json['eventName'] as String? ?? '',
      customerId: json['customerId'] as int? ?? 0,
      customerName: json['customerName'] as String? ?? '',
      seatDetails: json['seatDetails'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      totalAmount: _toDouble(json['totalAmount']),
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      bookingReference: bookingReference,
      eventId: eventId,
      eventName: eventName,
      customerId: customerId,
      customerName: customerName,
      seatDetails: seatDetails,
      quantity: quantity,
      totalAmount: totalAmount,
      status: status,
      createdAt: createdAt,
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
