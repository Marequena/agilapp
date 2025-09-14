import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../utils/color_contrast.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;

  const AppButton({Key? key, required this.label, this.onPressed, this.variant = AppButtonVariant.primary, this.size = AppButtonSize.medium, this.icon}) : super(key: key);

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.large:
        return 56;
      default:
        return 44;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.outline:
        return SizedBox(
          height: _height,
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignColors.cornerRadius))),
          ),
        );
      case AppButtonVariant.ghost:
        return SizedBox(
          height: _height,
          child: TextButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          height: _height,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: highContrastColor(DesignColors.secondary))),
            style: ElevatedButton.styleFrom(backgroundColor: DesignColors.secondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignColors.cornerRadius))),
          ),
        );
      case AppButtonVariant.primary:
      default:
        final bg = Theme.of(context).colorScheme.primary;
        return SizedBox(
          height: _height,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18, color: highContrastColor(bg)) : const SizedBox.shrink(),
            label: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: highContrastColor(bg))),
            style: ElevatedButton.styleFrom(backgroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignColors.cornerRadius))),
          ),
        );
    }
  }
}
