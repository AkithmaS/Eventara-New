import '../../domain/entities/event_entity.dart';

/// JSON-serializable model matching the backend EventResponse.
class EventModel {
  final int id;
  final String title;
  final String description;
  final String eventDate;
  final String venueName;
  final String venueAddress;
  final String eventType;
  final String status;
  final double ticketPrice;
  final int totalCapacity;
  final int availableCapacity;
  final String categoryName;
  final String organizerName;
  final String? imageUrl;

  const EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      eventDate: json['eventDate'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      venueAddress: json['venueAddress'] as String? ?? '',
      eventType: json['ticketType'] as String? ?? 'GENERAL_ADMISSION',
      status: json['status'] as String? ?? '',
      // Backend sends "generalAdmissionPrice" for GA events;
      // fall back to "ticketPrice" for any future seated-price field.
      ticketPrice: _toDouble(json['generalAdmissionPrice'] ?? json['ticketPrice']),
      totalCapacity: json['maxCapacity'] as int? ?? json['totalCapacity'] as int? ?? 0,
      availableCapacity: json['availableCapacity'] as int? ?? json['maxCapacity'] as int? ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      organizerName: json['organizerName'] as String? ?? '',
      imageUrl: json['bannerImageUrl'] as String? ?? json['imageUrl'] as String?,
    );
  }

  EventEntity toEntity() {
    return EventEntity(
      id: id,
      title: title,
      description: description,
      eventDate: eventDate,
      venueName: venueName,
      venueAddress: venueAddress,
      eventType: eventType,
      status: status,
      ticketPrice: ticketPrice,
      totalCapacity: totalCapacity,
      availableCapacity: availableCapacity,
      categoryName: categoryName,
      organizerName: organizerName,
      imageUrl: imageUrl,
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
