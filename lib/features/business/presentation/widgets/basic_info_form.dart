import 'package:flutter/material.dart';

class BasicInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController businessNameController;
  final TextEditingController ownerNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController postalCodeController;
  final TextEditingController websiteController;
  final String businessType;
  final String businessSize;
  final List<String> businessTypes;
  final List<String> businessSizes;
  final Function(String?) onBusinessTypeChanged;
  final Function(String?) onBusinessSizeChanged;

  const BasicInfoForm({
    super.key,
    required this.formKey,
    required this.businessNameController,
    required this.ownerNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.postalCodeController,
    required this.websiteController,
    required this.businessType,
    required this.businessSize,
    required this.businessTypes,
    required this.businessSizes,
    required this.onBusinessTypeChanged,
    required this.onBusinessSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                    const Icon(Icons.business, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
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

          const SizedBox(height: 24),

          // Nombre del negocio
          TextFormField(
            controller: businessNameController,
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
            controller: ownerNameController,
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
            initialValue: businessType,
            decoration: const InputDecoration(
              labelText: 'Tipo de negocio *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            items: businessTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onBusinessTypeChanged,
          ),
          const SizedBox(height: 16),

          // Tamaño del negocio
          DropdownButtonFormField<String>(
            initialValue: businessSize,
            decoration: const InputDecoration(
              labelText: 'Tamaño del negocio *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.groups),
            ),
            items: businessSizes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onBusinessSizeChanged,
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: emailController,
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
            controller: phoneController,
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
            controller: addressController,
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

          // Código Postal
          TextFormField(
            controller: postalCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Código Postal *',
              hintText: '29000',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.mail_outline),
            ),
            maxLength: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El código postal es requerido';
              }
              if (value.length != 5) {
                return 'El código postal debe tener 5 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Sitio web (opcional)
          TextFormField(
            controller: websiteController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Sitio web (opcional)',
              hintText: 'https://www.tunegocio.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.web),
            ),
          ),
        ],
      ),
    );
  }
}
