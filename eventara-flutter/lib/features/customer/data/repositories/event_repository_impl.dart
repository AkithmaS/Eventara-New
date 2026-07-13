import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';

/// Implements [EventRepository] by delegating to [EventRemoteDatasource].
class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource _remote;

  EventRepositoryImpl({EventRemoteDatasource? remote})
      : _remote = remote ?? EventRemoteDatasource();

  @override
  Future<List<EventEntity>> getPublishedEvents({
    int? categoryId,
    String? keyword,
  }) async {
    final models = await _remote.getPublishedEvents(
      categoryId: categoryId,
      keyword: keyword,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<EventEntity> getEventById(int id) async {
    final model = await _remote.getEventById(id);
    return model.toEntity();
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    return _remote.getCategories();
  }
}
