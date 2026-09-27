import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:national_heroes_app/models/hero_model.dart';
import 'package:national_heroes_app/services/api_service.dart';

const _hero = {
  'id': 7,
  'name': 'Ki Hajar Dewantara',
  'origin': 'Yogyakarta',
  'life_time': '1889 – 1959',
  'description': 'Bapak Pendidikan Nasional.',
  'image_path': 'assets/images/ki_hajar_dewantara.jpg',
};

void main() {
  late List<http.Request> requests;

  ApiService api(http.Response Function(http.Request) handler) {
    requests = [];
    return ApiService(
      baseUrl: 'http://api.test',
      client: MockClient((request) async {
        requests.add(request);
        return handler(request);
      }),
    );
  }

  test('getHeroes memetakan JSON ke HeroModel', () async {
    final heroes = await api((_) => _json(([_hero]), 200)).getHeroes();
    expect(heroes.single.lifeTime, '1889 – 1959');
    expect(requests.single.url.toString(), 'http://api.test/heroes.php');
  });

  test('updateHero mengirim PUT dengan id dan body JSON', () async {
    final updated = await api((_) => _json((_hero), 200))
        .updateHero(HeroModel.fromMap(_hero));
    expect(updated.id, 7);
    expect(requests.single.method, 'PUT');
    expect(requests.single.url.queryParameters['id'], '7');
    expect(jsonDecode(requests.single.body)['life_time'], '1889 – 1959');
  });

  test('komentar: tambah dan baca tanggal dari MySQL', () async {
    final comment = await api((_) => _json(
          ({
            'id': 1,
            'hero_id': 7,
            'author': 'Anonim',
            'content': 'Inspiratif!',
            'created_at': '2026-09-27 19:41:18',
          }),
          201,
        )).insertComment(heroId: 7, author: '', content: 'Inspiratif!');
    expect(comment.createdAt, DateTime(2026, 9, 27, 19, 41, 18));
    expect(requests.single.method, 'POST');
  });

  test('pesan error dari API diteruskan sebagai ApiException', () async {
    final service =
        api((_) => _json(({'error': 'Pahlawan tidak ditemukan'}), 404));
    expect(
      () => service.deleteHero(99),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', 'Pahlawan tidak ditemukan')),
    );
  });

  test('server mati menghasilkan pesan yang jelas', () async {
    final service = ApiService(
      baseUrl: 'http://api.test',
      client: MockClient((_) => throw http.ClientException('refused')),
    );
    expect(() => service.getHeroes(), throwsA(isA<ApiException>()));
  });
}

/// Respons JSON UTF-8, sama seperti yang dikirim API PHP.
http.Response _json(Object data, int status) => http.Response.bytes(
      utf8.encode(jsonEncode(data)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
