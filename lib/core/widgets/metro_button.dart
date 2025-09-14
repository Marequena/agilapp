import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';

enum MetroVariant { primary, success, danger, warning, neutral }
enum MetroSize { small, medium, large }

class MetroButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final MetroVariant variant;
  final MetroSize size;
  final bool fullWidth;

  const MetroButton({
    Key? key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = MetroVariant.primary,
    this.size = MetroSize.medium,
  this.fullWidth = false,
  }) : super(key: key);

  double get _height {
    switch (size) {
      case MetroSize.small:
        return 44;
      case MetroSize.large:
        return 72;
      default:
        return 56;
    }
  }

  Color _bgForVariant(BuildContext context) {
    switch (variant) {
      case MetroVariant.success:
        return Colors.green.shade600;
      case MetroVariant.danger:
        return Colors.red.shade600;
      case MetroVariant.warning:
        return Colors.orange.shade600;
      case MetroVariant.neutral:
        return Theme.of(context).colorScheme.surface;
      case MetroVariant.primary:
      default:
        return ColorTokens.primary;
    }
  }

  Color _fgForVariant(BuildContext context) {
    final bg = _bgForVariant(context);
    return ThemeData.estimateBrightnessForColor(bg) == Brightness.dark ? Colors.white : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgForVariant(context);
    final fg = _fgForVariant(context);
    final child = Material(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: fullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: fg, size: _height * 0.45),
                const SizedBox(width: 12),
              ],
              Flexible(child: Text(label, style: TextStyle(color: fg, fontSize: _height * 0.28, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      height: _height,
      width: fullWidth ? double.infinity : null,
      child: child,
    );
  }
}
