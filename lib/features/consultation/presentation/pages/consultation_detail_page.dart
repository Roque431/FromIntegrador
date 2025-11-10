import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/user_message_bubble.dart';
import '../../widgets/lexia_message_bubble.dart';

class ConsultationDetailPage extends StatelessWidget {
  final String consultationId;

  const ConsultationDetailPage({
    super.key,
    required this.consultationId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // TODO: Cargar datos reales de la consulta desde la API
    final userQuestion = "¿Qué pasa si me despiden y no me pagan mi liquidación?";
    final lexiaResponse = _getLexiaResponse();

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.secondary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Volver al historial',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colors.tertiary),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mensaje del usuario
                    UserMessageBubble(
                      message: userQuestion,
                      initials: 'RA',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Respuesta de LexIA
                    LexiaMessageBubble(
                      message: lexiaResponse,
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

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Compartir consulta'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar compartir
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Descargar como PDF'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar descarga
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Eliminar consulta', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar consulta'),
        content: const Text('¿Estás seguro que deseas eliminar esta consulta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Regresar al historial
              // TODO: Eliminar consulta de la API
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Consulta eliminada')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  String _getLexiaResponse() {
    return """**Respuesta Legal:**

Según el Artículo 50 de la Ley Federal del Trabajo de México:

**Tus Derechos:**

- Tienes derecho a recibir una indemnización de 3 meses de salario
- Pago de prima de antigüedad (12 días de salario por año trabajado)
- Salarios vencidos desde el despido hasta que se cubra la indemnización
- Prima vacacional proporcional - Aguinaldo proporcional

**Marco Legal:**

**Ley Federal del Trabajo - Artículo 50:**

"Si en el juicio correspondiente no comprueba el patrón las causas de la rescisión, el trabajador tendrá derecho, además, a que se le paguen los salarios vencidos desde la fecha del despido hasta por un período máximo de doce meses."

**Artículo 162:**

"Los trabajadores que tengan más de un año de servicios disfrutarán de un período anual de vacaciones pagadas, que en ningún caso podrá ser inferior a seis días laborables, y que aumentará en dos días laborables, hasta llegar a doce, por cada año subsiguiente de servicios."

**Pasos a Seguir:**

1. **Reúne evidencia:**

   - Contratos de trabajo
   - Recibos de nómina
   - Comunicados escritos del despido
   - Correos electrónicos relevantes
   - Testigos si es posible

2. **Acude a PROFEDET:**

   - Procuraduría Federal de la Defensa del Trabajo
   - Servicio completamente gratuito
   - Te orientarán sobre tus derechos específicos
   - Pueden mediar entre tú y tu empleador
   - Sitio web: www.profedet.gob.mx""";
  }
}