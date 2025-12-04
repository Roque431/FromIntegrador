import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/home_notifier.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../../chat/presentation/providers/chat_privado_notifier.dart';
import '../../domain/entities/consultation.dart';
import '../../data/models/profesionista_model.dart';
import '../../data/models/anunciante_model.dart';
import 'question_chip.dart';
import 'consultation_input.dart';
import 'profesionista_card.dart';
import 'anunciante_card.dart';
import 'sugerencias_widget.dart';

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
                  color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: isWeb ? 36 : null,
                    ),
              ),
              SizedBox(height: isWeb ? 32 : 24),

              // Subtítulo
              Text(
                '¿Sobre qué necesitas ayuda?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
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
              
              // Respuesta de LexIA (con cards interactivas)
              _buildAIMessageWithCards(context, consultation, notifier),
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

  Widget _buildAIMessageWithCards(
    BuildContext context, 
    Consultation consultation, 
    HomeNotifier notifier,
  ) {
    final theme = Theme.of(context);
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.90,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Respuesta de LexIA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (consultation.cluster != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      consultation.cluster!,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            
            // Texto de respuesta en Markdown
            MarkdownBody(
              data: consultation.response,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 14, height: 1.6),
                h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                strong: const TextStyle(fontWeight: FontWeight.bold),
                listBullet: const TextStyle(fontSize: 14),
              ),
            ),
            
            // Cards de Profesionistas (si hay)
            if (consultation.tieneProfesionistas) ...[
              const Divider(height: 32),
              ProfesionistasListView(
                profesionistas: consultation.profesionistas,
                titulo: '👨‍⚖️ Profesionistas recomendados',
                onVerPerfil: (p) {
                  _showProfesionistaProfile(context, p);
                },
                onMatch: (p) {
                  _handleMatchProfesionista(context, p);
                },
                onRechazar: (p) {
                  // Simplemente no hacer nada o mostrar feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Entendido, no te mostraremos a ${p.nombre}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            
            // Cards de Anunciantes/Servicios (si hay)
            if (consultation.tieneAnunciantes) ...[
              const Divider(height: 32),
              AnunciantesListView(
                anunciantes: consultation.anunciantes,
                titulo: '🚛 Servicios cercanos',
                onVerDetalles: (a) {
                  _showAnuncianteDetails(context, a);
                },
                onRechazar: (a) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Entendido, no te mostraremos ${a.nombreComercial}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            
            // Sugerencias de preguntas (si hay)
            if (consultation.tieneSugerencias)
              SugerenciasChips(
                sugerencias: consultation.sugerencias,
                onSugerenciaTap: (sugerencia) {
                  notifier.sendMessage(sugerencia);
                },
              ),
            
            // Invitación al foro (si aplica)
            if (consultation.ofrecerForo)
              ForoInvitationBanner(
                onIrAlForo: () {
                  context.push('/forum');
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showProfesionistaProfile(BuildContext context, ProfesionistaModel profesionista) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar grande
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: profesionista.fotoProfesional != null
                          ? NetworkImage(profesionista.fotoProfesional!)
                          : null,
                      child: profesionista.fotoProfesional == null
                          ? Text(
                              profesionista.iniciales,
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Nombre y verificación
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profesionista.nombre,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (profesionista.verificado)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.verified, color: Colors.green),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(profesionista.ratingEstrellas),
                        const SizedBox(width: 8),
                        Text(
                          '${profesionista.rating.toStringAsFixed(1)}/5 (${profesionista.totalCalificaciones} valoraciones)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Info
                    _buildInfoRow(Icons.school, '${profesionista.experienciaAnios} años de experiencia'),
                    _buildInfoRow(Icons.location_on, profesionista.ciudad),
                    const SizedBox(height: 16),
                    // Especialidades
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: profesionista.especialidades.map((esp) {
                        return Chip(
                          label: Text(esp),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Descripción
                    if (profesionista.descripcion.isNotEmpty) ...[
                      Text(
                        profesionista.descripcion,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Botón de contactar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleMatchProfesionista(context, profesionista);
                        },
                        icon: const Icon(Icons.handshake),
                        label: const Text('Hacer Match para Contactar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _handleMatchProfesionista(BuildContext context, ProfesionistaModel profesionista) async {
    // Obtener el userId del usuario actual
    final loginNotifier = context.read<LoginNotifier>();
    final chatNotifier = context.read<ChatPrivadoNotifier>();
    final userId = loginNotifier.currentUserId;
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se pudo obtener tu información de usuario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Mostrar loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Iniciando conversación...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
    
    // Crear la conversación
    final conversacion = await chatNotifier.iniciarConversacion(
      abogadoId: profesionista.id,
      mensajeInicial: '¡Hola! Me gustaría consultar sobre mi caso.',
    );
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    if (conversacion != null) {
      // Navegar directamente al chat
      context.push('/chat/${conversacion.ciudadanoId}/${conversacion.abogadoId}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(chatNotifier.errorMessage ?? 'Error al iniciar conversación'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAnuncianteDetails(BuildContext context, AnuncianteModel anunciante) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Título
              Row(
                children: [
                  Text(
                    anunciante.iconoCategoria,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anunciante.nombreComercial,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          anunciante.categoriaServicio,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (anunciante.disponible24h)
                    Chip(
                      label: const Text('24 hrs'),
                      avatar: const Icon(Icons.access_time, size: 16),
                      backgroundColor: Colors.blue.shade100,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Descripción
              if (anunciante.descripcion.isNotEmpty) ...[
                Text(anunciante.descripcion),
                const SizedBox(height: 16),
              ],
              // Dirección
              if (anunciante.direccion.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(anunciante.direccion),
                  contentPadding: EdgeInsets.zero,
                ),
              // Teléfono
              if (anunciante.telefono.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(anunciante.telefono),
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    final uri = Uri.parse('tel:${anunciante.telefono}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
              const SizedBox(height: 16),
              // Botón llamar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:${anunciante.telefono}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Llamar ahora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMessage(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isDark 
              ? theme.colorScheme.surfaceContainerHighest 
              : Colors.grey.shade100,
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
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Analizando tu consulta...',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
