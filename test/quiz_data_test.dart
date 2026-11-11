import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/data/quiz_data.dart';
import 'package:quizora/models/question_model.dart';

void main() {
  group('Data soal', () {
    test('jumlah soal tepat 10', () {
      expect(quizQuestions.length, 10);
    });

    test('setiap soal memiliki tepat 4 pilihan jawaban', () {
      for (final q in quizQuestions) {
        expect(q.options.length, QuestionModel.optionCount,
            reason: 'Soal "${q.question}" harus punya 4 pilihan');
      }
    });

    test('setiap soal memiliki satu indeks jawaban benar yang valid', () {
      for (final q in quizQuestions) {
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.isValid, isTrue);
      }
    });

    test('teks soal dan pilihan tidak kosong, pilihan tidak ada yang kembar', () {
      for (final q in quizQuestions) {
        expect(q.question.trim(), isNotEmpty);
        for (final option in q.options) {
          expect(option.trim(), isNotEmpty);
        }
        expect(q.options.toSet().length, q.options.length,
            reason: 'Pilihan pada "${q.question}" tidak boleh kembar');
      }
    });
  });

  group('QuestionModel.isCorrect', () {
    const question = QuestionModel(
      question: 'Contoh?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 2,
    );

    test('jawaban benar dikenali', () {
      expect(question.isCorrect(2), isTrue);
    });

    test('jawaban salah dikenali', () {
      expect(question.isCorrect(0), isFalse);
      expect(question.isCorrect(3), isFalse);
    });

    test('soal yang belum dijawab (null) dianggap salah', () {
      expect(question.isCorrect(null), isFalse);
    });
  });
}
