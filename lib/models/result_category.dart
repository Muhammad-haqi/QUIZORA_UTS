import 'package:flutter/material.dart';

/// Kategori hasil kuis berdasarkan nilai (0 - 100).
///
/// 90 - 100 : Excellent!
/// 70 - 89  : Good Job!        (mencakup 70-80 dan 81-89)
/// 50 - 69  : Keep Learning!   (mencakup 50-60 dan 61-69)
/// 0  - 49  : Try Again!       (mencakup 0-40 dan 41-49)
class ResultCategory {
  const ResultCategory({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;

  static const ResultCategory excellent = ResultCategory(
    title: 'Excellent!',
    message: 'Luar biasa! Pengetahuanmu sangat hebat.',
    icon: Icons.emoji_events_rounded,
    color: Color(0xFF2E9E5B),
  );

  static const ResultCategory good = ResultCategory(
    title: 'Good Job!',
    message: 'Kerja bagus! Sedikit lagi menuju sempurna.',
    icon: Icons.thumb_up_rounded,
    color: Color(0xFF3F7BFF),
  );

  static const ResultCategory keepLearning = ResultCategory(
    title: 'Keep Learning!',
    message: 'Terus belajar, kamu pasti bisa lebih baik.',
    icon: Icons.menu_book_rounded,
    color: Color(0xFFF59E0B),
  );

  static const ResultCategory tryAgain = ResultCategory(
    title: 'Try Again!',
    message: 'Jangan menyerah, coba lagi ya!',
    icon: Icons.refresh_rounded,
    color: Color(0xFFE5484D),
  );

  /// Menentukan kategori dari nilai 0 - 100.
  static ResultCategory fromScore(int score) {
    if (score >= 90) return excellent;
    if (score >= 70) return good;
    if (score >= 50) return keepLearning;
    return tryAgain;
  }
}
