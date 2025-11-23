import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../providers/home_notifier.dart';
import 'question_chip.dart';
import 'consultation_input.dart';

class HomeContent extends StatefulWidget {
  final VoidCallback onMenuPressed;

  const HomeContent({
    super.key,
    required this.onMenuPressed,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;
    final homeNotifier = context.watch<HomeNotifier>();
    
    // Scroll al fondo cuando hay nuevos mensajes
    if (homeNotifier.consultations.isNotEmpty) {
      _scrollToBottom();
    }

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
                onPressed: widget.onMenuPressed,
              ),
              const Spacer(),
              if (homeNotifier.consultations.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    homeNotifier.clearSession();
                  },
                  tooltip: 'Nueva conversación',
                ),
            ],
          ),
        ),

        // Contenido central
        Expanded(
          child: homeNotifier.consultations.isEmpty
              ? _buildInitialView(context, isWeb)
              : _buildChatView(context, homeNotifier, isWeb),
        ),

        // Alerta de límite de consultas alcanzado
        if (homeNotifier.isQuotaExceeded)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, 
                         color: Colors.orange.shade700, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '⚠️ Límite de Consultas Alcanzado',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  homeNotifier.errorMessage ?? 
                  'Has alcanzado el límite de consultas mensuales del plan Free.',
                  style: TextStyle(color: Colors.orange.shade900),
                ),
                if (homeNotifier.quotaLimitInfo != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Uso: ${homeNotifier.quotaLimitInfo!['usage']} / ${homeNotifier.quotaLimitInfo!['limit']} consultas',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navegar a página de pricing/upgrade
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upgrade a plan Pro próximamente disponible'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upgrade),
                  label: const Text('Actualizar a Plan Pro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

        // Error message
        if (homeNotifier.hasError && !homeNotifier.isQuotaExceeded)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    homeNotifier.errorMessage ?? 'Error al enviar mensaje',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
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

  Widget _buildInitialView(BuildContext context, bool isWeb) {
    return Center(
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
                '¿Sobre qué necesitas ayuda?',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatView(BuildContext context, HomeNotifier notifier, bool isWeb) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isWeb ? 900 : double.infinity),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 48 : 16,
          vertical: 16,
        ),
        itemCount: notifier.consultations.length + (notifier.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (notifier.isLoading && index == notifier.consultations.length) {
            return _buildLoadingMessage(context);
          }

          // Mostrar en orden cronológico: más antiguo primero, más reciente al final
          final consultation = notifier.consultations[index];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mensaje del usuario
              _buildUserMessage(context, consultation.query),
              const SizedBox(height: 12),
              
              // Respuesta de LexIA
              _buildAIMessage(context, consultation.response),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Color más contrastante y legible para el usuario
          color: Colors.indigo.shade600,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade600,
              Colors.indigo.shade500,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.35),
        ),
      ),
    );
  }

  Widget _buildAIMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Distinto color para la IA para diferenciar visualmente
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Respuesta de LexIA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 14, height: 1.6),
                h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                strong: const TextStyle(fontWeight: FontWeight.bold),
                listBullet: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMessage(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Analizando tu consulta...',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
