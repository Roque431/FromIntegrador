import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/legal_content_model.dart';

class LegalContentDatasource {
  final ApiClient _apiClient;

  LegalContentDatasource(this._apiClient);

  /// Buscar contenido legal por query
  Future<List<LegalContentSearchResult>> searchContent({
    required String query,
    int? limit,
    String? tipo,
  }) async {
    var endpoint = '${ApiEndpoints.contentSearch}?q=${Uri.encodeComponent(query)}';
    
    if (limit != null) {
      endpoint += '&limit=$limit';
    }
    if (tipo != null) {
      endpoint += '&tipo=$tipo';
    }

    final data = await _apiClient.get(endpoint);

    // El backend puede devolver {results: [...], total: X} o directamente [...]
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      final List<dynamic> results = data['results'] as List<dynamic>;
      return results
          .map((json) => LegalContentSearchResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      final List<dynamic> results = data as List<dynamic>;
      return results
          .map((json) => LegalContentSearchResult.fromJson(json as Map<String, dynamic>))
          .toList();
    }
  }

  /// Obtener lista de contenido legal con paginación
  Future<LegalContentListResponse> getContentList({
    int page = 1,
    int perPage = 20,
    String? tipo,
  }) async {
    var endpoint = '${ApiEndpoints.contentList}?page=$page&per_page=$perPage';
    
    if (tipo != null) {
      endpoint += '&tipo=$tipo';
    }

    final data = await _apiClient.get(endpoint);

    return LegalContentListResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Obtener un documento legal específico por ID
  Future<LegalContentModel> getContentById(String contentId) async {
    final data = await _apiClient.get(
      ApiEndpoints.contentById(contentId),
    );

    return LegalContentModel.fromJson(data as Map<String, dynamic>);
  }
}
