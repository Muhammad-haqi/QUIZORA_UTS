import 'package:flutter/material.dart';

/// Indikator "Soal 1 dari 10" dan progress bar yang bergerak mengikuti
/// nomor soal. [answered] menunjukkan jumlah soal yang sudah dijawab.
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.current,
    required this.total,
    required this.answered,
  });

  /// Nomor soal yang sedang tampil (mulai dari 1).
  final int current;
  final int total;
  final int answered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = total == 0 ? 0.0 : current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Soal $current dari $total',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            Text(
              'Terjawab $answered/$total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface.withAlpha(160),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(milliseconds: 350),
            builder: (context, animatedValue, _) {
              return LinearProgressIndicator(
                value: animatedValue,
                minHeight: 10,
                backgroundColor: scheme.onSurface.withAlpha(25),
                valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
              );
            },
          ),
        ),
      ],
    );
  }
}
