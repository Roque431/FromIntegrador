import '../datasources/admin_datasource.dart';
import '../models/admin_stats_model.dart';

abstract class AdminRepository {
  Future<AdminStatsModel> getAdminStats();
  Future<List<Map<String, dynamic>>> getPendingProfiles();
  Future<List<Map<String, dynamic>>> getPendingReports();
  Future<bool> validateProfile(String profileId, bool approved);
  Future<bool> moderateContent(String contentId, String action);
}

class AdminRepositoryImpl implements AdminRepository {
  final AdminDataSource dataSource;

  AdminRepositoryImpl({required this.dataSource});

  @override
  Future<AdminStatsModel> getAdminStats() async {
    return await dataSource.getAdminStats();
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingProfiles() async {
    return await dataSource.getPendingProfiles();
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingReports() async {
    return await dataSource.getPendingReports();
  }

  @override
  Future<bool> validateProfile(String profileId, bool approved) async {
    return await dataSource.validateProfile(profileId, approved);
  }

  @override
  Future<bool> moderateContent(String contentId, String action) async {
    return await dataSource.moderateContent(contentId, action);
  }
}