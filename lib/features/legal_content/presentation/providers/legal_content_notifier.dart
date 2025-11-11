import 'package:flutter/foundation.dart';
import '../../data/models/legal_content_model.dart';
import '../../data/repository/legal_content_repository.dart';

class LegalContentNotifier extends ChangeNotifier {
  final LegalContentRepository repository;

  LegalContentNotifier({required this.repository});

  bool _isLoading = false;
  String? _error;
  List<LegalContentSearchResult> _searchResults = [];
  LegalContentModel? _selectedContent;
  List<LegalContentModel> _allContent = [];
  int _currentPage = 1;
  int _totalPages = 1;
  final int _itemsPerPage = 20;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<LegalContentSearchResult> get searchResults => _searchResults;
  LegalContentModel? get selectedContent => _selectedContent;
  List<LegalContentModel> get allContent => _allContent;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> searchContent({
    String? query,
    String? tipo,
    int? limit,
  }) async {
    if (query == null || query.isEmpty) {
      clearSearch();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await repository.searchContent(
        query: query,
        tipo: tipo,
        limit: limit,
      );
      _currentPage = 1;
      _totalPages = 1; // Search doesn't paginate
    } catch (e) {
      _error = 'Error al buscar contenido: ${e.toString()}';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllContent({
    int? page,
    int? perPage,
    String? tipo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repository.getContentList(
        page: page ?? 1,
        perPage: perPage ?? _itemsPerPage,
        tipo: tipo,
      );
      
      _allContent = result.items;
      _currentPage = result.page;
      _totalPages = result.totalPages;
    } catch (e) {
      _error = 'Error al cargar contenido: ${e.toString()}';
      _allContent = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadContentById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedContent = await repository.getContentById(id.toString());
    } catch (e) {
      _error = 'Error al cargar contenido: ${e.toString()}';
      _selectedContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _error = null;
    notifyListeners();
  }

  void clearSelectedContent() {
    _selectedContent = null;
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (_currentPage < _totalPages) {
      await loadAllContent(
        page: _currentPage + 1,
        perPage: _itemsPerPage,
      );
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await loadAllContent(
        page: _currentPage - 1,
        perPage: _itemsPerPage,
      );
    }
  }
}
