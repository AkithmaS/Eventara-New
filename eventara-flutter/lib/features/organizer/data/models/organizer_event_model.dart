import 'dart:convert';

// ── OrganizerEventModel ───────────────────────────────────────────────────────
class OrganizerEventModel {
  final int id;
  final String title;
  final String? description;
  final String? eventDate;
  final String? endDate;
  final String? venueName;
  final String? venueAddress;
  final String? city;
  final String ticketType;
  final String status;
  final double? generalAdmissionPrice;
  final int? maxCapacity;
  final int? organizerId;
  final int? categoryId;
  final String? categoryName;
  final String? bannerImageUrl;
  final String? seatMapJson;
  final String? rejectionNotes;
  final String? createdAt;
  final String? updatedAt;

  OrganizerEventModel({
    required this.id,
    required this.title,
    this.description,
    this.eventDate,
    this.endDate,
    this.venueName,
    this.venueAddress,
    this.city,
    required this.ticketType,
    required this.status,
    this.generalAdmissionPrice,
    this.maxCapacity,
    this.organizerId,
    this.categoryId,
    this.categoryName,
    this.bannerImageUrl,
    this.seatMapJson,
    this.rejectionNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizerEventModel.fromJson(Map<String, dynamic> json) {
    return OrganizerEventModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventDate: json['eventDate'] as String?,
      endDate: json['endDate'] as String?,
      venueName: json['venueName'] as String?,
      venueAddress: json['venueAddress'] as String?,
      city: json['city'] as String?,
      ticketType: json['ticketType'] as String? ?? 'GENERAL_ADMISSION',
      status: json['status'] as String? ?? 'DRAFT',
      generalAdmissionPrice: (json['generalAdmissionPrice'] as num?)?.toDouble(),
      maxCapacity: json['maxCapacity'] as int?,
      organizerId: json['organizerId'] as int?,
      categoryId: json['categoryId'] as int?,
      categoryName: json['categoryName'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      seatMapJson: json['seatMapJson'] as String?,
      rejectionNotes: json['rejectionNotes'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate,
      'endDate': endDate,
      'venueName': venueName,
      'venueAddress': venueAddress,
      'city': city,
      'ticketType': ticketType,
      'status': status,
      'generalAdmissionPrice': generalAdmissionPrice,
      'maxCapacity': maxCapacity,
      'organizerId': organizerId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'bannerImageUrl': bannerImageUrl,
      'seatMapJson': seatMapJson,
      'rejectionNotes': rejectionNotes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

// ── OrganizerBookingModel ────────────────────────────────────────────────────
class OrganizerBookingModel {
  final int id;
  final String? bookingReference;
  final int? eventId;
  final String? eventName;
  final int? customerId;
  final String? customerName;
  final String? seatDetails;
  final int? quantity;
  final double? totalAmount;
  final String? status;
  final String? createdAt;

  OrganizerBookingModel({
    required this.id,
    this.bookingReference,
    this.eventId,
    this.eventName,
    this.customerId,
    this.customerName,
    this.seatDetails,
    this.quantity,
    this.totalAmount,
    this.status,
    this.createdAt,
  });

  factory OrganizerBookingModel.fromJson(Map<String, dynamic> json) {
    return OrganizerBookingModel(
      id: json['id'] as int,
      bookingReference: json['bookingReference'] as String?,
      eventId: json['eventId'] as int?,
      eventName: json['eventName'] as String?,
      customerId: json['customerId'] as int?,
      customerName: json['customerName'] as String?,
      seatDetails: json['seatDetails'] as String?,
      quantity: json['quantity'] as int?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  /// Mask customer name: "John Smith" → "J*** S***"
  String get maskedCustomerName {
    if (customerName == null || customerName!.isEmpty) return 'Unknown';
    final parts = customerName!.split(' ');
    return parts.map((p) => p.isNotEmpty ? '${p[0]}***' : '').join(' ');
  }
}

// ── OrganizerDashboardModel ──────────────────────────────────────────────────
class OrganizerDashboardModel {
  final String? organizerName;
  final String? organizationName;
  final int totalEvents;
  final int publishedEvents;
  final int totalBookings;
  final double totalRevenue;
  final int pendingSubmissions;
  final List<OrganizerEventModel> recentEvents;
  final List<OrganizerBookingModel> recentBookings;

  OrganizerDashboardModel({
    this.organizerName,
    this.organizationName,
    required this.totalEvents,
    required this.publishedEvents,
    required this.totalBookings,
    required this.totalRevenue,
    required this.pendingSubmissions,
    required this.recentEvents,
    required this.recentBookings,
  });

  factory OrganizerDashboardModel.fromJson(Map<String, dynamic> json) {
    return OrganizerDashboardModel(
      organizerName: json['organizerName'] as String?,
      organizationName: json['organizationName'] as String?,
      totalEvents: json['totalEvents'] as int? ?? 0,
      publishedEvents: json['publishedEvents'] as int? ?? 0,
      totalBookings: json['totalBookings'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      pendingSubmissions: json['pendingSubmissions'] as int? ?? 0,
      recentEvents: (json['recentEvents'] as List<dynamic>? ?? [])
          .map((e) => OrganizerEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentBookings: (json['recentBookings'] as List<dynamic>? ?? [])
          .map((e) => OrganizerBookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── OrganizerProfileModel ────────────────────────────────────────────────────
class OrganizerProfileModel {
  final int id;
  final int? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? organizationName;
  final String? organizationType;
  final String? description;
  final String? websiteUrl;
  final String? status;

  OrganizerProfileModel({
    required this.id,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.organizationName,
    this.organizationType,
    this.description,
    this.websiteUrl,
    this.status,
  });

  factory OrganizerProfileModel.fromJson(Map<String, dynamic> json) {
    return OrganizerProfileModel(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      organizationName: json['organizationName'] as String?,
      organizationType: json['organizationType'] as String?,
      description: json['description'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      status: json['status'] as String?,
    );
  }
}

// ── CategoryModel ────────────────────────────────────────────────────────────
class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
