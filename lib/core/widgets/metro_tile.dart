import 'package:flutter/material.dart';

class MetroTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double height;
  final VoidCallback? onTap;

  const MetroTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    this.height = 140,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fg = ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black87;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: height * 0.45),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
