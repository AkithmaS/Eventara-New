import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/organizer_event_model.dart';
import '../../data/repositories/organizer_repository_impl.dart';
import '../../domain/repositories/organizer_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────────

final organizerRepositoryProvider = Provider<OrganizerRepository>((ref) {
  return OrganizerRepositoryImpl();
});

// ── States ────────────────────────────────────────────────────────────────────

sealed class OrganizerDashboardState {
  const OrganizerDashboardState();
}

class OrganizerDashboardInitial extends OrganizerDashboardState {
  const OrganizerDashboardInitial();
}

class OrganizerDashboardLoading extends OrganizerDashboardState {
  const OrganizerDashboardLoading();
}

class OrganizerDashboardLoaded extends OrganizerDashboardState {
  final OrganizerDashboardModel dashboard;
  const OrganizerDashboardLoaded(this.dashboard);
}

class OrganizerDashboardError extends OrganizerDashboardState {
  final String message;
  const OrganizerDashboardError(this.message);
}

// ────────────────────────────────────────────────────────────────────────────

sealed class OrganizerEventsState {
  const OrganizerEventsState();
}

class OrganizerEventsInitial extends OrganizerEventsState {
  const OrganizerEventsInitial();
}

class OrganizerEventsLoading extends OrganizerEventsState {
  const OrganizerEventsLoading();
}

class OrganizerEventsLoaded extends OrganizerEventsState {
  final List<OrganizerEventModel> events;
  const OrganizerEventsLoaded(this.events);
}

class OrganizerEventsError extends OrganizerEventsState {
  final String message;
  const OrganizerEventsError(this.message);
}

// ────────────────────────────────────────────────────────────────────────────

sealed class OrganizerProfileState {
  const OrganizerProfileState();
}

class OrganizerProfileInitial extends OrganizerProfileState {
  const OrganizerProfileInitial();
}

class OrganizerProfileLoading extends OrganizerProfileState {
  const OrganizerProfileLoading();
}

class OrganizerProfileLoaded extends OrganizerProfileState {
  final OrganizerProfileModel profile;
  const OrganizerProfileLoaded(this.profile);
}

class OrganizerProfileError extends OrganizerProfileState {
  final String message;
  const OrganizerProfileError(this.message);
}

// ── Notifiers ─────────────────────────────────────────────────────────────────

class OrganizerDashboardNotifier
    extends StateNotifier<OrganizerDashboardState> {
  final OrganizerRepository _repository;

  OrganizerDashboardNotifier(this._repository)
      : super(const OrganizerDashboardInitial());

  Future<void> loadDashboard() async {
    state = const OrganizerDashboardLoading();
    try {
      final dashboard = await _repository.getDashboard();
      state = OrganizerDashboardLoaded(dashboard);
    } catch (e) {
      state = OrganizerDashboardError(_message(e));
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────

class OrganizerEventsNotifier extends StateNotifier<OrganizerEventsState> {
  final OrganizerRepository _repository;

  OrganizerEventsNotifier(this._repository)
      : super(const OrganizerEventsInitial());

  Future<void> loadMyEvents() async {
    state = const OrganizerEventsLoading();
    try {
      final events = await _repository.getMyEvents();
      state = OrganizerEventsLoaded(events);
    } catch (e) {
      state = OrganizerEventsError(_message(e));
    }
  }

  Future<void> loadEventsByStatus(String status) async {
    state = const OrganizerEventsLoading();
    try {
      final events = await _repository.getEventsByStatus(status);
      state = OrganizerEventsLoaded(events);
    } catch (e) {
      state = OrganizerEventsError(_message(e));
    }
  }

  Future<bool> createEvent(Map<String, dynamic> data) async {
    try {
      await _repository.createEvent(data);
      await loadMyEvents();
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }

  Future<bool> updateEvent(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateEvent(id, data);
      await loadMyEvents();
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }

  Future<bool> submitEvent(int id) async {
    try {
      await _repository.submitEvent(id);
      await loadMyEvents();
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }

  Future<bool> cancelEvent(int id) async {
    try {
      await _repository.cancelEvent(id);
      await loadMyEvents();
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }

  Future<bool> saveSeatMap(int id, String seatMapJson) async {
    try {
      await _repository.saveSeatMap(id, seatMapJson);
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }

  Future<bool> saveZonePricing(int id, List<Map<String, dynamic>> zones) async {
    try {
      await _repository.saveZonePricing(id, zones);
      return true;
    } catch (e) {
      state = OrganizerEventsError(_message(e));
      return false;
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────

class OrganizerProfileNotifier extends StateNotifier<OrganizerProfileState> {
  final OrganizerRepository _repository;

  OrganizerProfileNotifier(this._repository)
      : super(const OrganizerProfileInitial());

  Future<void> loadProfile() async {
    state = const OrganizerProfileLoading();
    try {
      final profile = await _repository.getProfile();
      state = OrganizerProfileLoaded(profile);
    } catch (e) {
      state = OrganizerProfileError(_message(e));
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final profile = await _repository.updateProfile(data);
      state = OrganizerProfileLoaded(profile);
      return true;
    } catch (e) {
      state = OrganizerProfileError(_message(e));
      return false;
    }
  }
}

// ── Provider instances ────────────────────────────────────────────────────────

final organizerDashboardProvider =
    StateNotifierProvider<OrganizerDashboardNotifier, OrganizerDashboardState>(
  (ref) => OrganizerDashboardNotifier(ref.watch(organizerRepositoryProvider)),
);

final organizerEventsProvider =
    StateNotifierProvider<OrganizerEventsNotifier, OrganizerEventsState>(
  (ref) => OrganizerEventsNotifier(ref.watch(organizerRepositoryProvider)),
);

final organizerProfileProvider =
    StateNotifierProvider<OrganizerProfileNotifier, OrganizerProfileState>(
  (ref) => OrganizerProfileNotifier(ref.watch(organizerRepositoryProvider)),
);

// ── Categories provider (simple FutureProvider) ───────────────────────────────

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getCategories();
});

// ── Helpers ───────────────────────────────────────────────────────────────────

String _message(Object e) {
  final s = e.toString();
  // Try to extract message from DioException
  if (s.contains('"message"')) {
    final match = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(s);
    if (match != null) return match.group(1)!;
  }
  return s.replaceAll('Exception: ', '');
}
