import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../providers/home_notifier.dart';

class ConsultationInput extends StatefulWidget {
  const ConsultationInput({super.key});

  @override
  State<ConsultationInput> createState() => _ConsultationInputState();
}

class _ConsultationInputState extends State<ConsultationInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final message = _controller.text.trim();
    final homeNotifier = context.read<HomeNotifier>();

    // Limpiar el campo inmediatamente
    _controller.clear();

    // Enviar mensaje a la API
    final success = await homeNotifier.sendMessage(message);

    if (!mounted) return;

    if (!success) {
      // Mostrar error solo si falla
      LexiaAlert.error(
        context,
        title: 'Error al enviar consulta',
        message: homeNotifier.errorMessage ?? 'Inténtalo de nuevo',
      );
    }
    // No mostramos alerta de éxito porque la respuesta ya se muestra en el chat
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Pregúntale a LexIA',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? colorScheme.surface.withValues(alpha: 0.5)
                      : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _hasText ? _sendMessage : null,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _hasText 
                      ? colorScheme.primary 
                      : colorScheme.outline.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: _hasText 
                      ? colorScheme.onPrimary 
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}