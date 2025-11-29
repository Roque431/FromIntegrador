import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessRegistrationPage extends StatefulWidget {
  const BusinessRegistrationPage({super.key});

  @override
  State<BusinessRegistrationPage> createState() => _BusinessRegistrationPageState();
}

class _BusinessRegistrationPageState extends State<BusinessRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  
  // Variables de selección
  String _businessType = 'Servicios';
  String _businessSize = '1-5 empleados';
  List<String> _selectedServices = [];
  
  // Lista de tipos de negocio
  final List<String> _businessTypes = [
    'Servicios',
    'Comercio',
    'Restaurante/Comida',
    'Salud y Belleza',
    'Tecnología',
    'Educación',
    'Inmobiliaria',
    'Otro',
  ];
  
  // Lista de tamaños de negocio
  final List<String> _businessSizes = [
    '1-5 empleados',
    '6-20 empleados',
    '21-50 empleados',
    '51-100 empleados',
    'Más de 100 empleados',
  ];
  
  // Lista de servicios disponibles
  final List<String> _availableServices = [
    'Consultoría Legal',
    'Asesoría Jurídica',
    'Trámites Legales',
    'Registro de Marca',
    'Contratos',
    'Notaría',
    'Mediación',
    'Otros Servicios',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
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
          'Registro de Negocio',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 32 : 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.green.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.business, color: Colors.white, size: 28),
                              const SizedBox(width: 12),
                              Text(
                                'Promociona tu Negocio',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aumenta tu visibilidad y atrae más clientes anunciando tus servicios en LexIA',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Información básica
                    Text(
                      'Información Básica',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nombre del negocio
                    TextFormField(
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del negocio *',
                        hintText: 'Ej: Bufete González & Asociados',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre del negocio es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Nombre del propietario
                    TextFormField(
                      controller: _ownerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del propietario *',
                        hintText: 'Tu nombre completo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre del propietario es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Tipo de negocio
                    DropdownButtonFormField<String>(
                      value: _businessType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de negocio *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _businessTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _businessType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Tamaño del negocio
                    DropdownButtonFormField<String>(
                      value: _businessSize,
                      decoration: const InputDecoration(
                        labelText: 'Tamaño del negocio *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.groups),
                      ),
                      items: _businessSizes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _businessSize = value!;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Información de contacto
                    Text(
                      'Información de Contacto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico *',
                        hintText: 'contacto@tunegocio.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
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
                        labelText: 'Teléfono *',
                        hintText: '(961) 123-4567',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Dirección
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección *',
                        hintText: 'Calle, número, colonia, ciudad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
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
                    
                    // Sitio web (opcional)
                    TextFormField(
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Sitio web (opcional)',
                        hintText: 'https://www.tunegocio.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.web),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Servicios ofrecidos
                    Text(
                      'Servicios Ofrecidos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona los servicios que ofreces (puedes elegir varios)',
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Lista de servicios
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableServices.map((service) {
                        final isSelected = _selectedServices.contains(service);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedServices.remove(service);
                              } else {
                                _selectedServices.add(service);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? colors.primary 
                                  : colors.surface,
                              border: Border.all(
                                color: isSelected 
                                    ? colors.primary 
                                    : colors.outline.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service,
                              style: TextStyle(
                                color: isSelected 
                                    ? Colors.white 
                                    : colors.onSurface,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Descripción
                    Text(
                      'Descripción del Negocio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción *',
                        hintText: 'Describe tu negocio, servicios y lo que te hace único...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      maxLength: 500,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La descripción es requerida';
                        }
                        if (value.length < 50) {
                          return 'La descripción debe tener al menos 50 caracteres';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Beneficios de registrarse
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: colors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Beneficios de registrarte',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildBenefitItem('✓ Aparece en búsquedas de servicios'),
                          _buildBenefitItem('✓ Perfil empresarial verificado'),
                          _buildBenefitItem('✓ Contacto directo con clientes'),
                          _buildBenefitItem('✓ Estadísticas de visualizaciones'),
                          _buildBenefitItem('✓ Reseñas y calificaciones'),
                          _buildBenefitItem('✓ Promoción en el mapa legal'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botón de envío
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Registrar Negocio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Términos
                    Text(
                      'Al registrar tu negocio, aceptas nuestros Términos de Servicio y Política de Privacidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: colors.primary,
          fontSize: 14,
        ),
      ),
    );
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un servicio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // TODO: Implementar envío de datos de registro
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Registro Exitoso!'),
        content: const Text(
          'Tu negocio ha sido registrado exitosamente. '
          'Nuestro equipo revisará la información y te contactaremos pronto.\n\n'
          'Tu negocio aparecerá en las búsquedas una vez que sea aprobado.',
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