import '../models/profile_validation_model.dart';
import '../datasources/profile_validation_datasource.dart';

abstract class ProfileValidationRepository {
  Future<List<ProfileValidationModel>> getProfilesPendientes({ProfileType? tipo});
  Future<ProfileValidationModel> getProfileById(String profileId);
  Future<bool> aprobarPerfil(String profileId);
  Future<bool> rechazarPerfil(String profileId, String motivo);
  Future<List<DocumentModel>> getDocumentosPerfil(String profileId);
}

class ProfileValidationRepositoryImpl implements ProfileValidationRepository {
  final ProfileValidationDataSource dataSource;

  const ProfileValidationRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<ProfileValidationModel>> getProfilesPendientes({ProfileType? tipo}) async {
    try {
      return await dataSource.getProfilesPendientes(tipo: tipo);
    } catch (e) {
      throw Exception('Error al obtener perfiles pendientes: $e');
    }
  }

  @override
  Future<ProfileValidationModel> getProfileById(String profileId) async {
    try {
      return await dataSource.getProfileById(profileId);
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  @override
  Future<bool> aprobarPerfil(String profileId) async {
    try {
      return await dataSource.aprobarPerfil(profileId);
    } catch (e) {
      throw Exception('Error al aprobar perfil: $e');
    }
  }

  @override
  Future<bool> rechazarPerfil(String profileId, String motivo) async {
    try {
      if (motivo.trim().isEmpty) {
        throw Exception('El motivo de rechazo es requerido');
      }
      return await dataSource.rechazarPerfil(profileId, motivo);
    } catch (e) {
      throw Exception('Error al rechazar perfil: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentosPerfil(String profileId) async {
    try {
      return await dataSource.getDocumentosPerfil(profileId);
    } catch (e) {
      throw Exception('Error al obtener documentos: $e');
    }
  }
}