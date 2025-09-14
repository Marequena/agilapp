import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outline;

  const AppButton({Key? key, required this.label, this.onPressed, this.outline = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (outline) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: DesignColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
    );
  }
}
