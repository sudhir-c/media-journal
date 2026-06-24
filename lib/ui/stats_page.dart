import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/format.dart';
import '../data/stats.dart';
import 'entry_detail_page.dart';
import 'theme/app_text.dart';
import 'theme/tokens.dart';
import 'widgets/common.dart';

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
            body: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return DefaultTabController(
          length: stats.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Stats'),
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.ink,
                indicatorWeight: 2,
                labelColor: AppColors.ink,
                unselectedLabelColor: AppColors.inkFaint,
                labelStyle: AppText.label(context).copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppText.label(context),
                dividerColor: AppColors.line,
                tabs: [for (final s in stats) Tab(text: s.label)],
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
          style: AppText.meta(context),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.huge,
      ),
      children: [
        Row(
          children: [
            _Stat(label: 'Entries', value: '${stats.count}'),
            _Stat(label: 'Rated', value: '${stats.ratedCount}'),
            _Stat(label: 'Avg overall', value: formatScore(stats.averageOverall)),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        const SectionLabel('Average by axis'),
        const SizedBox(height: AppSpacing.md),
        for (final a in stats.axisAverages)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _AxisBar(label: a.label, average: a.average),
          ),

        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('Score distribution'),
        const SizedBox(height: AppSpacing.md),
        SizedBox(height: 200, child: _DistributionChart(stats.distribution)),

        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('Over time'),
        const SizedBox(height: AppSpacing.md),
        if (stats.overTime.isEmpty)
          Text('No consumed dates recorded.', style: AppText.meta(context))
        else
          SizedBox(height: 200, child: _OverTimeChart(stats.overTime)),

        const SizedBox(height: AppSpacing.xl),
        const SectionLabel('Top rated'),
        const SizedBox(height: AppSpacing.xs),
        if (stats.topRated.isEmpty)
          Text('Nothing rated yet.', style: AppText.meta(context))
        else
          for (var i = 0; i < stats.topRated.length; i++)
            _TopRow(rank: i + 1, entry: stats.topRated[i]),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.title(context).copyWith(fontSize: 34)),
          const SizedBox(height: 4),
          SectionLabel(label),
        ],
      ),
    );
  }
}

class _AxisBar extends StatelessWidget {
  const _AxisBar({required this.label, required this.average});
  final String label;
  final double? average;

  @override
  Widget build(BuildContext context) {
    final v = average ?? 0;
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(label, style: AppText.body(context)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: Stack(
              children: [
                Container(height: 8, color: AppColors.fill),
                FractionallySizedBox(
                  widthFactor: (v / 10).clamp(0, 1),
                  child: Container(height: 8, color: AppColors.ink),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            average == null ? '—' : v.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: AppText.label(context).copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _DistributionChart extends StatelessWidget {
  const _DistributionChart(this.buckets);
  final List<DistributionBucket> buckets;

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.ink,
                  width: 13,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ],
            ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.line, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: maxY <= 5 ? 1 : null,
              getTitlesWidget: (value, _) => value == value.roundToDouble()
                  ? Text('${value.toInt()}', style: _axisStyle(context))
                  : const SizedBox.shrink(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text('${value.toInt()}', style: _axisStyle(context)),
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
            color: AppColors.ink,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 3,
                color: AppColors.ink,
                strokeWidth: 0,
              ),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.line, strokeWidth: 1),
          getDrawingVerticalLine: (_) =>
              const FlLine(color: AppColors.line, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: maxY <= 5 ? 1 : null,
              getTitlesWidget: (value, _) => value == value.roundToDouble()
                  ? Text('${value.toInt()}', style: _axisStyle(context))
                  : const SizedBox.shrink(),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final i = value.round();
                if (i < 0 || i >= points.length || i != value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(points[i].month, style: _axisStyle(context)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _axisStyle(BuildContext context) =>
    AppText.meta(context, color: AppColors.inkFaint).copyWith(fontSize: 11);

class _TopRow extends StatelessWidget {
  const _TopRow({required this.rank, required this.entry});
  final int rank;
  final TopEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => EntryDetailPage(id: entry.id)),
      ),
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 2),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: AppText.meta(context, color: AppColors.inkFaint),
              ),
            ),
            Expanded(
              child: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(context),
              ),
            ),
            Text(
              formatScore(entry.overall),
              style: AppText.label(context).copyWith(
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
