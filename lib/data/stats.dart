import '../core/categories.dart';
import 'database.dart';
import 'entry_domain.dart';

class AxisAverage {
  const AxisAverage(this.key, this.label, this.average, this.count);
  final AxisKey key;
  final String label;
  final double? average;
  final int count;
}

class DistributionBucket {
  const DistributionBucket(this.score, this.count);
  final int score; // 1..10
  final int count;
}

class TopEntry {
  const TopEntry(this.id, this.title, this.overall);
  final String id;
  final String title;
  final double overall;
}

class TimePoint {
  const TimePoint(this.month, this.count);
  final String month; // YYYY-MM
  final int count;
}

class CategoryStats {
  const CategoryStats({
    required this.category,
    required this.count,
    required this.ratedCount,
    required this.averageOverall,
    required this.axisAverages,
    required this.distribution,
    required this.topRated,
    required this.overTime,
  });

  final Category category;
  final int count;
  final int ratedCount;
  final double? averageOverall;
  final List<AxisAverage> axisAverages;
  final List<DistributionBucket> distribution;
  final List<TopEntry> topRated;
  final List<TimePoint> overTime;

  String get label => category.label;
}

double? _mean(List<int> values) {
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

CategoryStats _computeCategory(Category category, List<Entry> entries) {
  final axisAverages = category.axes.map((axis) {
    final values = entries
        .map((e) => e.axis(axis.key))
        .whereType<int>()
        .toList();
    return AxisAverage(axis.key, axis.label, _mean(values), values.length);
  }).toList();

  final overalls = entries
      .map((e) => e.overallScore)
      .whereType<double>()
      .toList();

  final distribution = List.generate(10, (i) => i + 1).map((score) {
    final count = overalls.where((o) => o.round().clamp(1, 10) == score).length;
    return DistributionBucket(score, count);
  }).toList();

  final rated = entries.where((e) => e.overallScore != null).toList()
    ..sort((a, b) => b.overallScore!.compareTo(a.overallScore!));
  final topRated = rated
      .take(5)
      .map((e) => TopEntry(e.id, e.title, e.overallScore!))
      .toList();

  final byMonth = <String, int>{};
  for (final e in entries) {
    final d = e.consumedDate;
    if (d == null || d.length < 7) continue;
    final month = d.substring(0, 7);
    byMonth[month] = (byMonth[month] ?? 0) + 1;
  }
  final overTime = (byMonth.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)))
      .map((e) => TimePoint(e.key, e.value))
      .toList();

  return CategoryStats(
    category: category,
    count: entries.length,
    ratedCount: overalls.length,
    averageOverall: overalls.isEmpty
        ? null
        : overalls.reduce((a, b) => a + b) / overalls.length,
    axisAverages: axisAverages,
    distribution: distribution,
    topRated: topRated,
    overTime: overTime,
  );
}

/// Per-category aggregates. Categories are never combined or normalized.
List<CategoryStats> computeStats(List<Entry> entries) {
  return categories
      .map((c) => _computeCategory(
            c,
            entries.where((e) => e.categoryEnum == c).toList(),
          ))
      .toList();
}
