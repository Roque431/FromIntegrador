import '../../data/models/admin_stats_model.dart';

abstract class AdminRepository {
  Future<AdminStatsModel> getAdminStats();
  Future<List<String>> getPendingProfiles();
  Future<List<String>> getPendingReports();
  Future<bool> validateProfile(String profileId);
  Future<bool> moderateContent(String contentId, String action);
}