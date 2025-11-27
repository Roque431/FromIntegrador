import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LawyerSubscriptionPage extends StatelessWidget {
  const LawyerSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.tertiary,
            size: isWeb ? 28 : 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mi Suscripción',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : null,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Estado de suscripción activa
                  Container(
                    padding: EdgeInsets.all(isWeb ? 18 : 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade700,
                          size: isWeb ? 26 : 24,
                        ),
                        SizedBox(width: isWeb ? 14 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Suscripción Activa',
                                style: TextStyle(
                                  fontSize: isWeb ? 17 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              SizedBox(height: isWeb ? 6 : 4),
                              Text(
                                'Tu Plan Profesional se renovará el 15 de diciembre, 2025',
                                style: TextStyle(
                                  fontSize: isWeb ? 14 : 13,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isWeb ? 28 : 24),

                  // Card del plan
                  Container(
                    padding: EdgeInsets.all(isWeb ? 24 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isWeb ? 16 : 14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Profesional',
                          style: TextStyle(
                            fontSize: isWeb ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: colors.tertiary,
                          ),
                        ),
                        SizedBox(height: isWeb ? 18 : 16),

                        // Precio
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$599',
                              style: TextStyle(
                                fontSize: isWeb ? 42 : 36,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFB8907D),
                              ),
                            ),
                            SizedBox(width: isWeb ? 10 : 8),
                            Padding(
                              padding: EdgeInsets.only(top: isWeb ? 12 : 10),
                              child: Text(
                                'por mes',
                                style: TextStyle(
                                  fontSize: isWeb ? 16 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isWeb ? 24 : 20),

                        // Información de pago
                        _buildInfoRow(
                          context,
                          'Próximo pago:',
                          '15 dic 2025',
                          isWeb,
                        ),
                        SizedBox(height: isWeb ? 14 : 12),
                        _buildInfoRow(
                          context,
                          'Método de pago:',
                          '•••• 4532',
                          isWeb,
                        ),

                        SizedBox(height: isWeb ? 24 : 20),

                        // Botón actualizar método de pago
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función de actualizar método de pago próximamente'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, isWeb ? 50 : 46),
                            side: BorderSide(
                              color: const Color(0xFFB8907D),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
                            ),
                          ),
                          child: Text(
                            'Actualizar Método de Pago',
                            style: TextStyle(
                              color: const Color(0xFFB8907D),
                              fontSize: isWeb ? 16 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isWeb ? 28 : 24),

                  // Características del plan
                  Text(
                    'Características de tu Plan',
                    style: TextStyle(
                      fontSize: isWeb ? 19 : 17,
                      fontWeight: FontWeight.bold,
                      color: colors.tertiary,
                    ),
                  ),

                  SizedBox(height: isWeb ? 16 : 14),

                  Container(
                    padding: EdgeInsets.all(isWeb ? 20 : 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isWeb ? 16 : 14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          context,
                          'Perfil destacado con badge',
                          isWeb,
                        ),
                        SizedBox(height: isWeb ? 14 : 12),
                        _buildFeatureItem(
                          context,
                          'Respuestas ilimitadas en foro',
                          isWeb,
                        ),
                        SizedBox(height: isWeb ? 14 : 12),
                        _buildFeatureItem(
                          context,
                          'Top 5 en recomendaciones',
                          isWeb,
                        ),
                        SizedBox(height: isWeb ? 14 : 12),
                        _buildFeatureItem(
                          context,
                          'Estadísticas avanzadas',
                          isWeb,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isWeb ? 32 : 28),

                  // Botón cambiar de plan
                  ElevatedButton(
                    onPressed: () {
                      _showChangePlanDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8907D),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, isWeb ? 54 : 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Cambiar de Plan',
                      style: TextStyle(
                        fontSize: isWeb ? 17 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 20 : 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    bool isWeb,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isWeb ? 15 : 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isWeb ? 16 : 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String text,
    bool isWeb,
  ) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.green.shade600,
          size: isWeb ? 22 : 20,
        ),
        SizedBox(width: isWeb ? 14 : 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isWeb ? 15 : 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar de Plan'),
        content: const Text(
          '¿Estás seguro que deseas cambiar tu plan?\n\nEsta función estará disponible próximamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
