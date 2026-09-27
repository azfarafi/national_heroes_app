import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:national_heroes_app/main.dart';
import 'package:national_heroes_app/services/api_service.dart';

void main() {
  testWidgets('Dashboard menampilkan data dari API',
      (WidgetTester tester) async {
    ApiService.instance = ApiService(
      client: MockClient((request) async => _json(
            ([
              {
                'id': 1,
                'name': 'Ir. Soekarno',
                'origin': 'Blitar, Jawa Timur',
                'life_time': '1901 – 1970',
                'description': 'Presiden pertama.',
                'image_path': '',
              }
            ]),
            200,
          )),
    );

    await tester.pumpWidget(const NationalHeroesApp());
    await tester.pumpAndSettle();

    expect(find.text('NATIONAL HEROES OF INDONESIA'), findsOneWidget);
    expect(find.text('LIST PAHLAWAN NASIONAL INDONESIA'), findsOneWidget);
    expect(find.text('Tambah Pahlawan'), findsOneWidget);
    expect(find.text('IR. SOEKARNO'), findsOneWidget);
  });
}

/// Respons JSON UTF-8, sama seperti yang dikirim API PHP.
http.Response _json(Object data, int status) => http.Response.bytes(
      utf8.encode(jsonEncode(data)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
