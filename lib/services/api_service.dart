import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/comment_model.dart';
import '../models/hero_model.dart';

/// Terjadi saat API mengembalikan error atau server tidak bisa dihubungi.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Menghubungkan aplikasi ke API PHP (XAMPP) yang menyimpan data di MySQL.
class ApiService {
  /// Alamat API. Ubah saat menjalankan, misalnya untuk emulator Android:
  /// `flutter run --dart-define=API_URL=http://10.0.2.2:8080/pahlawan_api`
  static const defaultBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://127.0.0.1:8080/pahlawan_api',
  );

  /// Instance yang dipakai aplikasi. Bisa diganti di test.
  static ApiService instance = ApiService();

  final http.Client _client;
  final String baseUrl;

  ApiService({http.Client? client, this.baseUrl = defaultBaseUrl})
      : _client = client ?? http.Client();

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Uri _uri(String file, [Map<String, Object>? query]) {
    return Uri.parse('$baseUrl/$file').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request();
    } on http.ClientException {
      throw ApiException(
          'Tidak dapat terhubung ke server. Pastikan Apache & MySQL di XAMPP sudah berjalan.');
    }

    final dynamic body =
        response.body.isEmpty ? null : jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 400) {
      final message = body is Map ? body['error'] : null;
      throw ApiException(message?.toString() ?? 'Error ${response.statusCode}');
    }
    return body;
  }

  // ---------------------------------------------------------------------------
  // Heroes
  // ---------------------------------------------------------------------------

  Future<List<HeroModel>> getHeroes() async {
    final List data = await _send(() => _client.get(_uri('heroes.php')));
    return data.map((e) => HeroModel.fromMap(e)).toList();
  }

  Future<HeroModel> getHero(int id) async {
    return HeroModel.fromMap(
        await _send(() => _client.get(_uri('heroes.php', {'id': id}))));
  }

  Future<HeroModel> insertHero(HeroModel hero) async {
    final data = await _send(() => _client.post(_uri('heroes.php'),
        headers: _jsonHeaders, body: jsonEncode(hero.toMap())));
    return HeroModel.fromMap(data);
  }

  Future<HeroModel> updateHero(HeroModel hero) async {
    final data = await _send(() => _client.put(_uri('heroes.php', {'id': hero.id!}),
        headers: _jsonHeaders, body: jsonEncode(hero.toMap())));
    return HeroModel.fromMap(data);
  }

  Future<void> deleteHero(int id) async {
    await _send(() => _client.delete(_uri('heroes.php', {'id': id})));
  }

  // ---------------------------------------------------------------------------
  // Comments
  // ---------------------------------------------------------------------------

  Future<List<CommentModel>> getComments(int heroId) async {
    final List data =
        await _send(() => _client.get(_uri('comments.php', {'hero_id': heroId})));
    return data.map((e) => CommentModel.fromMap(e)).toList();
  }

  Future<CommentModel> insertComment(
      {required int heroId, required String author, required String content}) async {
    final data = await _send(() => _client.post(_uri('comments.php'),
        headers: _jsonHeaders,
        body: jsonEncode({'hero_id': heroId, 'author': author, 'content': content})));
    return CommentModel.fromMap(data);
  }

  Future<CommentModel> updateComment(int id, String content) async {
    final data = await _send(() => _client.put(_uri('comments.php', {'id': id}),
        headers: _jsonHeaders, body: jsonEncode({'content': content})));
    return CommentModel.fromMap(data);
  }

  Future<void> deleteComment(int id) async {
    await _send(() => _client.delete(_uri('comments.php', {'id': id})));
  }
}
