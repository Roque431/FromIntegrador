import 'package:flutter/material.dart';

/// Widget de botón responsivo que se adapta a temas claro/oscuro
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isOutlined;

  const ResponsiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.style,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(colorScheme.primary),
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style ?? FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _buildChild(null),
    );
  }

  Widget _buildChild(Color? textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: textColor != null
                  ? TextStyle(color: textColor, fontWeight: FontWeight.w600)
                  : const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: textColor != null
          ? TextStyle(color: textColor, fontWeight: FontWeight.w600)
          : const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

/// Widget de card responsivo que se adapta a temas claro/oscuro
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      elevation: elevation ?? (isDark ? 4 : 6),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.1),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

/// Helper class para obtener tamaños responsivos
class ResponsiveSize {
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  /// Retorna el padding horizontal según el tamaño de pantalla
  static double horizontalPadding(BuildContext context) {
    if (isLargeDesktop(context)) return 48;
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    if (isSmallMobile(context)) return 12;
    return 16;
  }

  /// Retorna el padding vertical según el tamaño de pantalla
  static double verticalPadding(BuildContext context) {
    if (isDesktop(context)) return 40;
    if (isTablet(context)) return 32;
    return 24;
  }

  /// Retorna el ancho máximo para contenedores de formulario
  static double maxFormWidth(BuildContext context) {
    if (isLargeDesktop(context)) return 500;
    if (isDesktop(context)) return 450;
    if (isTablet(context)) return 420;
    return double.infinity;
  }

  /// Retorna el espaciado entre elementos según el tamaño de pantalla
  static double spacing(BuildContext context, {double base = 16}) {
    if (isDesktop(context)) return base * 1.5;
    if (isTablet(context)) return base * 1.25;
    return base;
  }
}
