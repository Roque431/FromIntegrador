import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LawyerVerificationPage extends StatefulWidget {
  const LawyerVerificationPage({super.key});

  @override
  State<LawyerVerificationPage> createState() => _LawyerVerificationPageState();
}

class _LawyerVerificationPageState extends State<LawyerVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Controladores de texto
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _officeNameController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Variables de selección
  String? _experienceYears;
  String _practiceType = 'Independiente';
  String _selectedSpecialty = 'Accidentes Vehiculares';
  String _billingPeriod = 'Mensual';
  
  // Lista de especialidades
  final List<String> _specialties = [
    'Accidentes Vehiculares',
    'Tránsito',
    'Accidentes',
    'Laboral',
    'Civil',
    'Penal',
    'Familiar',
    'Mercantil',
    'Administrativo',
  ];
  
  // Lista de años de experiencia
  final List<String> _experienceOptions = [
    '0-1 años',
    '2-5 años',
    '6-10 años',
    '11-15 años',
    '16-20 años',
    'Más de 20 años',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _officeNameController.dispose();
    _officeAddressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Verificación de Abogado',
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
            child: Form(
              key: _formKey,
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: colors.copyWith(primary: colors.primary),
                ),
                child: Stepper(
                  currentStep: _currentStep,
                  onStepTapped: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  controlsBuilder: (context, details) {
                    final isFirstStep = details.stepIndex == 0;
                    final isLastStep = details.stepIndex == 2;
                    
                    return Row(
                      children: [
                        if (!isLastStep)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (details.stepIndex == 0 && !_formKey.currentState!.validate()) {
                                  return;
                                }
                                if (details.stepIndex < 2) {
                                  setState(() {
                                    _currentStep++;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(details.stepIndex == 1 ? 'Finalizar' : 'Siguiente'),
                            ),
                          ),
                        if (isLastStep)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _submitVerification(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Continuar con Suscripción'),
                            ),
                          ),
                        if (!isFirstStep) const SizedBox(width: 8),
                        if (!isFirstStep)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _currentStep--;
                              });
                            },
                            child: Text(
                              'Atrás',
                              style: TextStyle(color: colors.tertiary),
                            ),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: Text(
                        'Datos',
                        style: TextStyle(color: colors.onSurface),
                      ),
                      content: _buildPersonalInfoStep(),
                      isActive: _currentStep >= 0,
                    ),
                    Step(
                      title: Text(
                        'Documentos',
                        style: TextStyle(color: colors.onSurface),
                      ),
                      content: _buildDocumentsStep(),
                      isActive: _currentStep >= 1,
                    ),
                    Step(
                      title: Text(
                        'Plan',
                        style: TextStyle(color: colors.onSurface),
                      ),
                      content: _buildPlanStep(),
                      isActive: _currentStep >= 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Personal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        
        // Nombre completo
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Nombre completo *',
            hintText: 'Ej: Ana María González López',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Correo electrónico
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico *',
            hintText: 'tu@email.com',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El correo es requerido';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Teléfono
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Teléfono de contacto *',
            hintText: '(961) 123-4567',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El teléfono es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        
        Text(
          'Información Profesional',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        
        // Cédula profesional
        TextFormField(
          controller: _licenseController,
          decoration: const InputDecoration(
            labelText: 'Cédula profesional *',
            hintText: 'Ej: 8766432',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La cédula profesional es requerida';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Años de experiencia
        DropdownButtonFormField<String>(
          value: _experienceYears,
          decoration: const InputDecoration(
            labelText: 'Años de experiencia *',
            border: OutlineInputBorder(),
          ),
          items: _experienceOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _experienceYears = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecciona años de experiencia';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Tipo de práctica
        Text(
          'Tipo de práctica *',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Independiente'),
                value: 'Independiente',
                groupValue: _practiceType,
                onChanged: (String? value) {
                  setState(() {
                    _practiceType = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Bufete'),
                value: 'Bufete',
                groupValue: _practiceType,
                onChanged: (String? value) {
                  setState(() {
                    _practiceType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Nombre del despacho (opcional)
        if (_practiceType == 'Bufete')
          TextFormField(
            controller: _officeNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del despacho/bufete (opcional)',
              hintText: 'Ej: González & Asociados',
              border: OutlineInputBorder(),
            ),
          ),
        if (_practiceType == 'Bufete') const SizedBox(height: 16),
        
        // Dirección del despacho
        TextFormField(
          controller: _officeAddressController,
          decoration: const InputDecoration(
            labelText: 'Dirección del despacho *',
            hintText: 'Calle, número, colonia',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La dirección es requerida';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Especialidades
        Text(
          'Especialidades (máx. 5) *',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSpecialty,
              isExpanded: true,
              items: _specialties.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedSpecialty = value!;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Descripción profesional
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descripción profesional *',
            hintText: 'Cuéntanos sobre tu experiencia, logros y áreas de especialización...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          maxLength: 500,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La descripción profesional es requerida';
            }
            if (value.length < 100) {
              return 'La descripción debe tener al menos 100 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documentos Requeridos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.tertiary,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Para completar la verificación, necesitamos los siguientes documentos:',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildDocumentItem(
          icon: Icons.card_membership,
          title: 'Cédula Profesional',
          description: 'Foto clara de tu cédula profesional',
          required: true,
          color: colors.secondary,
        ),
        const SizedBox(height: 12),

        _buildDocumentItem(
          icon: Icons.badge,
          title: 'Identificación Oficial',
          description: 'INE, pasaporte o licencia de conducir',
          required: true,
          color: colors.tertiary,
        ),
        const SizedBox(height: 12),

        _buildDocumentItem(
          icon: Icons.business,
          title: 'Comprobante de Domicilio',
          description: 'No mayor a 3 meses',
          required: true,
          color: const Color(0xFFB8907D),
        ),
        const SizedBox(height: 20),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Información Importante',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Los documentos serán revisados por nuestro equipo de verificación\n'
                '• El proceso de verificación toma entre 24-48 horas\n'
                '• Te notificaremos por email el resultado\n'
                '• Todos los documentos son tratados de forma confidencial',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem({
    required IconData icon,
    required String title,
    required String description,
    required bool required,
    required Color color,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colors.tertiary,
                        ),
                      ),
                    ),
                    if (required) const SizedBox(width: 4),
                    if (required)
                      Text(
                        '*',
                        style: TextStyle(
                          color: colors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: colors.tertiary.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar selección de archivo
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Subir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Profesional',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona el período de facturación que prefieras',
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 20),
        
        // Plan profesional card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Plan Profesional',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Incluye:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                _buildFeatureItem('✓ Panel de abogado completo'),
                _buildFeatureItem('✓ Gestión de consultas pendientes'),
                _buildFeatureItem('✓ Participación prioritaria en foro'),
                _buildFeatureItem('✓ Estadísticas avanzadas de práctica'),
                _buildFeatureItem('✓ Notificaciones de nuevos clientes'),
                _buildFeatureItem('✓ Perfil verificado con insignia'),
                _buildFeatureItem('✓ Mayor visibilidad en búsquedas'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Selección de período de facturación
        Text(
          'Período de Facturación',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _billingPeriod = 'Mensual';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _billingPeriod == 'Mensual'
                        ? colors.secondary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: _billingPeriod == 'Mensual'
                          ? colors.secondary
                          : colors.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Mensual',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _billingPeriod == 'Mensual'
                              ? colors.secondary
                              : colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$299',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _billingPeriod == 'Mensual'
                              ? colors.secondary
                              : colors.onSurface,
                        ),
                      ),
                      Text(
                        'por mes',
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _billingPeriod = 'Anual';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _billingPeriod == 'Anual'
                        ? colors.secondary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: _billingPeriod == 'Anual'
                          ? colors.secondary
                          : colors.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anual',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _billingPeriod == 'Anual'
                                  ? colors.secondary
                                  : colors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '20% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$2,390',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _billingPeriod == 'Anual'
                              ? colors.secondary
                              : colors.onSurface,
                        ),
                      ),
                      Text(
                        'por año',
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      if (_billingPeriod == 'Anual')
                        Text(
                          'Ahorras \$1,198',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  void _submitVerification() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }
    
    // TODO: Implementar envío de datos de verificación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verificación Enviada'),
        content: const Text(
          'Tu solicitud de verificación ha sido enviada exitosamente. '
          'Recibirás un email de confirmación y el resultado de la verificación en 24-48 horas.\n\n'
          '¡Gracias por unirte a LexIA como profesional!',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}