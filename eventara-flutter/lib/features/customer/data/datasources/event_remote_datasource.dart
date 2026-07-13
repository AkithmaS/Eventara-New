import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/event_model.dart';

/// Fetches event data from the public backend endpoints.
class EventRemoteDatasource {
  final Dio _dio;

  EventRemoteDatasource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// GET /api/events — optionally filtered by categoryId and/or keyword.
  Future<List<EventModel>> getPublishedEvents({
    int? categoryId,
    String? keyword,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

    final response = await _dio.get(
      ApiEndpoints.events,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = _extractData(response.data);
    if (data is List) {
      return data
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// GET /api/events/{id}
  Future<EventModel> getEventById(int id) async {
    final response = await _dio.get(ApiEndpoints.eventById(id.toString()));
    final data = _extractData(response.data);
    return EventModel.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/events/categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _dio.get(ApiEndpoints.eventCategories);
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
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
