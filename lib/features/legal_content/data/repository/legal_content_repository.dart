import '../datasource/legal_content_datasource.dart';
import '../models/legal_content_model.dart';

class LegalContentRepository {
  final LegalContentDatasource _datasource;

  LegalContentRepository(this._datasource);

  Future<List<LegalContentSearchResult>> searchContent({
    required String query,
    int? limit,
    String? tipo,
  }) async {
    try {
      return await _datasource.searchContent(
        query: query,
        limit: limit,
        tipo: tipo,
      );
    } catch (e) {
      throw Exception('Error al buscar contenido: $e');
    }
  }

  Future<LegalContentListResponse> getContentList({
    int page = 1,
    int perPage = 20,
    String? tipo,
  }) async {
    try {
      return await _datasource.getContentList(
        page: page,
        perPage: perPage,
        tipo: tipo,
      );
    } catch (e) {
      throw Exception('Error al listar contenido: $e');
    }
  }

  Future<LegalContentModel> getContentById(String contentId) async {
    try {
      return await _datasource.getContentById(contentId);
    } catch (e) {
      throw Exception('Error al obtener contenido: $e');
    }
  }
}
