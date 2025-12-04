import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/chat_privado_notifier.dart';
import '../../data/models/mensaje_privado_model.dart';

class ChatPrivadoPage extends StatefulWidget {
  final String ciudadanoId;
  final String abogadoId;

  const ChatPrivadoPage({
    super.key,
    required this.ciudadanoId,
    required this.abogadoId,
  });

  @override
  State<ChatPrivadoPage> createState() => _ChatPrivadoPageState();
}

class _ChatPrivadoPageState extends State<ChatPrivadoPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
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

  Future<void> _enviarMensaje() async {
    final mensaje = _messageController.text.trim();
    if (mensaje.isEmpty) return;

    _messageController.clear();
    
    final success = await context.read<ChatPrivadoNotifier>().enviarMensaje(mensaje);
    
    if (success) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatNotifier = context.watch<ChatPrivadoNotifier>();
    final conversacion = chatNotifier.conversacionActual;

    // Scroll al fondo cuando hay nuevos mensajes
    if (chatNotifier.mensajes.isNotEmpty) {
      _scrollToBottom();
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            chatNotifier.clearConversacionActual();
            context.pop();
          },
        ),
        title: conversacion != null
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 18,
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
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversacion.otroUsuarioNombre,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (conversacion.esAbogado)
                          Row(
                            children: [
                              Icon(Icons.verified, size: 12, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(
                                'Abogado verificado',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              )
            : Text(
                'Chat',
                style: TextStyle(color: colorScheme.onSurface),
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onPressed: () => _showOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mensajes
          Expanded(
            child: chatNotifier.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatNotifier.mensajes.isEmpty
                    ? _buildEmptyChat(context)
                    : _buildMessagesList(context, chatNotifier),
          ),

          // Input de mensaje
          _buildMessageInput(context, chatNotifier),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final conversacion = context.read<ChatPrivadoNotifier>().conversacionActual;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Inicia la conversación!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Envía un mensaje a ${conversacion?.otroUsuarioNombre ?? 'este profesionista'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, ChatPrivadoNotifier notifier) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifier.mensajes.length,
      itemBuilder: (context, index) {
        final mensaje = notifier.mensajes[index];
        final esMio = mensaje.esMio(notifier.currentUserId);
        
        // Verificar si mostrar fecha
        final mostrarFecha = index == 0 ||
            _deberenMostrarFecha(notifier.mensajes[index - 1].fecha, mensaje.fecha);

        return Column(
          children: [
            if (mostrarFecha) _buildDateSeparator(context, mensaje.fecha),
            _MessageBubble(mensaje: mensaje, esMio: esMio),
          ],
        );
      },
    );
  }

  bool _deberenMostrarFecha(DateTime anterior, DateTime actual) {
    return anterior.day != actual.day ||
        anterior.month != actual.month ||
        anterior.year != actual.year;
  }

  Widget _buildDateSeparator(BuildContext context, DateTime fecha) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    String texto;

    if (fecha.day == now.day && fecha.month == now.month && fecha.year == now.year) {
      texto = 'Hoy';
    } else if (fecha.day == now.day - 1 && fecha.month == now.month && fecha.year == now.year) {
      texto = 'Ayer';
    } else {
      texto = '${fecha.day}/${fecha.month}/${fecha.year}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatPrivadoNotifier notifier) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _enviarMensaje(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: notifier.isSending ? null : _enviarMensaje,
              icon: notifier.isSending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Icon(Icons.send, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final conversacion = context.read<ChatPrivadoNotifier>().conversacionActual;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (conversacion?.esAbogado == true)
            ListTile(
              leading: Icon(Icons.person, color: colorScheme.primary),
              title: Text('Ver perfil del abogado'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar al perfil del abogado
              },
            ),
          ListTile(
            leading: Icon(Icons.block, color: colorScheme.error),
            title: Text('Bloquear usuario', style: TextStyle(color: colorScheme.error)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implementar bloqueo
            },
          ),
          ListTile(
            leading: Icon(Icons.report_outlined, color: colorScheme.error),
            title: Text('Reportar', style: TextStyle(color: colorScheme.error)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implementar reporte
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MensajePrivadoModel mensaje;
  final bool esMio;

  const _MessageBubble({
    required this.mensaje,
    required this.esMio,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: esMio ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: esMio ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: esMio ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mensaje.contenido,
              style: TextStyle(
                color: esMio ? colorScheme.onPrimary : colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mensaje.horaFormateada,
                  style: TextStyle(
                    fontSize: 11,
                    color: esMio
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (esMio) ...[
                  const SizedBox(width: 4),
                  Icon(
                    mensaje.leido ? Icons.done_all : Icons.done,
                    size: 14,
                    color: mensaje.leido
                        ? Colors.lightBlueAccent
                        : colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
