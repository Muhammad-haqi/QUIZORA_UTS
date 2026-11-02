import 'package:flutter/widgets.dart';

import '../data/quiz_data.dart';
import '../models/question_model.dart';
import '../models/result_category.dart';

/// Menyimpan seluruh state kuis: nama pengguna, soal aktif, jawaban, dan skor.
///
/// State ini dibuat SATU KALI di atas MaterialApp (lihat main.dart), sehingga
/// jawaban tidak hilang ketika berpindah halaman atau layar diputar.
class QuizState extends ChangeNotifier {
  QuizState({List<QuestionModel>? questions})
      : questions = questions ?? quizQuestions {
    _answers = List<int?>.filled(this.questions.length, null);
  }

  /// Poin untuk setiap jawaban benar. Jawaban salah = 0 poin.
  static const int pointsPerCorrect = 10;

  final List<QuestionModel> questions;

  // Jawaban pengguna per soal. null = belum dijawab, 0..3 = pilihan A..D.
  late List<int?> _answers;
  String _userName = '';
  int _currentIndex = 0;
  bool _isFinished = false;

  // ---------------------------------------------------------------- Getter

  String get userName => _userName;
  int get currentIndex => _currentIndex;
  int get totalQuestions => questions.length;
  QuestionModel get currentQuestion => questions[_currentIndex];
  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == totalQuestions - 1;
  bool get isFinished => _isFinished;

  /// Jawaban pada soal ke-[index] (null jika belum dijawab).
  int? answerFor(int index) => _answers[index];

  /// Jumlah soal yang sudah dijawab.
  int get answeredCount => _answers.where((a) => a != null).length;

  /// True jika seluruh soal sudah dijawab.
  bool get isAllAnswered => answeredCount == totalQuestions;

  /// Indeks soal pertama yang belum dijawab, atau -1 jika semua sudah dijawab.
  int get firstUnansweredIndex => _answers.indexWhere((a) => a == null);

  /// True jika ada kuis yang sedang dikerjakan (sudah ada jawaban, belum selesai).
  bool get hasProgress => answeredCount > 0 && !_isFinished;

  // ---------------------------------------------------------------- Penilaian

  /// Jumlah jawaban benar.
  int get correctCount {
    var count = 0;
    for (var i = 0; i < totalQuestions; i++) {
      if (questions[i].isCorrect(_answers[i])) count++;
    }
    return count;
  }

  /// Jumlah jawaban salah (soal yang tidak dijawab juga dihitung salah).
  int get wrongCount => totalQuestions - correctCount;

  /// Skor akhir: setiap jawaban benar bernilai 10 poin.
  int get score => correctCount * pointsPerCorrect;

  /// Skor maksimal (10 soal x 10 poin = 100).
  int get maxScore => totalQuestions * pointsPerCorrect;

  /// Persentase nilai (0 - 100).
  int get percentage => (correctCount * 100 / totalQuestions).round();

  /// Kategori hasil (Excellent!, Good Job!, dst.).
  ResultCategory get category => ResultCategory.fromScore(percentage);

  // ---------------------------------------------------------------- Aksi

  /// Dipanggil dari halaman beranda saat tombol mulai ditekan.
  /// Jika kuis sebelumnya sudah selesai, jawaban dihapus. Jika kuis belum
  /// selesai, progres tetap dipertahankan (hanya nama yang diperbarui).
  void startQuiz(String name) {
    if (_isFinished) {
      _clearAnswers();
    }
    _userName = name.trim();
    notifyListeners();
  }

  /// Memilih jawaban untuk soal yang sedang tampil.
  void selectAnswer(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= currentQuestion.options.length) {
      return;
    }
    _answers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (isLast) return;
    _currentIndex++;
    notifyListeners();
  }

  void previous() {
    if (isFirst) return;
    _currentIndex--;
    notifyListeners();
  }

  /// Pindah langsung ke soal ke-[index].
  void goTo(int index) {
    if (index < 0 || index >= totalQuestions) return;
    _currentIndex = index;
    notifyListeners();
  }

  /// Menyelesaikan kuis. Mengembalikan false jika masih ada soal kosong.
  bool finish() {
    if (!isAllAnswered) return false;
    _isFinished = true;
    notifyListeners();
    return true;
  }

  /// Mengatur ulang seluruh jawaban dan skor. Nama pengguna tetap disimpan.
  void reset() {
    _clearAnswers();
    notifyListeners();
  }

  void _clearAnswers() {
    _answers = List<int?>.filled(totalQuestions, null);
    _currentIndex = 0;
    _isFinished = false;
  }
}

/// Membagikan [QuizState] ke seluruh widget di bawahnya (tanpa package luar).
class QuizScope extends InheritedNotifier<QuizState> {
  const QuizScope({
    super.key,
    required QuizState state,
    required super.child,
  }) : super(notifier: state);

  /// Mengambil state DAN ikut membangun ulang widget saat state berubah.
  static QuizState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<QuizScope>();
    assert(scope != null, 'QuizScope tidak ditemukan di widget tree.');
    return scope!.notifier!;
  }

  /// Mengambil state tanpa ikut membangun ulang (untuk initState / handler).
  static QuizState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<QuizScope>();
    assert(scope != null, 'QuizScope tidak ditemukan di widget tree.');
    return scope!.notifier!;
  }
}
