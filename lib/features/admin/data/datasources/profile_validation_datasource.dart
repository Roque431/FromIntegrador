import '../models/profile_validation_model.dart';

abstract class ProfileValidationDataSource {
  Future<List<ProfileValidationModel>> getProfilesPendientes({ProfileType? tipo});
  Future<ProfileValidationModel> getProfileById(String profileId);
  Future<bool> aprobarPerfil(String profileId);
  Future<bool> rechazarPerfil(String profileId, String motivo);
  Future<List<DocumentModel>> getDocumentosPerfil(String profileId);
}

class ProfileValidationDataSourceImpl implements ProfileValidationDataSource {
  
  @override
  Future<List<ProfileValidationModel>> getProfilesPendientes({ProfileType? tipo}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final todosLosPerfiles = [
      ProfileValidationModel(
        id: 'prof_001',
        nombre: 'Jorge',
        apellido: 'Martínez López',
        tipo: ProfileType.abogado,
        cedulaProfesional: '8756432',
        especialidad: 'Derecho Administrativo',
        anosExperiencia: 5,
        fechaSolicitud: DateTime.now().subtract(const Duration(days: 2)),
        status: ValidationStatus.pendiente,
        documentos: [
          DocumentModel(
            id: 'doc_001',
            tipo: DocumentType.cedula,
            nombre: 'Cedula.pdf',
            url: '/documents/cedula_001.pdf',
          ),
          DocumentModel(
            id: 'doc_002',
            tipo: DocumentType.ine,
            nombre: 'INE.pdf',
            url: '/documents/ine_001.pdf',
          ),
        ],
      ),
      ProfileValidationModel(
        id: 'prof_002',
        nombre: 'María Paula',
        apellido: 'Ruiz',
        tipo: ProfileType.abogado,
        cedulaProfesional: '9123456',
        especialidad: 'Derecho Civil y Familiar',
        anosExperiencia: 12,
        fechaSolicitud: DateTime.now().subtract(const Duration(hours: 4)),
        status: ValidationStatus.pendiente,
        documentos: [
          DocumentModel(
            id: 'doc_003',
            tipo: DocumentType.cedula,
            nombre: 'Cedula_Profesional.pdf',
            url: '/documents/cedula_002.pdf',
          ),
          DocumentModel(
            id: 'doc_004',
            tipo: DocumentType.ine,
            nombre: 'INE_Vigente.pdf',
            url: '/documents/ine_002.pdf',
          ),
        ],
      ),
      ProfileValidationModel(
        id: 'prof_003',
        nombre: 'Ana Sofía',
        apellido: 'Herrera',
        tipo: ProfileType.anunciante,
        cedulaProfesional: '5432109',
        especialidad: 'Derecho Corporativo',
        anosExperiencia: 15,
        fechaSolicitud: DateTime.now().subtract(const Duration(hours: 6)),
        status: ValidationStatus.pendiente,
        documentos: [
          DocumentModel(
            id: 'doc_008',
            tipo: DocumentType.cedula,
            nombre: 'Cedula_Representante.pdf',
            url: '/documents/cedula_004.pdf',
          ),
          DocumentModel(
            id: 'doc_009',
            tipo: DocumentType.certificacion,
            nombre: 'Certificacion_Bufete.pdf',
            url: '/documents/cert_004.pdf',
          ),
        ],
      ),
    ];

    if (tipo != null) {
      return todosLosPerfiles.where((perfil) => perfil.tipo == tipo).toList();
    }
    
    return todosLosPerfiles;
  }

  @override
  Future<ProfileValidationModel> getProfileById(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final perfiles = await getProfilesPendientes();
    return perfiles.firstWhere(
      (perfil) => perfil.id == profileId,
      orElse: () => throw Exception('Perfil no encontrado'),
    );
  }

  @override
  Future<bool> aprobarPerfil(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  @override
  Future<bool> rechazarPerfil(String profileId, String motivo) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (motivo.isEmpty) {
      throw Exception('El motivo de rechazo es requerido');
    }
    
    return true;
  }

  @override
  Future<List<DocumentModel>> getDocumentosPerfil(String profileId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final perfil = await getProfileById(profileId);
    return perfil.documentos;
  }
}