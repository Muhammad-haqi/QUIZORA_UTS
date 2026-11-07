import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../providers/quiz_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_widget.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_option.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';

/// Halaman untuk mengerjakan 10 soal pilihan ganda.
///
/// Jawaban TIDAK disimpan di widget ini, melainkan di [QuizState] (di atas
/// MaterialApp), sehingga tidak hilang saat pindah soal, pindah halaman, atau
/// layar diputar. StatefulWidget dipakai untuk mengelola ScrollController.
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const List<String> _letters = ['A', 'B', 'C', 'D'];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Menggulung daftar soal ke atas setiap kali pindah soal.
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _goNext(QuizState quiz) {
    quiz.next();
    _scrollToTop();
  }

  void _goPrevious(QuizState quiz) {
    quiz.previous();
    _scrollToTop();
  }

  Future<void> _finishQuiz() async {
    final quiz = QuizScope.read(context);

    // 1. Pastikan semua soal sudah dijawab.
    if (!quiz.isAllAnswered) {
      final firstEmpty = quiz.firstUnansweredIndex;
      quiz.goTo(firstEmpty);
      _scrollToTop();
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Masih ada soal yang belum dijawab. '
            'Kamu diarahkan ke soal ${firstEmpty + 1}.',
          ),
        ),
      );
      return;
    }

    // 2. Minta konfirmasi sebelum menyelesaikan kuis.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Selesaikan kuis?'),
          content: Text(
            'Semua soal sudah dijawab. Yakin ingin menyelesaikan kuis '
            'sekarang, ${quiz.userName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Periksa lagi'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Ya, selesaikan'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    // 3. Tandai selesai lalu buka halaman hasil.
    if (quiz.finish()) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = QuizScope.of(context);
    final question = quiz.currentQuestion;
    final selected = quiz.answerFor(quiz.currentIndex);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QUIZORA'),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            children: [
              const SizedBox(height: 4),
              // Nama pengguna.
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 20, color: scheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      quiz.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Indikator "Soal x dari 10" + progress bar.
              ProgressIndicatorWidget(
                current: quiz.currentIndex + 1,
                total: quiz.totalQuestions,
                answered: quiz.answeredCount,
              ),
              const SizedBox(height: 16),
              // Area soal dan pilihan jawaban (bisa digulir).
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      QuestionCard(
                        number: quiz.currentIndex + 1,
                        question: question.question,
                      ),
                      const SizedBox(height: 16),
                      for (var i = 0; i < question.options.length; i++)
                        QuizOption(
                          letter: _letters[i],
                          text: question.options[i],
                          isSelected: selected == i,
                          onTap: () => quiz.selectAnswer(i),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tombol navigasi soal.
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'SOAL SEBELUMNYA',
                        icon: Icons.arrow_back_rounded,
                        isOutlined: true,
                        onPressed: quiz.isFirst ? null : () => _goPrevious(quiz),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: quiz.isLast
                          ? CustomButton(
                              label: 'SELESAIKAN KUIS',
                              icon: Icons.flag_rounded,
                              onPressed: _finishQuiz,
                            )
                          : CustomButton(
                              label: 'SELANJUTNYA',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () => _goNext(quiz),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
