/// Pure domain entity — no JSON, no annotations.
class EventEntity {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String venueName;
  final String venueAddress;
  final String eventType; // "SEATED" or "GENERAL_ADMISSION"
  final String status;
  final double ticketPrice;
  final int totalCapacity;
  final int availableCapacity;
  final String categoryName;
  final String organizerName;
  final String? imageUrl;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.venueName,
    required this.venueAddress,
    required this.eventType,
    required this.status,
    required this.ticketPrice,
    required this.totalCapacity,
    required this.availableCapacity,
    required this.categoryName,
    required this.organizerName,
    this.imageUrl,
  });

  bool get isSeated => eventType == 'SEATED';
  bool get isGeneralAdmission => eventType == 'GENERAL_ADMISSION';
}
