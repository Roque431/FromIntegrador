import '../../data/repositories/admin_repository_impl.dart';
import '../../data/models/admin_stats_model.dart';

class GetAdminStatsUseCase {
  final AdminRepository repository;

  GetAdminStatsUseCase({required this.repository});

  Future<AdminStatsModel> call() async {
    return await repository.getAdminStats();
  }
}

class ValidateProfileUseCase {
  final AdminRepository repository;

  ValidateProfileUseCase({required this.repository});

  Future<bool> call(String profileId, bool approved) async {
    return await repository.validateProfile(profileId, approved);
  }
}

class ModerateContentUseCase {
  final AdminRepository repository;

  ModerateContentUseCase({required this.repository});

  Future<bool> call(String contentId, String action) async {
    return await repository.moderateContent(contentId, action);
  }
}

class GetPendingItemsUseCase {
  final AdminRepository repository;

  GetPendingItemsUseCase({required this.repository});

  Future<({List<Map<String, dynamic>> profiles, List<Map<String, dynamic>> reports})> call() async {
    final profiles = await repository.getPendingProfiles();
    final reports = await repository.getPendingReports();
    
    return (profiles: profiles, reports: reports);
  }
}