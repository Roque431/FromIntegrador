import 'package:flutter/material.dart';
import '../../data/models/legal_content_model.dart';

class SearchResultItem extends StatelessWidget {
  final LegalContentSearchResult result;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.result,
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
                      color: _getTypeColor(result.tipo),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      result.tipo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (result.score != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.stars, size: 12, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            '${(result.score! * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                result.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (result.snippet != null) ...[
                const SizedBox(height: 8),
                Text(
                  result.snippet!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (result.fuente != null || result.fechaPublicacion != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (result.fechaPublicacion != null) ...[
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${result.fechaPublicacion!.day}/${result.fechaPublicacion!.month}/${result.fechaPublicacion!.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (result.fuente != null) ...[
                      const Icon(Icons.source, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          result.fuente!,
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
