class TransactionModel {
  final String id;
  final String usuarioId;
  final double monto;
  final String moneda;
  final String? metodoPago;
  final String estado; // 'pendiente', 'completado', 'fallido', 'reembolsado'
  final String? stripePaymentId;
  final String? stripeSessionId;
  final String? stripeCustomerId;
  final int? suscripcionAnterior;
  final int? suscripcionNueva;
  final DateTime fechaTransaccion;
  final DateTime? fechaCompletado;
  final Map<String, dynamic>? metadata;
  final String? notas;

  const TransactionModel({
    required this.id,
    required this.usuarioId,
    required this.monto,
    required this.moneda,
    this.metodoPago,
    required this.estado,
    this.stripePaymentId,
    this.stripeSessionId,
    this.stripeCustomerId,
    this.suscripcionAnterior,
    this.suscripcionNueva,
    required this.fechaTransaccion,
    this.fechaCompletado,
    this.metadata,
    this.notas,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      monto: (json['monto'] is num) ? (json['monto'] as num).toDouble() : double.parse(json['monto'].toString()),
      moneda: json['moneda'] as String? ?? 'USD',
      metodoPago: json['metodo_pago'] as String?,
      estado: json['estado'] as String,
      stripePaymentId: json['stripe_payment_id'] as String?,
      stripeSessionId: json['stripe_session_id'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      suscripcionAnterior: json['suscripcion_anterior'] as int?,
      suscripcionNueva: json['suscripcion_nueva'] as int?,
      fechaTransaccion: DateTime.parse(json['fecha_transaccion'] as String),
      fechaCompletado: json['fecha_completado'] != null 
          ? DateTime.parse(json['fecha_completado'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      notas: json['notas'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'monto': monto,
      'moneda': moneda,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      'estado': estado,
      if (stripePaymentId != null) 'stripe_payment_id': stripePaymentId,
      if (stripeSessionId != null) 'stripe_session_id': stripeSessionId,
      if (stripeCustomerId != null) 'stripe_customer_id': stripeCustomerId,
      if (suscripcionAnterior != null) 'suscripcion_anterior': suscripcionAnterior,
      if (suscripcionNueva != null) 'suscripcion_nueva': suscripcionNueva,
      'fecha_transaccion': fechaTransaccion.toIso8601String(),
      if (fechaCompletado != null) 'fecha_completado': fechaCompletado!.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
      if (notas != null) 'notas': notas,
    };
  }

  bool get isPending => estado == 'pendiente';
  bool get isCompleted => estado == 'completado';
  bool get isFailed => estado == 'fallido';
  bool get isRefunded => estado == 'reembolsado';
}


class CheckoutSessionModel {
  final String transaccionId;
  final String checkoutUrl;
  final String sessionId;
  final DateTime expiresAt;

  const CheckoutSessionModel({
    required this.transaccionId,
    required this.checkoutUrl,
    required this.sessionId,
    required this.expiresAt,
  });

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionModel(
      transaccionId: json['transaccion_id'] as String,
      checkoutUrl: json['checkout_url'] as String,
      sessionId: json['session_id'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaccion_id': transaccionId,
      'checkout_url': checkoutUrl,
      'session_id': sessionId,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}


class CreateCheckoutRequest {
  final String usuarioId;
  final String plan; // 'pro_monthly' or 'pro_yearly'

  const CreateCheckoutRequest({
    required this.usuarioId,
    required this.plan,
  });

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'plan': plan,
    };
  }
}
