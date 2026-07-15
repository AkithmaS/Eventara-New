import '../../domain/repositories/organizer_repository.dart';
import '../datasources/organizer_remote_datasource.dart';
import '../models/organizer_event_model.dart';

class OrganizerRepositoryImpl implements OrganizerRepository {
  final OrganizerRemoteDatasource _remote;

  OrganizerRepositoryImpl({OrganizerRemoteDatasource? remote})
      : _remote = remote ?? OrganizerRemoteDatasource();

  @override
  Future<OrganizerDashboardModel> getDashboard() => _remote.getDashboard();

  @override
  Future<OrganizerProfileModel> getProfile() => _remote.getProfile();

  @override
  Future<OrganizerProfileModel> updateProfile(Map<String, dynamic> data) =>
      _remote.updateProfile(data);

  @override
  Future<List<OrganizerEventModel>> getMyEvents() => _remote.getMyEvents();

  @override
  Future<List<OrganizerEventModel>> getEventsByStatus(String status) =>
      _remote.getEventsByStatus(status);

  @override
  Future<OrganizerEventModel> createEvent(Map<String, dynamic> data) =>
      _remote.createEvent(data);

  @override
  Future<OrganizerEventModel> updateEvent(int id, Map<String, dynamic> data) =>
      _remote.updateEvent(id, data);

  @override
  Future<OrganizerEventModel> submitEvent(int id) => _remote.submitEvent(id);

  @override
  Future<OrganizerEventModel> cancelEvent(int id) => _remote.cancelEvent(id);

  @override
  Future<OrganizerEventModel> saveSeatMap(int id, String seatMapJson) =>
      _remote.saveSeatMap(id, seatMapJson);

  @override
  Future<OrganizerEventModel> saveZonePricing(int id, List<Map<String, dynamic>> zones) =>
      _remote.saveZonePricing(id, zones);

  @override
  Future<List<CategoryModel>> getCategories() => _remote.getCategories();
}
