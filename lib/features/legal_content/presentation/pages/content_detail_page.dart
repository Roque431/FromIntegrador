import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/legal_content_notifier.dart';

class ContentDetailPage extends StatefulWidget {
  final String contentId;

  const ContentDetailPage({
    super.key,
    required this.contentId,
  });

  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LegalContentNotifier>().loadContentById(int.tryParse(widget.contentId) ?? 0);
    });
  }

  @override
  void dispose() {
    context.read<LegalContentNotifier>().clearSelectedContent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Contenido'),
        elevation: 0,
      ),
      body: Consumer<LegalContentNotifier>(
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
                      notifier.loadContentById(int.tryParse(widget.contentId) ?? 0);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final content = notifier.selectedContent;
          if (content == null) {
            return const Center(
              child: Text('Contenido no encontrado'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo de contenido
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(content.tipo),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    content.tipo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Título
                Text(
                  content.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Metadata
                Row(
                  children: [
                    const Icon(Icons.numbers, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Versión ${content.version}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (content.fuente != null) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.source, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          content.fuente!,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Contenido
                const Text(
                  'Contenido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    content.textoOriginal,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Texto simplificado (si existe)
                if (content.textoSimplificado != null) ...[
                  const Text(
                    'Versión Simplificada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      content.textoSimplificado!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'ley':
        return Colors.blue;
      case 'reglamento':
        return Colors.orange;
      case 'jurisprudencia':
        return Colors.purple;
      case 'codigo':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
