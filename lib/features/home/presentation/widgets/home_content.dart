import 'package:flutter/material.dart';
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
                    SizedBox(height: isWeb ? 60 : 40),
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
