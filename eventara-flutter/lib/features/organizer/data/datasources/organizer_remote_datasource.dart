import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/organizer_event_model.dart';

/// Remote datasource for all Organizer API calls.
/// Uses DioClient.instance.dio — AuthInterceptor is already attached.
class OrganizerRemoteDatasource {
  final Dio _dio;

  OrganizerRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  // ── Helper ────────────────────────────────────────────────────────────────

  dynamic _extract(dynamic responseData) {
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  // ── Dashboard ─────────────────────────────────────────────────────────────

  Future<OrganizerDashboardModel> getDashboard() async {
    final response = await _dio.get(ApiEndpoints.organizerDashboard);
    final data = _extract(response.data);
    return OrganizerDashboardModel.fromJson(data as Map<String, dynamic>);
  }

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<OrganizerProfileModel> getProfile() async {
    final response = await _dio.get(ApiEndpoints.organizerProfile);
    final data = _extract(response.data);
    return OrganizerProfileModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerProfileModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _dio.put(ApiEndpoints.organizerProfile, data: body);
    final data = _extract(response.data);
    return OrganizerProfileModel.fromJson(data as Map<String, dynamic>);
  }

  // ── Events ────────────────────────────────────────────────────────────────

  Future<List<OrganizerEventModel>> getMyEvents() async {
    final response = await _dio.get(ApiEndpoints.organizerEvents);
    final data = _extract(response.data);
    if (data is List) {
      return data.map((e) => OrganizerEventModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<OrganizerEventModel>> getEventsByStatus(String status) async {
    final response = await _dio.get(
      ApiEndpoints.organizerEventsByStatus,
      queryParameters: {'status': status},
    );
    final data = _extract(response.data);
    if (data is List) {
      return data.map((e) => OrganizerEventModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<OrganizerEventModel> createEvent(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.organizerCreateEvent, data: body);
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerEventModel> updateEvent(int id, Map<String, dynamic> body) async {
    final response = await _dio.put(ApiEndpoints.organizerUpdateEvent(id.toString()), data: body);
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerEventModel> submitEvent(int id) async {
    final response = await _dio.post(ApiEndpoints.organizerSubmitEvent(id.toString()));
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerEventModel> cancelEvent(int id) async {
    final response = await _dio.post(ApiEndpoints.organizerCancelEvent(id.toString()));
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerEventModel> saveSeatMap(int id, String seatMapJson) async {
    final response = await _dio.post(
      ApiEndpoints.organizerSeatMap(id.toString()),
      data: {'seatMapJson': seatMapJson},
    );
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OrganizerEventModel> saveZonePricing(int id, List<Map<String, dynamic>> zones) async {
    final response = await _dio.post(
      ApiEndpoints.organizerPricingZones(id.toString()),
      data: zones,
    );
    final data = _extract(response.data);
    return OrganizerEventModel.fromJson(data as Map<String, dynamic>);
  }

  // ── Categories (public) ───────────────────────────────────────────────────

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get(ApiEndpoints.eventCategories);
    final data = _extract(response.data);
    if (data is List) {
      return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
