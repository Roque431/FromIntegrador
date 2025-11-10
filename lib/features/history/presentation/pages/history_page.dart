import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/history_filter_chip.dart';
import '../../widgets/history_consultation_card.dart';
import '../../widgets/category_dropdown.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Total Consultas';
  String? _selectedCategory;

  // Datos de ejemplo - TODO: Reemplazar con datos reales de la API
  final List<Map<String, dynamic>> _consultations = List.generate(
    8,
    (index) => {
      'id': 'consulta_$index',
      'category': 'Laboral',
      'date': '21 de octubre de 2025',
      'question': '¿Qué pasa si me despiden y no me pagan mi liquidación?',
      'answer': 'LexIA: Según el artículo 50 de la ley federal...',
    },
  );

  List<Map<String, dynamic>> get _filteredConsultations {
    // TODO: Implementar filtrado real cuando tengas la API
    return _consultations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.secondary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Historial de Consultas',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Buscador y filtro de categorías
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Campo de búsqueda
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar consulta',
                        hintStyle: TextStyle(color: colors.tertiary.withValues(alpha: 0.4)),
                        prefixIcon: Icon(Icons.search, color: colors.tertiary.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // TODO: Implementar búsqueda
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Dropdown de categorías
                  CategoryDropdown(
                    selectedCategory: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Chips de filtros
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  HistoryFilterChip(
                    label: 'Total Consultas',
                    count: '8',
                    isSelected: _selectedFilter == 'Total Consultas',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Total Consultas';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  HistoryFilterChip(
                    label: 'Este Mes',
                    count: '3',
                    isSelected: _selectedFilter == 'Este Mes',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Este Mes';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  HistoryFilterChip(
                    label: 'Categorías',
                    count: '8',
                    isSelected: _selectedFilter == 'Categorías',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Categorías';
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de consultas
            Expanded(
              child: _filteredConsultations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_outlined,
                            size: 64,
                            color: colors.tertiary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay consultas',
                            style: TextStyle(
                              color: colors.tertiary.withValues(alpha: 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredConsultations.length,
                      itemBuilder: (context, index) {
                        final consultation = _filteredConsultations[index];
                        return HistoryConsultationCard(
                          category: consultation['category'],
                          date: consultation['date'],
                          question: consultation['question'],
                          answer: consultation['answer'],
                          consultationId: consultation['id'],
                          // onTap ya no es necesario, usa el del widget por defecto
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}