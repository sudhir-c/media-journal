import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/categories.dart';

/// A single normalized search hit / details record, provider-agnostic.
class NormalizedResult {
  const NormalizedResult({
    required this.source,
    required this.externalId,
    required this.title,
    required this.year,
    required this.creators,
    required this.coverUrl,
    required this.raw,
  });

  final Source source;
  final String externalId;
  final String title;
  final int? year;
  final String creators;
  final String? coverUrl;

  /// Raw decoded provider payload, snapshotted on add.
  final Object? raw;

  String get rawJson => jsonEncode(raw);
}

class ProviderException implements Exception {
  ProviderException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// HTTP GET with a hard timeout so a slow/hung provider fails fast.
Future<dynamic> fetchJson(
  String url, {
  required String label,
  Map<String, String>? headers,
  Duration timeout = const Duration(seconds: 7),
}) async {
  late final http.Response res;
  try {
    res = await http.get(Uri.parse(url), headers: headers).timeout(timeout);
  } catch (_) {
    throw ProviderException('$label request failed (network)');
  }
  if (res.statusCode != 200) {
    throw ProviderException('$label request failed (${res.statusCode})');
  }
  return jsonDecode(utf8.decode(res.bodyBytes));
}

/// Pull a 4-digit year out of a date-ish string ("2019-05-30", "2019").
int? parseYear(Object? value) {
  if (value is int) return value;
  if (value is! String) return null;
  final match = RegExp(r'\d{4}').firstMatch(value);
  return match == null ? null : int.tryParse(match.group(0)!);
}

String joinCreators(Iterable<String?> names) =>
    names.where((n) => n != null && n.trim().isNotEmpty).cast<String>().join(', ');

bool isBookCategory(Category c) =>
    c == Category.fiction || c == Category.nonfiction;
