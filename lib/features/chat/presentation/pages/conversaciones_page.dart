import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/chat_privado_notifier.dart';
import '../../data/models/mensaje_privado_model.dart';

class ConversacionesPage extends StatefulWidget {
  const ConversacionesPage({super.key});

  @override
  State<ConversacionesPage> createState() => _ConversacionesPageState();
}

class _ConversacionesPageState extends State<ConversacionesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatPrivadoNotifier>().loadConversaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatNotifier = context.watch<ChatPrivadoNotifier>();

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
          'Mensajes',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (chatNotifier.totalNoLeidos > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${chatNotifier.totalNoLeidos} nuevos',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: chatNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatNotifier.hasError
              ? _buildErrorView(context, chatNotifier.errorMessage)
              : chatNotifier.conversaciones.isEmpty
                  ? _buildEmptyView(context)
                  : _buildConversacionesList(context, chatNotifier.conversaciones),
    );
  }

  Widget _buildErrorView(BuildContext context, String? error) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar mensajes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Intenta de nuevo más tarde',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ChatPrivadoNotifier>().loadConversaciones();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin conversaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando hagas match con un profesionista,\npodrás chatear aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversacionesList(
    BuildContext context,
    List<ConversacionPrivadaModel> conversaciones,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => context.read<ChatPrivadoNotifier>().loadConversaciones(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: conversaciones.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 76,
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final conv = conversaciones[index];
          return _ConversacionTile(
            conversacion: conv,
            onTap: () {
              context.read<ChatPrivadoNotifier>().loadMensajes(conv);
              context.push('/chat/${conv.ciudadanoId}/${conv.abogadoId}');
            },
          );
        },
      ),
    );
  }
}

class _ConversacionTile extends StatelessWidget {
  final ConversacionPrivadaModel conversacion;
  final VoidCallback onTap;

  const _ConversacionTile({
    required this.conversacion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tieneNoLeidos = conversacion.mensajesNoLeidos > 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: conversacion.otroUsuarioFoto != null
                ? NetworkImage(conversacion.otroUsuarioFoto!)
                : null,
            child: conversacion.otroUsuarioFoto == null
                ? Text(
                    conversacion.iniciales,
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
          if (conversacion.esAbogado)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 2),
                ),
                child: const Icon(Icons.verified, color: Colors.white, size: 12),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversacion.otroUsuarioNombre,
              style: TextStyle(
                fontWeight: tieneNoLeidos ? FontWeight.bold : FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            conversacion.fechaFormateada,
            style: TextStyle(
              fontSize: 12,
              color: tieneNoLeidos ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: tieneNoLeidos ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversacion.ultimoMensaje ?? 'Inicia la conversación...',
              style: TextStyle(
                color: tieneNoLeidos
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
                fontWeight: tieneNoLeidos ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (tieneNoLeidos)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversacion.mensajesNoLeidos}',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
