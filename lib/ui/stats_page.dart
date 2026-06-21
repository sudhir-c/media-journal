import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/format.dart';
import '../data/stats.dart';
import 'entry_detail_page.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final Future<List<CategoryStats>> _future = _load();

  Future<List<CategoryStats>> _load() async {
    final entries = await AppScope.of(context).list();
    return computeStats(entries);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryStats>>(
      future: _future,
      builder: (context, snapshot) {
        final stats = snapshot.data;
        if (stats == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Stats')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return DefaultTabController(
          length: stats.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Stats'),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  for (final s in stats) Tab(text: '${s.label} (${s.count})'),
                ],
              ),
            ),
            body: TabBarView(
              children: [for (final s in stats) _CategoryPanel(stats: s)],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryPanel extends StatelessWidget {
  const _CategoryPanel({required this.stats});

  final CategoryStats stats;

  @override
  Widget build(BuildContext context) {
    if (stats.count == 0) {
      return Center(
        child: Text(
          'No ${stats.label.toLowerCase()} entries yet.',
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _Stat(label: 'Entries', value: '${stats.count}'),
            const SizedBox(width: 12),
            _Stat(label: 'Rated', value: '${stats.ratedCount}'),
            const SizedBox(width: 12),
            _Stat(
              label: 'Avg overall',
              value: formatScore(stats.averageOverall),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ChartCard(
          title: 'Average by axis',
          child: Column(children: [for (final a in stats.axisAverages) _AxisBar(a)]),
        ),
        _ChartCard(
          title: 'Score distribution',
          child: SizedBox(height: 220, child: _DistributionChart(stats.distribution)),
        ),
        _ChartCard(
          title: 'Entries over time',
          child: stats.overTime.isEmpty
              ? _empty(context, 'No consumed dates recorded.')
              : SizedBox(height: 220, child: _OverTimeChart(stats.overTime)),
        ),
        _ChartCard(
          title: 'Top rated',
          child: stats.topRated.isEmpty
              ? _empty(context, 'Nothing rated yet.')
              : Column(
                  children: [
                    for (var i = 0; i < stats.topRated.length; i++)
                      _TopRow(rank: i + 1, entry: stats.topRated[i]),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _empty(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.outline),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _AxisBar extends StatelessWidget {
  const _AxisBar(this.axis);
  final AxisAverage axis;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = axis.average ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(axis.label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 10,
                minHeight: 16,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(scheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              axis.average == null ? '—' : value.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionChart extends StatelessWidget {
  const _DistributionChart(this.buckets);
  final List<DistributionBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxCount = buckets.fold<int>(0, (m, b) => b.count > m ? b.count : m);
    final maxY = (maxCount < 1 ? 1 : maxCount).toDouble();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: [
          for (final b in buckets)
            BarChartGroupData(
              x: b.score,
              barRods: [
                BarChartRodData(
                  toY: b.count.toDouble(),
                  color: scheme.primary,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: maxY <= 5 ? 1 : null,
              getTitlesWidget: (value, meta) =>
                  value == value.roundToDouble()
                  ? Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 11))
                  : const SizedBox.shrink(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverTimeChart extends StatelessWidget {
  const _OverTimeChart(this.points);
  final List<TimePoint> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxCount = points.fold<int>(0, (m, p) => p.count > m ? p.count : m);
    final maxY = (maxCount < 1 ? 1 : maxCount).toDouble();
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < points.length; i++)
                FlSpot(i.toDouble(), points[i].count.toDouble()),
            ],
            isCurved: true,
            color: scheme.primary,
            barWidth: 2,
            dotData: const FlDotData(show: true),
          ),
        ],
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: maxY <= 5 ? 1 : null,
              getTitlesWidget: (value, meta) =>
                  value == value.roundToDouble()
                  ? Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 11))
                  : const SizedBox.shrink(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= points.length || i != value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    points[i].month,
                    style: const TextStyle(fontSize: 9),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.rank, required this.entry});
  final int rank;
  final TopEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => EntryDetailPage(id: entry.id),
        ),
      ),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank.',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            Expanded(
              child: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formatScore(entry.overall),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
