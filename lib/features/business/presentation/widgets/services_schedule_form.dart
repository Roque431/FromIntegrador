import 'package:flutter/material.dart';

class ServicesScheduleForm extends StatelessWidget {
  final TextEditingController serviceDescriptionController;
  final TextEditingController openingTimeController;
  final TextEditingController closingTimeController;
  final List<String> selectedServices;
  final List<String> selectedDays;
  final List<String> availableServices;
  final List<String> weekDays;
  final Function(String) onServiceToggle;
  final Function(String) onDayToggle;
  final Function() onOpeningTimeTap;
  final Function() onClosingTimeTap;

  const ServicesScheduleForm({
    super.key,
    required this.serviceDescriptionController,
    required this.openingTimeController,
    required this.closingTimeController,
    required this.selectedServices,
    required this.selectedDays,
    required this.availableServices,
    required this.weekDays,
    required this.onServiceToggle,
    required this.onDayToggle,
    required this.onOpeningTimeTap,
    required this.onClosingTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servicios Ofrecidos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona los servicios que ofreces (puedes elegir varios)',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),

        // Lista de servicios
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableServices.map((service) {
            final isSelected = selectedServices.contains(service);
            return GestureDetector(
              onTap: () => onServiceToggle(service),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.secondary : colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.secondary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service,
                  style: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Descripción del servicio
        Text(
          'Descripción de Servicios',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: serviceDescriptionController,
          decoration: InputDecoration(
            labelText: 'Descripción de tus servicios *',
            hintText:
                'Describe detalladamente los servicios que ofreces, tu experiencia y lo que te hace único...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
          ),
          maxLines: 5,
          maxLength: 500,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La descripción de servicios es requerida';
            }
            if (value.length < 50) {
              return 'La descripción debe tener al menos 50 caracteres';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Horario de Atención
        Text(
          'Horario de Atención',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Días de atención
        Text(
          'Días de atención *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weekDays.map((day) {
            final isSelected = selectedDays.contains(day);
            return GestureDetector(
              onTap: () => onDayToggle(day),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.secondary : colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.secondary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Horario de apertura y cierre
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: openingTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de apertura *',
                  hintText: '09:00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  prefixIcon: Icon(Icons.access_time, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                readOnly: true,
                onTap: onOpeningTimeTap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: closingTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora de cierre *',
                  hintText: '18:00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  prefixIcon: Icon(Icons.access_time, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                readOnly: true,
                onTap: onClosingTimeTap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
