import 'package:flutter/material.dart';

import 'app_card.dart';

/// Kartu skor akhir: angka besar di tengah lingkaran progres.
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.score,
    required this.maxScore,
    required this.color,
    required this.size,
  });

  final int score;
  final int maxScore;
  final Color color;

  /// Diameter lingkaran skor (dihitung dari ukuran layar oleh pemanggil).
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = maxScore == 0 ? 0.0 : score / maxScore;

    return AppCard(
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: size * 0.07,
                      backgroundColor: color.withAlpha(40),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size * 0.16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: size * 0.34,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: color,
                        ),
                      ),
                      Text(
                        'dari $maxScore',
                        style: TextStyle(
                          fontSize: size * 0.1,
                          fontWeight: FontWeight.w500,
                          color: scheme.onSurface.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
