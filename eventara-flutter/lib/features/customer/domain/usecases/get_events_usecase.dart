import '../entities/event_entity.dart';
import '../repositories/event_repository.dart';

/// Fetches published events with optional category and keyword filters.
class GetEventsUseCase {
  final EventRepository _repository;

  GetEventsUseCase(this._repository);

  Future<List<EventEntity>> call({int? categoryId, String? keyword}) {
    return _repository.getPublishedEvents(
      categoryId: categoryId,
      keyword: keyword,
    );
  }
}
