import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/models.dart';

class ForoRepository {
  final ApiClient _apiClient;

  ForoRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtener todas las categorías del foro
  Future<List<CategoriaModel>> getCategorias() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.foroCategorias);
      
      if (response['success'] == true && response['categorias'] != null) {
        final List<dynamic> data = response['categorias'];
        return data.map((json) => CategoriaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo categorías: $e');
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
      print('❌ Error obteniendo publicaciones: $e');
      rethrow;
    }
  }

  /// Obtener una publicación con sus comentarios
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
      throw Exception('Error al obtener publicación');
    } catch (e) {
      print('❌ Error obteniendo publicación: $e');
      rethrow;
    }
  }

  /// Crear nueva publicación
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
      throw Exception('Error al crear publicación');
    } catch (e) {
      print('❌ Error creando publicación: $e');
      rethrow;
    }
  }

  /// Agregar comentario a una publicación
  Future<ComentarioModel> crearComentario({
    required String publicacionId,
    required String usuarioId,
    required String contenido,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.foroPublicacionComentario(publicacionId),
        body: {
          'usuarioId': usuarioId,
          'contenido': contenido,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['comentario'] != null) {
        return ComentarioModel.fromJson(response['comentario']);
      }
      throw Exception('Error al crear comentario');
    } catch (e) {
      print('❌ Error creando comentario: $e');
      rethrow;
    }
  }

  /// Toggle like en publicación
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
      print('❌ Error en toggle like: $e');
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
      print('❌ Error buscando publicaciones: $e');
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
      print('❌ Error obteniendo mis publicaciones: $e');
      rethrow;
    }
  }
}
