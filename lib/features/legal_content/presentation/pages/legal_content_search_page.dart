import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/legal_content_notifier.dart';
import '../widgets/content_search_bar.dart';
import '../widgets/content_list_item.dart';
import '../widgets/search_result_item.dart';
import '../widgets/content_type_filter.dart';
import 'content_detail_page.dart';

class LegalContentSearchPage extends StatefulWidget {
  const LegalContentSearchPage({super.key});

  @override
  State<LegalContentSearchPage> createState() => _LegalContentSearchPageState();
}

class _LegalContentSearchPageState extends State<LegalContentSearchPage> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    // Cargar contenido inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LegalContentNotifier>().loadAllContent(perPage: 20);
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<LegalContentNotifier>().clearSearch();
      context.read<LegalContentNotifier>().loadAllContent(
            perPage: 20,
            tipo: _selectedType,
          );
    } else {
      context.read<LegalContentNotifier>().searchContent(
            query: query,
            tipo: _selectedType,
            limit: 20,
          );
    }
  }

  void _onTypeFilterChanged(String? tipo) {
    setState(() {
      _selectedType = tipo;
    });
    
    context.read<LegalContentNotifier>().loadAllContent(
          perPage: 20,
          tipo: tipo,
        );
  }

  void _onContentTap(String contentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailPage(contentId: contentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido Legal'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          ContentSearchBar(onSearch: _onSearch),
          
          // Filtro por tipo
          ContentTypeFilter(
            selectedType: _selectedType,
            onTypeChanged: _onTypeFilterChanged,
          ),
          
          // Lista de resultados
          Expanded(
            child: Consumer<LegalContentNotifier>(
              builder: (context, notifier, child) {
                if (notifier.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (notifier.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          notifier.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            notifier.clearError();
                            notifier.loadAllContent(perPage: 20);
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (notifier.searchResults.isEmpty && notifier.allContent.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No se encontró contenido',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                // Mostrar resultados de búsqueda o lista completa
                if (notifier.searchResults.isNotEmpty) {
                  // Mostrar resultados de búsqueda con scores
                  return ListView.builder(
                    itemCount: notifier.searchResults.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final result = notifier.searchResults[index];
                      return SearchResultItem(
                        result: result,
                        onTap: () => _onContentTap(result.id),
                      );
                    },
                  );
                }

                // Mostrar lista completa
                return ListView.builder(
                  itemCount: notifier.allContent.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final content = notifier.allContent[index];
                    return ContentListItem(
                      content: content,
                      onTap: () => _onContentTap(content.id),
                    );
                  },
                );
              },
            ),
          ),
          
          // Paginación
          Consumer<LegalContentNotifier>(
            builder: (context, notifier, child) {
              if (notifier.totalPages <= 1) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: notifier.currentPage > 1
                          ? () => notifier.previousPage()
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      'Página ${notifier.currentPage} de ${notifier.totalPages}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      onPressed: notifier.currentPage < notifier.totalPages
                          ? () => notifier.nextPage()
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
