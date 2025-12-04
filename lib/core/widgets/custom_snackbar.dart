import 'package:flutter/material.dart';

/// Tipos de alerta disponibles
enum AlertType {
  success,
  error,
  warning,
  info,
}

/// Sistema de alertas personalizadas para LexIA
/// Alertas atractivas con animaciones y colores de la paleta
class LexiaAlert {
  /// Muestra una alerta personalizada
  static void show({
    required BuildContext context,
    required String title,
    String? message,
    AlertType type = AlertType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
    bool showIcon = true,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedAlert(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onAction: onAction,
        actionLabel: actionLabel,
        showIcon: showIcon,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Alerta de éxito
  static void success(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: AlertType.success,
      duration: duration,
    );
  }

  /// Alerta de error
  static void error(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: AlertType.error,
      duration: duration,
    );
  }

  /// Alerta de advertencia
  static void warning(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: AlertType.warning,
      duration: duration,
    );
  }

  /// Alerta informativa
  static void info(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: AlertType.info,
      duration: duration,
    );
  }
}

class _AnimatedAlert extends StatefulWidget {
  final String title;
  final String? message;
  final AlertType type;
  final Duration duration;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showIcon;
  final VoidCallback onDismiss;

  const _AnimatedAlert({
    required this.title,
    this.message,
    required this.type,
    required this.duration,
    this.onAction,
    this.actionLabel,
    required this.showIcon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedAlert> createState() => _AnimatedAlertState();
}

class _AnimatedAlertState extends State<_AnimatedAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  bool _isHovering = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _progressAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _controller.forward();
    _startDismissTimer();
  }

  void _startDismissTimer() async {
    final totalMs = widget.duration.inMilliseconds;
    const updateInterval = 50;
    int elapsed = 0;

    while (elapsed < totalMs && mounted) {
      await Future.delayed(const Duration(milliseconds: updateInterval));
      if (!_isPaused && mounted) {
        elapsed += updateInterval;
        setState(() {
          _progressAnimation = AlwaysStoppedAnimation(1 - (elapsed / totalMs));
        });
      }
    }

    if (mounted && !_isPaused) {
      _dismiss();
    }
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    // Colores según el tipo de alerta
    final alertColors = _getAlertColors(isDark);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: isWide ? null : 16,
      right: isWide ? 24 : 16,
      width: isWide ? 400 : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovering = true;
              _isPaused = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovering = false;
              _isPaused = false;
            });
          },
          child: GestureDetector(
            onTap: _dismiss,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 100) {
                _dismiss();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: alertColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: alertColors.border,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: alertColors.shadow,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: alertColors.glow,
                      blurRadius: 40,
                      offset: const Offset(0, 4),
                      spreadRadius: -10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icono animado
                            if (widget.showIcon) ...[
                              _AnimatedIcon(
                                type: widget.type,
                                color: alertColors.icon,
                              ),
                              const SizedBox(width: 14),
                            ],
                            // Contenido
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: alertColors.title,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  if (widget.message != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.message!,
                                      style: TextStyle(
                                        color: alertColors.message,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Botón de acción o cerrar
                            if (widget.actionLabel != null && widget.onAction != null)
                              TextButton(
                                onPressed: () {
                                  widget.onAction!();
                                  _dismiss();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: alertColors.action,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  widget.actionLabel!,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            else
                              IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: alertColors.close,
                                ),
                                onPressed: _dismiss,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Barra de progreso
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, _) {
                          return Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: alertColors.progressBg,
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      alertColors.progressStart,
                                      alertColors.progressEnd,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AlertColors _getAlertColors(bool isDark) {
    switch (widget.type) {
      case AlertType.success:
        return isDark
            ? _AlertColors(
                background: const Color(0xFF1A2E1A),
                border: const Color(0xFF2E5A2E),
                icon: const Color(0xFF6BCB77),
                title: const Color(0xFFE8F5E9),
                message: const Color(0xFFB8E0BB),
                action: const Color(0xFF6BCB77),
                close: const Color(0xFF81C784),
                shadow: Colors.black.withValues(alpha: 0.3),
                glow: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                progressBg: const Color(0xFF1B3D1B),
                progressStart: const Color(0xFF4CAF50),
                progressEnd: const Color(0xFF81C784),
              )
            : _AlertColors(
                background: const Color(0xFFF1F8E9),
                border: const Color(0xFFC5E1A5),
                icon: const Color(0xFF43A047),
                title: const Color(0xFF1B5E20),
                message: const Color(0xFF33691E),
                action: const Color(0xFF43A047),
                close: const Color(0xFF66BB6A),
                shadow: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                glow: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                progressBg: const Color(0xFFDCEDC8),
                progressStart: const Color(0xFF66BB6A),
                progressEnd: const Color(0xFF43A047),
              );

      case AlertType.error:
        return isDark
            ? _AlertColors(
                background: const Color(0xFF2E1A1A),
                border: const Color(0xFF5A2E2E),
                icon: const Color(0xFFEF5350),
                title: const Color(0xFFFFEBEE),
                message: const Color(0xFFEF9A9A),
                action: const Color(0xFFEF5350),
                close: const Color(0xFFE57373),
                shadow: Colors.black.withValues(alpha: 0.3),
                glow: const Color(0xFFF44336).withValues(alpha: 0.2),
                progressBg: const Color(0xFF3D1B1B),
                progressStart: const Color(0xFFF44336),
                progressEnd: const Color(0xFFE57373),
              )
            : _AlertColors(
                background: const Color(0xFFFFF5F5),
                border: const Color(0xFFFFCDD2),
                icon: const Color(0xFFE53935),
                title: const Color(0xFFB71C1C),
                message: const Color(0xFFC62828),
                action: const Color(0xFFE53935),
                close: const Color(0xFFEF5350),
                shadow: const Color(0xFFF44336).withValues(alpha: 0.15),
                glow: const Color(0xFFF44336).withValues(alpha: 0.1),
                progressBg: const Color(0xFFFFEBEE),
                progressStart: const Color(0xFFEF5350),
                progressEnd: const Color(0xFFE53935),
              );

      case AlertType.warning:
        return isDark
            ? _AlertColors(
                background: const Color(0xFF2E2A1A),
                border: const Color(0xFF5A4E2E),
                icon: const Color(0xFFFFB74D),
                title: const Color(0xFFFFF8E1),
                message: const Color(0xFFFFE082),
                action: const Color(0xFFFFB74D),
                close: const Color(0xFFFFCA28),
                shadow: Colors.black.withValues(alpha: 0.3),
                glow: const Color(0xFFFF9800).withValues(alpha: 0.2),
                progressBg: const Color(0xFF3D361B),
                progressStart: const Color(0xFFFF9800),
                progressEnd: const Color(0xFFFFB74D),
              )
            : _AlertColors(
                background: const Color(0xFFFFFBF0),
                border: const Color(0xFFFFE0B2),
                icon: const Color(0xFFF57C00),
                title: const Color(0xFFE65100),
                message: const Color(0xFFF57C00),
                action: const Color(0xFFF57C00),
                close: const Color(0xFFFFB74D),
                shadow: const Color(0xFFFF9800).withValues(alpha: 0.15),
                glow: const Color(0xFFFF9800).withValues(alpha: 0.1),
                progressBg: const Color(0xFFFFECB3),
                progressStart: const Color(0xFFFFB74D),
                progressEnd: const Color(0xFFF57C00),
              );

      case AlertType.info:
        // Usar los colores de LexIA (terracota/beige)
        return isDark
            ? _AlertColors(
                background: const Color(0xFF2A231F),
                border: const Color(0xFF4A3F38),
                icon: const Color(0xFFE5A896),
                title: const Color(0xFFF5EDE8),
                message: const Color(0xFFD4C4BA),
                action: const Color(0xFFE5A896),
                close: const Color(0xFFD19A86),
                shadow: Colors.black.withValues(alpha: 0.3),
                glow: const Color(0xFFD19A86).withValues(alpha: 0.2),
                progressBg: const Color(0xFF352D28),
                progressStart: const Color(0xFFD19A86),
                progressEnd: const Color(0xFFE5A896),
              )
            : _AlertColors(
                background: const Color(0xFFFFFBF8),
                border: const Color(0xFFE8D9CE),
                icon: const Color(0xFFD19A86),
                title: const Color(0xFF3D2E28),
                message: const Color(0xFF5D4A42),
                action: const Color(0xFFD19A86),
                close: const Color(0xFFD19A86),
                shadow: const Color(0xFFD19A86).withValues(alpha: 0.15),
                glow: const Color(0xFFD19A86).withValues(alpha: 0.1),
                progressBg: const Color(0xFFF5EDE8),
                progressStart: const Color(0xFFE5A896),
                progressEnd: const Color(0xFFD19A86),
              );
    }
  }
}

class _AlertColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color title;
  final Color message;
  final Color action;
  final Color close;
  final Color shadow;
  final Color glow;
  final Color progressBg;
  final Color progressStart;
  final Color progressEnd;

  const _AlertColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
    required this.close,
    required this.shadow,
    required this.glow,
    required this.progressBg,
    required this.progressStart,
    required this.progressEnd,
  });
}

/// Icono animado según el tipo de alerta
class _AnimatedIcon extends StatefulWidget {
  final AlertType type;
  final Color color;

  const _AnimatedIcon({
    required this.type,
    required this.color,
  });

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotateAnimation = Tween<double>(begin: -0.1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getIconForType(widget.type),
          color: widget.color,
          size: 24,
        ),
      ),
    );
  }

  IconData _getIconForType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_rounded;
      case AlertType.error:
        return Icons.error_rounded;
      case AlertType.warning:
        return Icons.warning_rounded;
      case AlertType.info:
        return Icons.info_rounded;
    }
  }
}
