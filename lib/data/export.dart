import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';

import '../core/categories.dart';
import 'database.dart';
import 'entry_domain.dart';
import 'entry_repository.dart';

/// Exports all entries (stored columns + derived overallScore) as a JSON file
/// chosen via a save dialog. Returns the saved path, or null if cancelled.
Future<String?> exportEntriesToFile(EntryRepository repo) async {
  final entries = await repo.list();
  final payload = {
    'exportedAt': DateTime.now().toIso8601String(),
    'count': entries.length,
    'entries': entries.map(_entryToJson).toList(),
  };
  final jsonStr = const JsonEncoder.withIndent('  ').convert(payload);
  final date = DateTime.now().toIso8601String().substring(0, 10);

  final location = await getSaveLocation(
    suggestedName: 'media-journal-$date.json',
    acceptedTypeGroups: const [
      XTypeGroup(label: 'JSON', extensions: ['json']),
    ],
  );
  if (location == null) return null;

  await File(location.path).writeAsString(jsonStr);
  return location.path;
}

Object? _decodeRaw(String? raw) {
  if (raw == null) return null;
  try {
    return jsonDecode(raw);
  } catch (_) {
    return raw;
  }
}

Map<String, dynamic> _entryToJson(Entry e) => {
  'id': e.id,
  'category': e.category,
  'title': e.title,
  'creators': e.creators,
  'year': e.year,
  'coverUrl': e.coverUrl,
  'source': e.source,
  'externalId': e.externalId,
  'externalRaw': _decodeRaw(e.externalRaw),
  'status': e.status,
  'consumedDate': e.consumedDate,
  for (final k in AxisKey.values) k.wire: e.axis(k),
  'pro': e.pro,
  'con': e.con,
  'notes': e.notes,
  'createdAt': e.createdAt.toIso8601String(),
  'updatedAt': e.updatedAt.toIso8601String(),
  'overallScore': e.overallScore,
};
