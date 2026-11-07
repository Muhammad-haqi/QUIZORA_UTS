import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/result_category.dart';
import '../providers/quiz_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_center.dart';
import '../widgets/score_card.dart';
import '../widgets/stat_tile.dart';
import '../widgets/theme_toggle_button.dart';

/// Halaman hasil kuis.
///
/// Nilai dibaca satu kali di initState dan disimpan sebagai salinan, sehingga
/// hasil yang tampil tidak berubah walaupun halaman dibangun ulang (misalnya
/// layar diputar atau tema diganti) dan tidak ikut ter-reset saat transisi.
class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final String _userName;
  late final int _score;
  late final int _maxScore;
  late final int _correct;
  late final int _wrong;
  late final int _percentage;
  late final ResultCategory _category;

  @override
  void initState() {
    super.initState();
    final quiz = QuizScope.read(context);
    _userName = quiz.userName;
    _score = quiz.score;
    _maxScore = quiz.maxScore;
    _correct = quiz.correctCount;
    _wrong = quiz.wrongCount;
    _percentage = quiz.percentage;
    _category = quiz.category;
  }

  /// Ulangi kuis: hapus jawaban dan skor, lalu kembali ke soal 1.
  void _retryQuiz() {
    QuizScope.read(context).reset();
    Navigator.of(context).pushReplacementNamed(AppRoutes.quiz);
  }

  /// Kembali ke beranda: hapus jawaban, nama tetap tersimpan di kolom input.
  void _backToHome() {
    final quiz = QuizScope.read(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    quiz.reset();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;

    // Ukuran gambar dan lingkaran skor menyesuaikan layar.
    final illustrationSize = (shortest * 0.32).clamp(100.0, 180.0).toDouble();
    final scoreSize = (shortest * 0.5).clamp(150.0, 240.0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          child: ResponsiveCenter(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/result_illustration.png',
                  width: illustrationSize,
                  height: illustrationSize,
                ),
                const SizedBox(height: 12),
                Text(
                  _category.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: _category.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat, $_userName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _category.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurface.withAlpha(170),
                  ),
                ),
                const SizedBox(height: 20),
                ScoreCard(
                  score: _score,
                  maxScore: _maxScore,
                  color: _category.color,
                  size: scoreSize,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        icon: Icons.check_circle_rounded,
                        label: 'Benar',
                        value: '$_correct',
                        color: const Color(0xFF2E9E5B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        icon: Icons.cancel_rounded,
                        label: 'Salah',
                        value: '$_wrong',
                        color: const Color(0xFFE5484D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        icon: Icons.percent_rounded,
                        label: 'Nilai',
                        value: '$_percentage%',
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'ULANGI KUIS',
                    icon: Icons.refresh_rounded,
                    onPressed: _retryQuiz,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'KEMBALI KE BERANDA',
                    icon: Icons.home_rounded,
                    isOutlined: true,
                    onPressed: _backToHome,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
