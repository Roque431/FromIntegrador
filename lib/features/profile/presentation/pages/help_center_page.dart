import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  String _searchQuery = '';
  
  // Base de preguntas frecuentes
  final List<Map<String, String>> _faqs = [
    {
      'categoria': 'Cuenta y Autenticación',
      'pregunta': '¿Cómo recupero mi contraseña?',
      'respuesta': 'Haz clic en "Olvidé mi contraseña" en la página de login. Recibirás un email con instrucciones para crear una nueva contraseña.',
    },
    {
      'categoria': 'Cuenta y Autenticación',
      'pregunta': '¿Cómo actualizo mi perfil?',
      'respuesta': 'Vuelve a Mi Perfil > Editar Perfil. Ahí puedes cambiar tu información personal, foto de perfil y datos de contacto.',
    },
    {
      'categoria': 'Chat y Consultas',
      'pregunta': '¿Cómo hago una consulta legal?',
      'respuesta': 'Ve a la sección Chat y escribe tu pregunta. La IA procesará tu consulta y te proporcionará información legal relevante en tiempo real.',
    },
    {
      'categoria': 'Chat y Consultas',
      'pregunta': '¿Pueden mis consultas ser compartidas con abogados?',
      'respuesta': 'Sí, puedes optar por compartir tus conversaciones con profesionales. Ello puede conectarte con abogados especializados en tu tema.',
    },
    {
      'categoria': 'Foro Comunitario',
      'pregunta': '¿Cómo publico en el foro?',
      'respuesta': 'Dirígete a Foro > Nueva Publicación, selecciona una categoría, escribe tu título y contenido, luego haz clic en Publicar.',
    },
    {
      'categoria': 'Foro Comunitario',
      'pregunta': '¿Puedo eliminar mis publicaciones?',
      'respuesta': 'Sí, puedes editar o eliminar tus publicaciones desde tu perfil. Solo tú puedes hacerlo (además de moderadores).',
    },
    {
      'categoria': 'Profesionales',
      'pregunta': '¿Cómo me registro como abogado?',
      'respuesta': 'Ve a Mi Perfil > Soy Abogado. Completa el formulario con tus datos profesionales y documentos de verificación.',
    },
    {
      'categoria': 'Profesionales',
      'pregunta': '¿Cuál es el proceso de verificación?',
      'respuesta': 'Tras enviar tu solicitud, nuestro equipo revisará tus documentos (usualmente 2-3 días hábiles). Te notificaremos el resultado por email.',
    },
    {
      'categoria': 'Privacidad y Seguridad',
      'pregunta': '¿Mis datos son seguros?',
      'respuesta': 'Sí, usamos encriptación de grado militar. Todos tus datos son protegidos según las leyes de privacidad vigentes.',
    },
    {
      'categoria': 'Privacidad y Seguridad',
      'pregunta': '¿Cómo cambio mi privacidad?',
      'respuesta': 'Ve a Configuración > Privacidad. Allí puedes controlar quién ve tu perfil, publicaciones y actividad.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) {
      return _faqs;
    }
    return _faqs
        .where((faq) =>
            faq['pregunta']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq['respuesta']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq['categoria']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    final isWide = size.width > 600;
    final isDesktop = size.width > 900;

    final horizontalPadding = isDesktop ? 32.0 : (isWide ? 24.0 : 16.0);
    final maxWidth = isDesktop ? 700.0 : (isWide ? 600.0 : double.infinity);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Centro de Ayuda',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              children: [
                // Buscador
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar ayuda...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Categorías rápidas
                if (_searchQuery.isEmpty) ...[
                  Text(
                    'Temas Populares',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Cuenta',
                      'Chat',
                      'Foro',
                      'Abogados',
                      'Privacidad',
                    ]
                        .map((topic) => ActionChip(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = topic;
                                });
                              },
                              label: Text(topic),
                              side: BorderSide(
                                color: colorScheme.outline.withValues(alpha: 0.2),
                              ),
                              backgroundColor: Colors.transparent,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Preguntas frecuentes
                Text(
                  _searchQuery.isEmpty
                      ? 'Preguntas Frecuentes'
                      : 'Resultados (${_filteredFaqs.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                if (_filteredFaqs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No encontramos resultados',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta con otras palabras clave',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredFaqs.length,
                    itemBuilder: (context, index) {
                      final faq = _filteredFaqs[index];
                      return _buildFaqTile(
                        context,
                        categoria: faq['categoria']!,
                        pregunta: faq['pregunta']!,
                        respuesta: faq['respuesta']!,
                      );
                    },
                  ),

                const SizedBox(height: 32),

                // Contacto y otros recursos
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.support_agent,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¿No encuentras lo que buscas?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Contacta con nuestro equipo de soporte',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            _buildContactOption(
                              context,
                              icon: Icons.email_outlined,
                              title: 'Email',
                              subtitle: 'soporte@lexia.com',
                              onTap: () => _launchEmail(),
                            ),
                            const SizedBox(height: 12),
                            _buildContactOption(
                              context,
                              icon: Icons.phone_outlined,
                              title: 'Teléfono',
                              subtitle: '+1 (555) 123-4567',
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),
                            _buildContactOption(
                              context,
                              icon: Icons.chat_outlined,
                              title: 'Chat en Vivo',
                              subtitle: 'Disponible 24/7',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(
    BuildContext context, {
    required String categoria,
    required String pregunta,
    required String respuesta,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoria,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pregunta,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                respuesta,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    const email = 'soporte@lexia.com';
    const subject = 'Ayuda con LexIA';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
      },
    );
    
    // Just show a snackbar for now
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enviando email a $email'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
