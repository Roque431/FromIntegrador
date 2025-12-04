import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/responsive_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

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
          'Verificación de Abogado',
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
            constraints: BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Step indicator
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStepIndicator(colorScheme),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.horizontalPadding(context),
                      ),
                      child: _buildCurrentStep(),
                    ),
                  ),
                  
                  // Navigation buttons
                  _buildNavigationButtons(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ColorScheme colorScheme) {
    return Row(
      children: [
        _buildStepCircle(0, 'Datos', colorScheme),
        Expanded(child: _buildStepLine(0, colorScheme)),
        _buildStepCircle(1, 'Documentos', colorScheme),
        Expanded(child: _buildStepLine(1, colorScheme)),
        _buildStepCircle(2, 'Plan', colorScheme),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label, ColorScheme colorScheme) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;
    
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: colorScheme.primary, width: 2) : null,
          ),
          child: Center(
            child: isActive && !isCurrent
                ? Icon(Icons.check, color: colorScheme.onPrimary, size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step, ColorScheme colorScheme) {
    final isCompleted = _currentStep > step;
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
    );
  }

  Widget _buildNavigationButtons(ColorScheme colorScheme) {
    final isFirstStep = _currentStep == 0;
    final isLastStep = _currentStep == 2;
    
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            Expanded(
              child: ResponsiveButton(
                text: 'Atrás',
                isOutlined: true,
                onPressed: () {
                  setState(() => _currentStep--);
                },
              ),
            ),
          if (!isFirstStep) const SizedBox(width: 12),
          Expanded(
            flex: isFirstStep ? 1 : 2,
            child: ResponsiveButton(
              text: isLastStep ? 'Finalizar Registro' : 'Siguiente',
              onPressed: () {
                if (_currentStep == 0 && !_formKey.currentState!.validate()) {
                  return;
                }
                if (isLastStep) {
                  _submitVerification();
                } else {
                  setState(() => _currentStep++);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildDocumentsStep();
      case 2:
        return _buildPlanStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              ResponsiveTextField(
                controller: _fullNameController,
                hintText: 'Nombre completo *',
                prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El nombre es requerido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              ResponsiveTextField(
                controller: _emailController,
                hintText: 'Correo electrónico *',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El correo es requerido';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Ingresa un correo válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              ResponsiveTextField(
                controller: _phoneController,
                hintText: 'Teléfono de contacto *',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, color: colorScheme.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El teléfono es requerido';
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        ResponsiveCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Profesional',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              ResponsiveTextField(
                controller: _licenseController,
                hintText: 'Cédula profesional *',
                prefixIcon: Icon(Icons.badge_outlined, color: colorScheme.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La cédula es requerida';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              _buildDropdown(
                value: _experienceYears,
                hint: 'Años de experiencia *',
                items: _experienceOptions,
                onChanged: (value) => setState(() => _experienceYears = value),
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 16),
              
              Text(
                'Tipo de práctica',
                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildPracticeChip('Independiente', colorScheme)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPracticeChip('Bufete', colorScheme)),
                ],
              ),
              const SizedBox(height: 12),
              
              if (_practiceType == 'Bufete') ...[
                ResponsiveTextField(
                  controller: _officeNameController,
                  hintText: 'Nombre del bufete (opcional)',
                  prefixIcon: Icon(Icons.business, color: colorScheme.primary),
                ),
                const SizedBox(height: 12),
              ],
              
              ResponsiveTextField(
                controller: _officeAddressController,
                hintText: 'Dirección del despacho *',
                prefixIcon: Icon(Icons.location_on_outlined, color: colorScheme.primary),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La dirección es requerida';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              Text(
                'Especialidades (máx. 5) *',
                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedSpecialty,
                hint: 'Seleccionar especialidad',
                items: _specialties,
                onChanged: (value) => setState(() => _selectedSpecialty = value!),
                icon: Icons.gavel,
              ),
              const SizedBox(height: 12),
              
              ResponsiveTextField(
                controller: _descriptionController,
                hintText: 'Descripción profesional *',
                prefixIcon: Icon(Icons.description_outlined, color: colorScheme.primary),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La descripción es requerida';
                  if (value.length < 100) return 'Mínimo 100 caracteres';
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPracticeChip(String type, ColorScheme colorScheme) {
    final isSelected = _practiceType == type;
    return GestureDetector(
      onTap: () => setState(() => _practiceType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: colorScheme.surfaceContainerHighest,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      items: items.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e, style: TextStyle(color: colorScheme.onSurface)),
      )).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDocumentsStep() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Documentos Requeridos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Para completar la verificación, necesitamos los siguientes documentos:',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              
              _buildDocumentItem(
                icon: Icons.card_membership,
                title: 'Cédula Profesional',
                description: 'Foto clara de tu cédula profesional',
                required: true,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),

              _buildDocumentItem(
                icon: Icons.badge,
                title: 'Identificación Oficial',
                description: 'INE, pasaporte o licencia de conducir',
                required: true,
                color: colorScheme.secondary,
              ),
              const SizedBox(height: 12),

              _buildDocumentItem(
                icon: Icons.business,
                title: 'Comprobante de Domicilio',
                description: 'No mayor a 3 meses',
                required: true,
                color: Colors.teal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        ResponsiveCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Importante',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Los documentos serán revisados por nuestro equipo\n'
                      '• El proceso toma entre 24-48 horas\n'
                      '• Te notificaremos por email el resultado\n'
                      '• Todos los documentos son confidenciales',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
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
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (required) ...[
                      const SizedBox(width: 4),
                      Text('*', style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Subir', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Plan card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
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
                    const Text(
                      'Plan Profesional',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                const Text('Incluye:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
        
        ResponsiveCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Período de Facturación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildBillingOption('Mensual', '\$299', 'por mes', null)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildBillingOption('Anual', '\$2,390', 'por año', '20% OFF')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBillingOption(String period, String price, String unit, String? badge) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _billingPeriod == period;
    
    return GestureDetector(
      onTap: () => setState(() => _billingPeriod = period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.surface,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            Text(
              period,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            Text(unit, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
            if (isSelected && period == 'Anual')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Ahorras \$1,198', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }

  void _submitVerification() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
    
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Verificación Enviada', style: TextStyle(color: colorScheme.onSurface)),
        content: Text(
          'Tu solicitud ha sido enviada exitosamente. '
          'Recibirás un email con el resultado en 24-48 horas.\n\n'
          '¡Gracias por unirte a LexIA!',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
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