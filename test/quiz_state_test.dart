import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/models/result_category.dart';
import 'package:quizora/providers/quiz_state.dart';

/// Menjawab semua soal. [correctCount] soal pertama dijawab benar,
/// sisanya dijawab salah.
void answerQuestions(QuizState state, {required int correctCount}) {
  for (var i = 0; i < state.totalQuestions; i++) {
    state.goTo(i);
    final right = state.questions[i].correctIndex;
    final wrong = (right + 1) % state.questions[i].options.length;
    state.selectAnswer(i < correctCount ? right : wrong);
  }
}

void main() {
  group('Perhitungan skor', () {
    test('semua jawaban benar -> skor 100', () {
      final state = QuizState();
      answerQuestions(state, correctCount: 10);

      expect(state.correctCount, 10);
      expect(state.wrongCount, 0);
      expect(state.score, 100);
      expect(state.maxScore, 100);
      expect(state.percentage, 100);
    });

    test('semua jawaban salah -> skor 0', () {
      final state = QuizState();
      answerQuestions(state, correctCount: 0);

      expect(state.correctCount, 0);
      expect(state.wrongCount, 10);
      expect(state.score, 0);
      expect(state.percentage, 0);
    });

    test('7 benar dan 3 salah -> skor 70', () {
      final state = QuizState();
      answerQuestions(state, correctCount: 7);

      expect(state.correctCount, 7);
      expect(state.wrongCount, 3);
      expect(state.score, 70);
      expect(state.percentage, 70);
    });

    test('setiap jawaban benar bernilai 10 poin', () {
      final state = QuizState();
      state.goTo(0);
      state.selectAnswer(state.currentQuestion.correctIndex);
      expect(state.score, 10);

      state.goTo(1);
      state.selectAnswer(state.currentQuestion.correctIndex);
      expect(state.score, 20);
    });
  });

  group('Jawaban tersimpan', () {
    test('jawaban tetap ada saat pindah soal', () {
      final state = QuizState();
      state.selectAnswer(2);
      state.next();
      state.selectAnswer(1);
      state.previous();

      expect(state.currentIndex, 0);
      expect(state.answerFor(0), 2);
      expect(state.answerFor(1), 1);
    });

    test('jawaban dapat diubah (hanya satu jawaban per soal)', () {
      final state = QuizState();
      state.selectAnswer(0);
      state.selectAnswer(3);

      expect(state.answerFor(0), 3);
      expect(state.answeredCount, 1);
    });

    test('pilihan di luar rentang diabaikan', () {
      final state = QuizState();
      state.selectAnswer(4);
      state.selectAnswer(-1);

      expect(state.answerFor(0), isNull);
    });

    test('tombol previous/next tidak keluar dari rentang soal', () {
      final state = QuizState();
      state.previous();
      expect(state.currentIndex, 0);

      state.goTo(state.totalQuestions - 1);
      state.next();
      expect(state.currentIndex, state.totalQuestions - 1);
      expect(state.isLast, isTrue);
    });
  });

  group('Menyelesaikan kuis', () {
    test('tidak bisa selesai jika masih ada soal kosong', () {
      final state = QuizState();
      state.selectAnswer(0);

      expect(state.isAllAnswered, isFalse);
      expect(state.finish(), isFalse);
      expect(state.isFinished, isFalse);
    });

    test('firstUnansweredIndex menunjuk soal kosong pertama', () {
      final state = QuizState();
      state.selectAnswer(0); // soal 1
      state.goTo(1);
      state.selectAnswer(0); // soal 2
      // soal 3 (indeks 2) masih kosong
      expect(state.firstUnansweredIndex, 2);
    });

    test('bisa selesai jika semua soal sudah dijawab', () {
      final state = QuizState();
      answerQuestions(state, correctCount: 5);

      expect(state.firstUnansweredIndex, -1);
      expect(state.finish(), isTrue);
      expect(state.isFinished, isTrue);
    });
  });

  group('Reset dan mulai ulang', () {
    test('reset menghapus jawaban dan skor tapi menyimpan nama', () {
      final state = QuizState();
      state.startQuiz('  Budi  ');
      answerQuestions(state, correctCount: 10);
      state.finish();

      state.reset();

      expect(state.userName, 'Budi');
      expect(state.answeredCount, 0);
      expect(state.score, 0);
      expect(state.currentIndex, 0);
      expect(state.isFinished, isFalse);
    });

    test('startQuiz mempertahankan progres jika kuis belum selesai', () {
      final state = QuizState();
      state.startQuiz('Ani');
      state.selectAnswer(1);
      state.next();

      state.startQuiz('Ani');

      expect(state.answerFor(0), 1);
      expect(state.currentIndex, 1);
      expect(state.hasProgress, isTrue);
    });

    test('startQuiz menghapus jawaban lama jika kuis sudah selesai', () {
      final state = QuizState();
      state.startQuiz('Ani');
      answerQuestions(state, correctCount: 10);
      state.finish();

      state.startQuiz('Ani');

      expect(state.answeredCount, 0);
      expect(state.isFinished, isFalse);
    });
  });

  group('Kategori hasil', () {
    test('90 - 100 -> Excellent!', () {
      expect(ResultCategory.fromScore(100).title, 'Excellent!');
      expect(ResultCategory.fromScore(90).title, 'Excellent!');
    });

    test('70 - 89 -> Good Job! (termasuk 81 - 89)', () {
      expect(ResultCategory.fromScore(89).title, 'Good Job!');
      expect(ResultCategory.fromScore(81).title, 'Good Job!');
      expect(ResultCategory.fromScore(80).title, 'Good Job!');
      expect(ResultCategory.fromScore(70).title, 'Good Job!');
    });

    test('50 - 69 -> Keep Learning!', () {
      expect(ResultCategory.fromScore(69).title, 'Keep Learning!');
      expect(ResultCategory.fromScore(60).title, 'Keep Learning!');
      expect(ResultCategory.fromScore(50).title, 'Keep Learning!');
    });

    test('0 - 49 -> Try Again!', () {
      expect(ResultCategory.fromScore(49).title, 'Try Again!');
      expect(ResultCategory.fromScore(40).title, 'Try Again!');
      expect(ResultCategory.fromScore(0).title, 'Try Again!');
    });

    test('kategori pada QuizState mengikuti nilai', () {
      final state = QuizState();
      answerQuestions(state, correctCount: 8);
      expect(state.category.title, 'Good Job!');
    });
  });
}
