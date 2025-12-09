import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/models.dart';

class ForoRepository {
  final ApiClient _apiClient;

  ForoRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtener todas las categorÃ­as del foro
  Future<List<CategoriaModel>> getCategorias() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.foroCategorias);
      
      if (response['success'] == true && response['categorias'] != null) {
        final List<dynamic> data = response['categorias'];
        return data.map((json) => CategoriaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('âŒ Error obteniendo categorÃ­as: $e');
      rethrow;
    }
  }

  /// Obtener publicaciones del foro
  Future<List<PublicacionModel>> getPublicaciones({
    String? categoriaId,
    String? usuarioId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (categoriaId != null) queryParams['categoriaId'] = categoriaId;
      if (usuarioId != null) queryParams['usuarioId'] = usuarioId;

      final response = await _apiClient.get(
        ApiEndpoints.foroPublicaciones,
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['publicaciones'] != null) {
        final List<dynamic> data = response['publicaciones'];
        return data.map((json) => PublicacionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('âŒ Error obteniendo publicaciones: $e');
      rethrow;
    }
  }

  /// Obtener una publicaciÃ³n con sus comentarios
  Future<Map<String, dynamic>> getPublicacion(String publicacionId, {String? usuarioId}) async {
    try {
      final queryParams = <String, String>{};
      if (usuarioId != null) queryParams['usuarioId'] = usuarioId;

      final response = await _apiClient.get(
        ApiEndpoints.foroPublicacion(publicacionId),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response['success'] == true) {
        final publicacion = PublicacionModel.fromJson(response['publicacion']);
        final comentarios = (response['comentarios'] as List?)
            ?.map((json) => ComentarioModel.fromJson(json))
            .toList() ?? [];
        
        return {
          'publicacion': publicacion,
          'comentarios': comentarios,
        };
      }
      throw Exception('Error al obtener publicaciÃ³n');
    } catch (e) {
      print('âŒ Error obteniendo publicaciÃ³n: $e');
      rethrow;
    }
  }

  /// Crear nueva publicaciÃ³n
  Future<PublicacionModel> crearPublicacion({
    required String usuarioId,
    required String titulo,
    required String contenido,
    required String categoriaId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.foro}/publicacion',
        body: {
          'usuarioId': usuarioId,
          'titulo': titulo,
          'contenido': contenido,
          'categoriaId': categoriaId,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['publicacion'] != null) {
        return PublicacionModel.fromJson(response['publicacion']);
      }
      throw Exception('Error al crear publicaciÃ³n');
    } catch (e) {
      print('âŒ Error creando publicaciÃ³n: $e');
      rethrow;
    }
  }

  /// Agregar comentario a una publicaciÃ³n
  Future<ComentarioModel> crearComentario({
    required String publicacionId,
    required String usuarioId,
    required String contenido,
    String? parentId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.foroPublicacionComentario(publicacionId),
        body: {
          'usuarioId': usuarioId,
          'contenido': contenido,
          if (parentId != null) 'parentId': parentId,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['comentario'] != null) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(response['comentario']);

        // If server didn't include parentId but we sent one, keep it to avoid
        // treating replies as top-level comments in the client UI.
        if (parentId != null && (json['parentId'] == null || (json['parentId'] is String && (json['parentId'] as String).isEmpty))) {
          json['parentId'] = parentId;
        }

        return ComentarioModel.fromJson(json);
      }
      throw Exception('Error al crear comentario');
    } catch (e) {
      print('âŒ Error creando comentario: $e');
      rethrow;
    }
  }

  /// Toggle like en publicaciÃ³n
  Future<Map<String, dynamic>> toggleLike({
    required String publicacionId,
    required String usuarioId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.foroPublicacionLike(publicacionId),
        body: {
          'usuarioId': usuarioId,
        },
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return {
          'liked': response['liked'] ?? false,
          'totalLikes': response['totalLikes'] ?? 0,
        };
      }
      throw Exception('Error al dar like');
    } catch (e) {
      print('âŒ Error en toggle like: $e');
      rethrow;
    }
  }

  /// Toggle marcación "No útil" en una publicación (persistente en backend)
  Future<Map<String, dynamic>> toggleNoUtil({
    required String publicacionId,
    required String usuarioId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.foroPublicacionNoUtil(publicacionId),
        body: {
          'usuarioId': usuarioId,
        },
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return {
          'marked': response['marked'] ?? false,
          'totalNoUtil': response['totalNoUtil'] ?? 0,
        };
      }
      throw Exception('Error toggling no util');
    } catch (e) {
      print('⚠️ Error toggleNoUtil: $e');
      rethrow;
    }
  }

  /// Toggle like en un comentario (persistente en backend)
  Future<Map<String, dynamic>> toggleLikeComentario({
    required String comentarioId,
    required String usuarioId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.foroComentarioLike(comentarioId),
        body: {'usuarioId': usuarioId},
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return {
          'liked': response['liked'] ?? false,
          'totalLikes': response['totalLikes'] ?? 0,
        };
      }
      throw Exception('Error toggling comment like');
    } catch (e) {
      print('⚠️ Error toggleLikeComentario: $e');
      rethrow;
    }
  }

  /// Reportar utilidad de una publicaciÃ³n (Ãºtil / no Ãºtil)
  Future<bool> reportUtilidad({
    required String publicacionId,
    required String usuarioId,
    required bool utilidad,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.chat}/feedback',
        body: {
          'usuarioId': usuarioId,
          'tipo': 'foro_utilidad',
          'data': {
            'publicacionId': publicacionId,
            'utilidad': utilidad,
          }
        },
        requiresAuth: true,
      );

      return response['success'] == true;
    } catch (e) {
      print('âŒ Error reportando utilidad: $e');
      rethrow;
    }
  }

  /// Buscar publicaciones
  Future<List<PublicacionModel>> buscarPublicaciones({
    required String query,
    String? categoriaId,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'q': query,
        'limit': limit.toString(),
      };
      if (categoriaId != null) queryParams['categoriaId'] = categoriaId;

      final response = await _apiClient.get(
        ApiEndpoints.foroBuscar,
        queryParameters: queryParams,
      );

      if (response['success'] == true && response['publicaciones'] != null) {
        final List<dynamic> data = response['publicaciones'];
        return data.map((json) => PublicacionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('âŒ Error buscando publicaciones: $e');
      rethrow;
    }
  }

  /// Obtener mis publicaciones
  Future<List<PublicacionModel>> getMisPublicaciones(String usuarioId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.foroMisPublicaciones(usuarioId),
        requiresAuth: true,
      );

      if (response['success'] == true && response['publicaciones'] != null) {
        final List<dynamic> data = response['publicaciones'];
        return data.map((json) => PublicacionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('âŒ Error obteniendo mis publicaciones: $e');
      rethrow;
    }
  }

  /// Obtener miembros de una categoría
  Future<List<Map<String, dynamic>>> getCategoryMembers(String categoriaId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.foroCategoryMembers(categoriaId),
      );

      if (response['success'] == true && response['miembros'] != null) {
        final List<dynamic> data = response['miembros'];
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('âŒ Error obteniendo miembros de categoría: $e');
      rethrow;
    }
  }

  /// Compartir conversación completa al foro
  Future<PublicacionModel> compartirConversacion({
    required String usuarioId,
    required String sessionId,
    required String categoriaId,
    String? titulo,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.foro}/compartir-conversacion',
        body: {
          'usuarioId': usuarioId,
          'sessionId': sessionId,
          'categoriaId': categoriaId,
          if (titulo != null) 'titulo': titulo,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['publicacion'] != null) {
        return PublicacionModel.fromJson(response['publicacion']);
      }
      throw Exception('Error al compartir conversación');
    } catch (e) {
      print('❌ Error compartiendo conversación: $e');
      rethrow;
    }
  }
}
