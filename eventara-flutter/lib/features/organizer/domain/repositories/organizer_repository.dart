import '../../data/models/organizer_event_model.dart';

abstract class OrganizerRepository {
  Future<OrganizerDashboardModel> getDashboard();
  Future<OrganizerProfileModel> getProfile();
  Future<OrganizerProfileModel> updateProfile(Map<String, dynamic> data);
  Future<List<OrganizerEventModel>> getMyEvents();
  Future<List<OrganizerEventModel>> getEventsByStatus(String status);
  Future<OrganizerEventModel> createEvent(Map<String, dynamic> data);
  Future<OrganizerEventModel> updateEvent(int id, Map<String, dynamic> data);
  Future<OrganizerEventModel> submitEvent(int id);
  Future<OrganizerEventModel> cancelEvent(int id);
  Future<OrganizerEventModel> saveSeatMap(int id, String seatMapJson);
  Future<OrganizerEventModel> saveZonePricing(int id, List<Map<String, dynamic>> zones);
  Future<List<CategoryModel>> getCategories();
}
