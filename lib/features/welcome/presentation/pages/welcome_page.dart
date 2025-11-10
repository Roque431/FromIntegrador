import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isWeb ? 40 : 24,
              horizontal: isWeb ? 24 : 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWeb ? 550 : 380),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'lib/img/portada.png',
                    width: isWeb ? 140 : 120,
                    height: isWeb ? 140 : 120,
                  ),
                  SizedBox(height: isWeb ? 20 : 16),
                  Text(
                    'Bienvenido a LexIA',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.tertiary,
                          fontSize: isWeb ? 32 : null,
                        ),
                  ),
                  SizedBox(height: isWeb ? 32 : 24),

                  // Card contenedora
                  Material(
                    color: Colors.white,
                    elevation: isWeb ? 8 : 6,
                    borderRadius: BorderRadius.circular(isWeb ? 20 : 16),
                    child: Padding(
                      padding: EdgeInsets.all(isWeb ? 32.0 : 24.0),
                      child: Column(
                        children: [
                          Text(
                            'Adquiere el plan Pro de LexIA',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.tertiary,
                                  fontSize: isWeb ? 28 : null,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isWeb ? 20 : 16),

                          // Beneficios
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Beneficios.',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.tertiary,
                                    fontSize: isWeb ? 20 : null,
                                  ),
                            ),
                          ),
                          SizedBox(height: isWeb ? 16 : 12),

                          _buildBenefit(
                            context,
                            '1.-',
                            'Usuario experto con acceso a comentar otras conversaciones de otras personas.',
                            isWeb,
                          ),
                          SizedBox(height: isWeb ? 12 : 8),
                          _buildBenefit(
                            context,
                            '2.-',
                            'Poder acceder al Soporte técnico de Lexia, para darte ayuda sobre cualquier cosa.',
                            isWeb,
                          ),
                          SizedBox(height: isWeb ? 12 : 8),
                          _buildBenefit(
                            context,
                            '3.-',
                            'Acceso al Mapa de Lexia, podrás acceder a muchas indicaciones Transitoriales en tu estado',
                            isWeb,
                          ),
                          SizedBox(height: isWeb ? 32 : 24),

                          // Plan Pro
                          Container(
                            padding: EdgeInsets.all(isWeb ? 24 : 16),
                            decoration: BoxDecoration(
                              color: colors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Plan Pro',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.tertiary,
                                        fontSize: isWeb ? 28 : null,
                                      ),
                                ),
                                Text(
                                  '199\$',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.secondary,
                                        fontSize: isWeb ? 56 : null,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isWeb ? 32 : 24),

                          // Botón Obtener Plan Pro
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Navegar a página de pago del Plan Pro
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidad de pago por implementar'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.secondary,
                              minimumSize: Size(double.infinity, isWeb ? 60 : 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Obtener Plan Pro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isWeb ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: isWeb ? 22 : 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isWeb ? 16 : 12),

                          // Botón Continuar Gratis
                          OutlinedButton(
                            onPressed: () {
                              context.goNamed(AppRoutes.home);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, isWeb ? 60 : 54),
                              side: BorderSide(
                                color: colors.secondary.withValues(alpha: 0.5),
                                width: isWeb ? 2 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continuar Gratis',
                                  style: TextStyle(
                                    color: colors.secondary,
                                    fontSize: isWeb ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: colors.secondary,
                                  size: isWeb ? 22 : 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Banner superior pequeño
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, color: colors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Adquirir el plan Pro',
                          style: TextStyle(
                            color: colors.tertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(BuildContext context, String number, String text, bool isWeb) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: isWeb ? 16 : null,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: isWeb ? 16 : null,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
