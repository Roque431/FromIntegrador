import '../../data/models/profile_validation_model.dart';
import '../../data/repositories/profile_validation_repository_impl.dart';

abstract class ProfileValidationRepository {
  Future<List<ProfileValidationModel>> getProfilesPendientes({ProfileType? tipo});
  Future<ProfileValidationModel> getProfileById(String profileId);
  Future<bool> aprobarPerfil(String profileId);
  Future<bool> rechazarPerfil(String profileId, String motivo);
  Future<List<DocumentModel>> getDocumentosPerfil(String profileId);
}

class GetProfilesPendientesUseCase {
  final ProfileValidationRepository repository;

  const GetProfilesPendientesUseCase({
    required this.repository,
  });

  Future<List<ProfileValidationModel>> execute({ProfileType? tipo}) async {
    return await repository.getProfilesPendientes(tipo: tipo);
  }
}

class GetProfileByIdUseCase {
  final ProfileValidationRepository repository;

  const GetProfileByIdUseCase({
    required this.repository,
  });

  Future<ProfileValidationModel> execute(String profileId) async {
    if (profileId.isEmpty) {
      throw Exception('ID de perfil requerido');
    }
    return await repository.getProfileById(profileId);
  }
}

class AprobarPerfilUseCase {
  final ProfileValidationRepository repository;

  const AprobarPerfilUseCase({
    required this.repository,
  });

  Future<bool> execute(String profileId) async {
    if (profileId.isEmpty) {
      throw Exception('ID de perfil requerido');
    }
    return await repository.aprobarPerfil(profileId);
  }
}

class RechazarPerfilUseCase {
  final ProfileValidationRepository repository;

  const RechazarPerfilUseCase({
    required this.repository,
  });

  Future<bool> execute(String profileId, String motivo) async {
    if (profileId.isEmpty) {
      throw Exception('ID de perfil requerido');
    }
    if (motivo.trim().isEmpty) {
      throw Exception('Motivo de rechazo requerido');
    }
    if (motivo.trim().length < 10) {
      throw Exception('El motivo debe tener al menos 10 caracteres');
    }
    return await repository.rechazarPerfil(profileId, motivo);
  }
}

class GetDocumentosPerfilUseCase {
  final ProfileValidationRepository repository;

  const GetDocumentosPerfilUseCase({
    required this.repository,
  });

  Future<List<DocumentModel>> execute(String profileId) async {
    if (profileId.isEmpty) {
      throw Exception('ID de perfil requerido');
    }
    return await repository.getDocumentosPerfil(profileId);
  }
}

class ValidateAllDocumentsUseCase {
  final ProfileValidationRepository repository;

  const ValidateAllDocumentsUseCase({
    required this.repository,
  });

  Future<Map<String, bool>> execute(String profileId) async {
    final documentos = await repository.getDocumentosPerfil(profileId);
    
    Map<String, bool> validationResults = {};
    
    for (final documento in documentos) {
      // Validar que el documento tenga los datos requeridos
      bool isValid = documento.nombre.isNotEmpty && 
                     documento.url.isNotEmpty && 
                     documento.nombre.toLowerCase().endsWith('.pdf');
      
      validationResults[documento.id] = isValid;
    }
    
    return validationResults;
  }
}

class GetProfileStatsUseCase {
  final ProfileValidationRepository repository;

  const GetProfileStatsUseCase({
    required this.repository,
  });

  Future<ProfileValidationStats> execute() async {
    final todosLosPerfiles = await repository.getProfilesPendientes();
    final abogados = todosLosPerfiles.where((p) => p.tipo == ProfileType.abogado).toList();
    final anunciantes = todosLosPerfiles.where((p) => p.tipo == ProfileType.anunciante).toList();
    
    return ProfileValidationStats(
      totalPendientes: todosLosPerfiles.length,
      abogadosPendientes: abogados.length,
      anunciantesPendientes: anunciantes.length,
      perfilesMasAntiguos: _getPerfilesMasAntiguos(todosLosPerfiles),
    );
  }

  List<ProfileValidationModel> _getPerfilesMasAntiguos(List<ProfileValidationModel> perfiles) {
    final perfilesOrdenados = List<ProfileValidationModel>.from(perfiles);
    perfilesOrdenados.sort((a, b) => a.fechaSolicitud.compareTo(b.fechaSolicitud));
    return perfilesOrdenados.take(3).toList();
  }
}

class ProfileValidationStats {
  final int totalPendientes;
  final int abogadosPendientes;
  final int anunciantesPendientes;
  final List<ProfileValidationModel> perfilesMasAntiguos;

  const ProfileValidationStats({
    required this.totalPendientes,
    required this.abogadosPendientes,
    required this.anunciantesPendientes,
    required this.perfilesMasAntiguos,
  });
}