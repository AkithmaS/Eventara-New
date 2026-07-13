import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/usecases/get_events_usecase.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class EventsState {
  const EventsState();
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  final List<EventEntity> events;
  final List<Map<String, dynamic>> categories;

  const EventsLoaded({required this.events, required this.categories});
}

class EventsError extends EventsState {
  final String message;
  const EventsError(this.message);
}

// ── Providers ─────────────────────────────────────────────────────────────────

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl();
});

final eventsNotifierProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventsNotifier(repository);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

class EventsNotifier extends StateNotifier<EventsState> {
  final EventRepository _repository;
  final GetEventsUseCase _getEvents;

  List<Map<String, dynamic>> _cachedCategories = [];

  EventsNotifier(this._repository)
      : _getEvents = GetEventsUseCase(_repository),
        super(const EventsInitial());

  Future<void> loadEvents({int? categoryId, String? keyword}) async {
    state = const EventsLoading();
    try {
      final events = await _getEvents(categoryId: categoryId, keyword: keyword);
      state = EventsLoaded(events: events, categories: _cachedCategories);
    } catch (e) {
      state = EventsError(_errorMessage(e));
    }
  }

  Future<void> loadCategories() async {
    try {
      _cachedCategories = await _repository.getCategories();
      // If events are already loaded, update them with fresh categories.
      final current = state;
      if (current is EventsLoaded) {
        state = EventsLoaded(
          events: current.events,
          categories: _cachedCategories,
        );
      }
    } catch (_) {
      // Categories failing silently is acceptable — fall back to hardcoded list.
    }
  }

  /// Load both events and categories in one shot.
  Future<void> init() async {
    state = const EventsLoading();
    try {
      final results = await Future.wait([
        _getEvents(),
        _repository.getCategories(),
      ]);
      _cachedCategories = results[1] as List<Map<String, dynamic>>;
      state = EventsLoaded(
        events: results[0] as List<EventEntity>,
        categories: _cachedCategories,
      );
    } catch (e) {
      state = EventsError(_errorMessage(e));
    }
  }

  String _errorMessage(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}
