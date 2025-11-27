import 'package:flutter/material.dart';
import '../../data/models/legal_content_model.dart';

class ContentListItem extends StatelessWidget {
  final LegalContentModel content;
  final VoidCallback onTap;

  const ContentListItem({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(content.tipo),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      content.tipo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                content.textoOriginal,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (content.fuente != null) ...[
                 const SizedBox(height: 12),
                Row(
                  children: [
                    ...[
                    const Icon(Icons.numbers, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'v${content.version}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                    if (content.fuente != null) ...[
                      const Icon(Icons.source, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          content.fuente!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
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
