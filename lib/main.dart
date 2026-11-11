import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'providers/quiz_state.dart';
import 'providers/theme_state.dart';
import 'screens/home_page.dart';
import 'screens/quiz_page.dart';
import 'screens/result_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const QuizoraApp());
}

/// Widget akar aplikasi.
///
/// StatefulWidget dipakai agar [QuizState] dan [ThemeController] dibuat satu
/// kali dan tetap hidup selama aplikasi berjalan (tidak ikut ter-reset ketika
/// berpindah halaman atau layar diputar).
class QuizoraApp extends StatefulWidget {
  const QuizoraApp({super.key});

  @override
  State<QuizoraApp> createState() => _QuizoraAppState();
}

class _QuizoraAppState extends State<QuizoraApp> {
  final QuizState _quizState = QuizState();
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    // Muat pilihan tema yang tersimpan (jika ada).
    _themeController.load();
  }

  @override
  void dispose() {
    _quizState.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: QuizScope(
        state: _quizState,
        child: ListenableBuilder(
          listenable: _themeController,
          builder: (context, _) {
            return MaterialApp(
              title: 'QUIZORA',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _themeController.themeMode,
              initialRoute: AppRoutes.home,
              routes: {
                AppRoutes.home: (context) => const HomePage(),
                AppRoutes.quiz: (context) => const QuizPage(),
                AppRoutes.result: (context) => const ResultPage(),
              },
            );
          },
        ),
      ),
    );
  }
}
