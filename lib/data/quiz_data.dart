import '../models/question_model.dart';

/// Daftar 10 soal pengetahuan umum. Disimpan secara lokal (tanpa database).
/// correctIndex: 0 = A, 1 = B, 2 = C, 3 = D.
const List<QuestionModel> quizQuestions = [
  QuestionModel(
    question: 'Planet yang paling dekat dengan Matahari adalah...',
    options: ['Venus', 'Merkurius', 'Mars', 'Bumi'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Siapakah presiden pertama Republik Indonesia?',
    options: ['Mohammad Hatta', 'Soeharto', 'Soekarno', 'B.J. Habibie'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'Hasil dari 12 × 8 adalah...',
    options: ['96', '86', '106', '108'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'Samudra manakah yang paling luas di dunia?',
    options: ['Atlantik', 'Hindia', 'Arktik', 'Pasifik'],
    correctIndex: 3,
  ),
  QuestionModel(
    question: 'Rumus kimia untuk air adalah...',
    options: ['CO2', 'H2O', 'O2', 'NaCl'],
    correctIndex: 1,
  ),
  QuestionModel(
    question:
        'Reptil raksasa yang menjadi ikon Nusa Tenggara Timur dan hidup di Pulau Komodo adalah...',
    options: ['Biawak Komodo', 'Kasuari', 'Cenderawasih', 'Orangutan'],
    correctIndex: 0,
  ),
  QuestionModel(
    question: 'Bahasa pemrograman yang digunakan pada framework Flutter adalah...',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  QuestionModel(
    question: 'Indonesia memproklamasikan kemerdekaannya pada tahun...',
    options: ['1928', '1942', '1949', '1945'],
    correctIndex: 3,
  ),
  QuestionModel(
    question: 'Benua yang paling luas di dunia adalah...',
    options: ['Afrika', 'Asia', 'Eropa', 'Amerika Utara'],
    correctIndex: 1,
  ),
  QuestionModel(
    question: 'Ibu kota negara Jepang adalah...',
    options: ['Osaka', 'Kyoto', 'Tokyo', 'Seoul'],
    correctIndex: 2,
  ),
];
