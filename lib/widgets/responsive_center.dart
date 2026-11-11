import 'package:flutter/material.dart';

/// Membatasi lebar konten agar tetap proporsional di tablet / layar besar,
/// dan memberi jarak samping yang menyesuaikan lebar layar (LayoutBuilder).
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Layar sempit (HP kecil) memakai jarak samping lebih kecil.
        final horizontalPadding = constraints.maxWidth < 360 ? 16.0 : 24.0;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
