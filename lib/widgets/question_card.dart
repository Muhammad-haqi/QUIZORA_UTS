import 'package:flutter/material.dart';

import 'app_card.dart';

/// Kartu yang menampilkan nomor dan teks pertanyaan.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.number,
    required this.question,
  });

  final int number;
  final String question;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Ukuran teks menyesuaikan lebar layar (MediaQuery).
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 16.0 : 18.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.primary.withAlpha(28),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.help_outline_rounded, size: 16, color: scheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Pertanyaan $number',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            question,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: 1.45,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
