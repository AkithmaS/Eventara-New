import '../entities/event_entity.dart';

/// Abstract contract for event data access.
abstract class EventRepository {
  Future<List<EventEntity>> getPublishedEvents({int? categoryId, String? keyword});
  Future<EventEntity> getEventById(int id);
  Future<List<Map<String, dynamic>>> getCategories();
}
