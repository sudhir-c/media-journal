import 'package:flutter_dotenv/flutter_dotenv.dart';

/// TMDB API Read Access Token, bundled via the app's .env asset. Returns null
/// when unset so the TMDB provider can fail gracefully (books need no key).
String? get tmdbToken {
  try {
    final t = dotenv.maybeGet('TMDB_READ_TOKEN');
    return (t == null || t.isEmpty) ? null : t;
  } catch (_) {
    // dotenv not initialized (no .env bundled).
    return null;
  }
}
