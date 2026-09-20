import 'package:flutter_test/flutter_test.dart';
import 'package:national_heroes_app/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Rendernya aplikasi utama
    await tester.pumpWidget(const NationalHeroesApp());

    // Memastikan judul "National Heroes of Indonesia" muncul di layar
    expect(find.text('National Heroes of Indonesia'), findsOneWidget);

    // Memastikan judul daftar pahlawan muncul
    expect(find.text('List Pahlawan Nasional Indonesia'), findsOneWidget);
  });
}