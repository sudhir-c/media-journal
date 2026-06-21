import 'package:intl/intl.dart';

String formatScore(double? score) =>
    score == null ? '—' : score.toStringAsFixed(1);

/// Format an ISO date (YYYY-MM-DD) for display.
String? formatConsumedDate(String? date) {
  if (date == null || date.isEmpty) return null;
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  return DateFormat.yMMMd().format(parsed);
}
