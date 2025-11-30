import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/basic_info_form.dart';
import '../widgets/services_schedule_form.dart';
import '../widgets/document_upload_section.dart';
import '../widgets/plan_selection_section.dart';

class BusinessRegistrationPage extends StatefulWidget {
  const BusinessRegistrationPage({super.key});

  @override
  State<BusinessRegistrationPage> createState() =>
      _BusinessRegistrationPageState();
}

class _BusinessRegistrationPageState extends State<BusinessRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controladores de texto - Información básica
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _websiteController = TextEditingController();

  // Controladores - Información del servicio
  final _serviceDescriptionController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();

  // Variables de selección
  String _businessType = 'Servicios';
  String _businessSize = '1-5 empleados';
  List<String> _selectedServices = [];
  List<String> _selectedDays = [];
  String _billingPeriod = 'Mensual';

  // Listas de opciones
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

  final List<String> _businessSizes = [
    '1-5 empleados',
    '6-20 empleados',
    '21-50 empleados',
    '51-100 empleados',
    'Más de 100 empleados',
  ];

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

  final List<String> _weekDays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _serviceDescriptionController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
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
            constraints:
                BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: colors.secondary,
                ),
              ),
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 3) {
                    setState(() {
                      _currentStep++;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                },
                controlsBuilder: (context, details) {
                  final isFirstStep = details.stepIndex == 0;
                  final isLastStep = details.stepIndex == 3;

                  return Row(
                    children: [
                      if (!isLastStep)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (details.stepIndex == 0 &&
                                  !_formKey.currentState!.validate()) {
                                return;
                              }
                              if (details.stepIndex < 3) {
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
                            child: const Text('Siguiente'),
                          ),
                        ),
                      if (isLastStep)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _submitRegistration(),
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
                    title: const Text('Información Básica'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: BasicInfoForm(
                      formKey: _formKey,
                      businessNameController: _businessNameController,
                      ownerNameController: _ownerNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      postalCodeController: _postalCodeController,
                      websiteController: _websiteController,
                      businessType: _businessType,
                      businessSize: _businessSize,
                      businessTypes: _businessTypes,
                      businessSizes: _businessSizes,
                      onBusinessTypeChanged: (value) {
                        setState(() {
                          _businessType = value!;
                        });
                      },
                      onBusinessSizeChanged: (value) {
                        setState(() {
                          _businessSize = value!;
                        });
                      },
                    ),
                  ),
                  Step(
                    title: const Text('Servicios y Horarios'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    content: ServicesScheduleForm(
                      serviceDescriptionController:
                          _serviceDescriptionController,
                      openingTimeController: _openingTimeController,
                      closingTimeController: _closingTimeController,
                      selectedServices: _selectedServices,
                      selectedDays: _selectedDays,
                      availableServices: _availableServices,
                      weekDays: _weekDays,
                      onServiceToggle: (service) {
                        setState(() {
                          if (_selectedServices.contains(service)) {
                            _selectedServices.remove(service);
                          } else {
                            _selectedServices.add(service);
                          }
                        });
                      },
                      onDayToggle: (day) {
                        setState(() {
                          if (_selectedDays.contains(day)) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        });
                      },
                      onOpeningTimeTap: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null && mounted) {
                          setState(() {
                            _openingTimeController.text = time.format(context);
                          });
                        }
                      },
                      onClosingTimeTap: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null && mounted) {
                          setState(() {
                            _closingTimeController.text = time.format(context);
                          });
                        }
                      },
                    ),
                  ),
                  Step(
                    title: const Text('Documentos'),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                    content: const DocumentUploadSection(),
                  ),
                  Step(
                    title: const Text('Plan de Negocio'),
                    isActive: _currentStep >= 3,
                    state: _currentStep > 3
                        ? StepState.complete
                        : StepState.indexed,
                    content: PlanSelectionSection(
                      billingPeriod: _billingPeriod,
                      onBillingPeriodChanged: (period) {
                        setState(() {
                          _billingPeriod = period;
                        });
                      },
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

  void _submitRegistration() {
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un servicio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un día de atención'),
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
