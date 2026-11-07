import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import '../providers/quiz_state.dart';
import '../widgets/app_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_chip.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';

/// Halaman beranda: logo, deskripsi, input nama, dan tombol mulai kuis.
/// StatefulWidget dipakai karena halaman ini mengelola input teks (controller)
/// dan validasi form.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Jika pengguna kembali dari halaman hasil, nama sebelumnya terisi lagi.
    _nameController = TextEditingController(text: QuizScope.read(context).userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Nama wajib diisi sebelum memulai kuis';
    }
    if (name.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  void _startQuiz() {
    // Jangan lanjut jika nama kosong / tidak valid.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    QuizScope.read(context).startQuiz(_nameController.text);
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushNamed(AppRoutes.quiz);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = QuizScope.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Layar lebar (tablet / landscape): hero di kiri, form di kanan.
            final isWide = constraints.maxWidth >= 700;
            final illustrationSize =
                (screenSize.shortestSide * (isWide ? 0.5 : 0.48))
                    .clamp(150.0, 300.0)
                    .toDouble();

            final hero = _buildHero(context, illustrationSize);
            final form = _buildForm(context, quiz);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: ResponsiveCenter(
                maxWidth: isWide ? 1000 : 560,
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: hero),
                          const SizedBox(width: 24),
                          Expanded(child: form),
                        ],
                      )
                    : Column(
                        children: [
                          hero,
                          const SizedBox(height: 20),
                          form,
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Bagian atas: ilustrasi, judul, deskripsi, dan info singkat.
  Widget _buildHero(BuildContext context, double illustrationSize) {
    final scheme = Theme.of(context).colorScheme;
    final totalQuestions = QuizScope.read(context).totalQuestions;

    return Column(
      children: [
        Image.asset(
          'assets/images/quiz_illustration.png',
          width: illustrationSize,
          height: illustrationSize,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_alt_rounded, color: scheme.primary, size: 32),
            const SizedBox(width: 8),
            Text(
              'QUIZORA',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Uji pengetahuan umummu lewat kuis pilihan ganda yang seru. '
          'Jawab semua soal dan lihat skor akhirmu!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: scheme.onSurface.withAlpha(180),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            InfoChip(icon: Icons.quiz_rounded, label: '$totalQuestions Soal'),
            const InfoChip(icon: Icons.list_alt_rounded, label: 'Pilihan Ganda'),
            const InfoChip(icon: Icons.emoji_events_rounded, label: 'Skor 100'),
          ],
        ),
      ],
    );
  }

  /// Bagian bawah: kartu input nama dan tombol mulai.
  Widget _buildForm(BuildContext context, QuizState quiz) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Siapa namamu?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Nama akan ditampilkan di halaman kuis dan hasil.',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withAlpha(160),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              validator: _validateName,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              onFieldSubmitted: (_) => _startQuiz(),
              decoration: const InputDecoration(
                labelText: 'Nama kamu',
                hintText: 'Contoh: Budi',
                prefixIcon: Icon(Icons.person_rounded),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: quiz.hasProgress ? 'LANJUTKAN KUIS' : 'MULAI KUIS',
                icon: Icons.play_arrow_rounded,
                onPressed: _startQuiz,
              ),
            ),
            if (quiz.hasProgress) ...[
              const SizedBox(height: 8),
              Text(
                'Kuis sebelumnya belum selesai '
                '(${quiz.answeredCount}/${quiz.totalQuestions} terjawab).',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withAlpha(160),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
