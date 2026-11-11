import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // Data palsu untuk shared_preferences agar tes tidak butuh perangkat.
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('beranda menampilkan judul dan tombol mulai', (tester) async {
    await tester.pumpWidget(const QuizoraApp());
    await tester.pumpAndSettle();

    expect(find.text('QUIZORA'), findsOneWidget);
    expect(find.text('MULAI KUIS'), findsOneWidget);
  });

  testWidgets('nama kosong menampilkan pesan validasi', (tester) async {
    await tester.pumpWidget(const QuizoraApp());
    await tester.pumpAndSettle();

    final button = find.text('MULAI KUIS');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Nama wajib diisi sebelum memulai kuis'), findsOneWidget);
    expect(find.text('Soal 1 dari 10'), findsNothing);
  });

  testWidgets('nama terisi membuka halaman kuis', (tester) async {
    await tester.pumpWidget(const QuizoraApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Budi');
    final button = find.text('MULAI KUIS');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(find.text('SELANJUTNYA'), findsOneWidget);
  });
}
