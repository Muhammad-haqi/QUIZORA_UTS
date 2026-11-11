import 'package:flutter/material.dart';

/// Tombol umum QUIZORA. [isOutlined] true = tombol bergaris (aksi sekunder).
/// Jika [onPressed] null maka tombol nonaktif.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    const padding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
    const minimumSize = Size(0, 52);

    // FittedBox mengecilkan teks otomatis jika layar terlalu sempit.
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          minimumSize: minimumSize,
          shape: shape,
          foregroundColor: scheme.primary,
          side: BorderSide(
            color: onPressed == null
                ? scheme.onSurface.withAlpha(40)
                : scheme.primary,
            width: 1.5,
          ),
        ),
        child: content,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        minimumSize: minimumSize,
        shape: shape,
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      child: content,
    );
  }
}
