import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_notifier.dart';
import 'question_chip.dart';
import 'consultation_input.dart';

class HomeContent extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const HomeContent({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;
    final homeNotifier = context.watch<HomeNotifier>();

    return Column(
      children: [
        // Header con botón de menú
        Padding(
          padding: EdgeInsets.all(isWeb ? 20.0 : 16.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: isWeb ? 28 : 24,
                ),
                onPressed: onMenuPressed,
              ),
              const Spacer(),
              // Aquí podrías agregar más botones (ej: notificaciones)
            ],
          ),
        ),

        // Contenido central
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 48 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: isWeb ? 60 : 40),

                    // Logo
                    Image.asset(
                      'lib/img/portada.png',
                      width: isWeb ? 130 : 100,
                      height: isWeb ? 130 : 100,
                    ),
                    SizedBox(height: isWeb ? 24 : 16),

                    // Título
                    Text(
                      'LexIA',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: isWeb ? 36 : null,
                          ),
                    ),
                    SizedBox(height: isWeb ? 32 : 24),

                    // Subtítulo
                    Text(
                      'Sobre que necesitas ayuda?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: isWeb ? 28 : null,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isWeb ? 40 : 32),

                    // Preguntas sugeridas
                    Wrap(
                      spacing: isWeb ? 16 : 12,
                      runSpacing: isWeb ? 16 : 12,
                      alignment: WrapAlignment.center,
                      children: const [
                        QuestionChip(
                          question: 'Me despidieron y no me dieron mi liquidación.',
                        ),
                        QuestionChip(
                          question: '¿Cuántos días de vacaciones me corresponden por ley?',
                        ),
                        QuestionChip(
                          question: '¿Qué hago si sufro acoso laboral?',
                        ),
                        QuestionChip(
                          question: '¿Cuáles son los pasos para divorciarme?',
                        ),
                        QuestionChip(
                          question: '¿Qué debo hacer si me detienen sin motivo?',
                        ),
                      ],
                    ),
                    SizedBox(height: isWeb ? 40 : 24),

                    // Indicador de carga
                    if (homeNotifier.isLoading)
                      Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Procesando tu consulta...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),

                    // Respuesta de la consulta
                    if (homeNotifier.currentResponse != null &&
                        !homeNotifier.isLoading)
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: isWeb ? 40 : 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Respuesta de LexIA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              homeNotifier.currentResponse!,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    homeNotifier.clearSession();
                                  },
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Nueva consulta'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: isWeb ? 40 : 24),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Input de consulta
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 900 : double.infinity),
            child: const ConsultationInput(),
          ),
        ),
      ],
    );
  }
}
