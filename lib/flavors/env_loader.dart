import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvLoader {
  EnvLoader._(); 

  static late final String baseUrl;
  static late final String googleBooksApiKey;

  static Future<void> load(String prefix) async {
    await dotenv.load(fileName: ".env");
    _parse(prefix, dotenv.env);
  }

  static void _parse(String prefix, Map<String, String> map) {
    final url = map['${prefix}_BASE_URL'];
    final apiKey = map['${prefix}_GOOGLE_BOOKS_API_KEY'];

    assert(url != null && url.isNotEmpty,
        '${prefix}_BASE_URL is missing or empty in .env');
    assert(apiKey != null && apiKey.isNotEmpty,
        '${prefix}_GOOGLE_BOOKS_API_KEY is missing or empty in .env');

    baseUrl = url!;
    googleBooksApiKey = apiKey!;
  }
}
