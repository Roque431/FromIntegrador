import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/admin_stats_model.dart';

abstract class AdminDataSource {
  Future<AdminStatsModel> getAdminStats();
  Future<List<Map<String, dynamic>>> getPendingProfiles();
  Future<List<Map<String, dynamic>>> getPendingReports();
  Future<bool> validateProfile(String profileId, bool approved);
  Future<bool> moderateContent(String contentId, String action);
}

class AdminDataSourceImpl implements AdminDataSource {
  final ApiClient apiClient;

  AdminDataSourceImpl({required this.apiClient});

  @override
  Future<AdminStatsModel> getAdminStats() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adminStats,
        requiresAuth: true,
      );
      
      return AdminStatsModel.fromJson(response);
    } catch (e) {
      // Si falla la API, retornar datos mock para que no se rompa la UI
      print('⚠️ Error al obtener estadísticas de admin: $e');
      return AdminStatsModel(
        usuariosActivos: 0,
        abogadosVerificados: 0,
        anunciantesActivos: 0,
        consultasDelMes: 0,
        crecimientoUsuarios: 0.0,
        crecimientoAbogados: 0.0,
        crecimientoAnunciantes: 0.0,
        crecimientoConsultas: 0.0,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingProfiles() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adminPendingProfiles,
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('⚠️ Error al obtener perfiles pendientes: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingReports() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adminPendingReports,
        requiresAuth: true,
      );
      
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      print('⚠️ Error al obtener reportes pendientes: $e');
      return [];
    }
  }

  @override
  Future<bool> validateProfile(String profileId, bool approved) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.adminValidateProfile,
        body: {
          'profile_id': profileId,
          'approved': approved,
        },
        requiresAuth: true,
      );
      return response['success'] ?? false;
    } catch (e) {
      print('⚠️ Error al validar perfil: $e');
      throw Exception('Error al validar perfil: $e');
    }
  }

  @override
  Future<bool> moderateContent(String contentId, String action) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.adminModerateContent,
        body: {
          'content_id': contentId,
          'action': action, // 'approve', 'reject', 'remove'
        },
        requiresAuth: true,
      );
      return response['success'] ?? false;
    } catch (e) {
      print('⚠️ Error al moderar contenido: $e');
      throw Exception('Error al moderar contenido: $e');
    }
  }
}