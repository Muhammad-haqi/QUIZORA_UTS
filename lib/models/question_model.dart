/// Model data untuk satu pertanyaan pilihan ganda.
class QuestionModel {
  const QuestionModel({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  /// Jumlah pilihan jawaban yang wajib ada pada setiap soal (A, B, C, D).
  static const int optionCount = 4;

  /// Teks pertanyaan.
  final String question;

  /// Daftar pilihan jawaban (harus tepat 4).
  final List<String> options;

  /// Indeks jawaban yang benar (0 = A, 1 = B, 2 = C, 3 = D).
  final int correctIndex;

  /// Mengecek apakah jawaban yang dipilih benar.
  /// [selectedIndex] bernilai null jika soal belum dijawab.
  bool isCorrect(int? selectedIndex) {
    return selectedIndex != null && selectedIndex == correctIndex;
  }

  /// Soal dianggap valid jika punya tepat 4 pilihan dan indeks jawaban benar
  /// berada di dalam rentang pilihan.
  bool get isValid {
    return options.length == optionCount &&
        correctIndex >= 0 &&
        correctIndex < options.length;
  }
}
