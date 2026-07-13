/// Pure domain entities — no JSON, no annotations.

class BookingEntity {
  final int id;
  final String bookingReference;
  final int eventId;
  final String eventName;
  final int customerId;
  final String customerName;
  final String? seatDetails;
  final int quantity;
  final double totalAmount;
  final String status; // PENDING, CONFIRMED, CANCELLED
  final String createdAt;

  const BookingEntity({
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

  bool get isPending => status == 'PENDING';
  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCancelled => status == 'CANCELLED';
}

class TicketEntity {
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
  final String status; // VALID, USED, CANCELLED, EXPIRED
  final String issuedAt;
  final String? qrCodeBase64;

  const TicketEntity({
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

  bool get isValid => status == 'VALID';
  bool get isUsed => status == 'USED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isExpired => status == 'EXPIRED';
}
