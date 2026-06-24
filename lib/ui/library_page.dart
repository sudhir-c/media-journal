import 'dart:async';

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/categories.dart' hide Axis;
import '../data/database.dart';
import '../data/entry_repository.dart';
import '../data/export.dart';
import 'add_page.dart';
import 'entry_detail_page.dart';
import 'stats_page.dart';
import 'theme/app_text.dart';
import 'theme/tokens.dart';
import 'widgets/common.dart';
import 'widgets/entry_card.dart';
import 'widgets/reveal.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Category? _category;
  Status? _status;
  SortKey _sort = SortKey.recent;
  String _q = '';
  Timer? _debounce;

  late Stream<List<Entry>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _buildStream();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Stream<List<Entry>> _buildStream() => AppScope.of(context).watch(
    category: _category,
    status: _status,
    q: _q,
    sort: _sort,
  );

  // Rebuild the stream only when filters change. New/edited/deleted entries
  // appear automatically because the stream is reactive.
  void _applyFilters() => setState(() => _stream = _buildStream());

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      _q = value;
      _applyFilters();
    });
  }

  bool get _hasFilters =>
      _category != null ||
      _status != null ||
      _sort != SortKey.recent ||
      _q.isNotEmpty;

  void _openAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddPage()),
    );
  }

  void _openEntry(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EntryDetailPage(id: id)),
    );
  }

  Future<void> _export() async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = AppScope.of(context);
    try {
      final saved = await exportEntriesToFile(repo);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            saved == null ? 'Export cancelled' : 'Exported to $saved',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _NewEntryButton(onTap: _openAdd),
      body: SafeArea(
        child: StreamBuilder<List<Entry>>(
          stream: _stream,
          builder: (context, snapshot) {
            final entries = snapshot.data;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Masthead(
                    count: entries?.length,
                    onStats: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const StatsPage()),
                    ),
                    onExport: _export,
                  ),
                ),
                if (entries == null || (entries.isNotEmpty || _hasFilters))
                  SliverToBoxAdapter(
                    child: _Filters(
                      category: _category,
                      status: _status,
                      sort: _sort,
                      hasFilters: _hasFilters,
                      onSearch: _onSearch,
                      onCategory: (c) {
                        _category = c;
                        _applyFilters();
                      },
                      onStatus: (s) {
                        _status = s;
                        _applyFilters();
                      },
                      onSort: (s) {
                        _sort = s;
                        _applyFilters();
                      },
                      onClear: () {
                        setState(() {
                          _category = null;
                          _status = null;
                          _sort = SortKey.recent;
                          _q = '';
                          _stream = _buildStream();
                        });
                      },
                    ),
                  ),
                _body(context, entries),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, List<Entry>? entries) {
    if (entries == null) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (entries.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(filtered: _hasFilters, onAdd: _openAdd),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 188,
          mainAxisSpacing: AppSpacing.xl,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 0.52,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          return Reveal(
            delay: Duration(milliseconds: (i % 12) * 35),
            child: EntryCard(
              entry: entries[i],
              onTap: () => _openEntry(entries[i].id),
            ),
          );
        }, childCount: entries.length),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────── masthead ────

class _Masthead extends StatelessWidget {
  const _Masthead({
    required this.count,
    required this.onStats,
    required this.onExport,
  });

  final int? count;
  final VoidCallback onStats;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SectionLabel('Media Journal'),
              const Spacer(),
              _BarAction(icon: Icons.bar_chart_outlined, label: 'Stats', onTap: onStats),
              const SizedBox(width: AppSpacing.xs),
              _BarAction(icon: Icons.ios_share_outlined, label: 'Export', onTap: onExport),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Library', style: AppText.display(context)),
          const SizedBox(height: 6),
          Text(
            count == null
                ? ' '
                : '$count ${count == 1 ? 'entry' : 'entries'}',
            style: AppText.meta(context),
          ),
        ],
      ),
    );
  }
}

class _BarAction extends StatelessWidget {
  const _BarAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.inkSoft),
            const SizedBox(width: 6),
            Text(label, style: AppText.label(context, color: AppColors.inkSoft)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────── filters ────

class _Filters extends StatelessWidget {
  const _Filters({
    required this.category,
    required this.status,
    required this.sort,
    required this.hasFilters,
    required this.onSearch,
    required this.onCategory,
    required this.onStatus,
    required this.onSort,
    required this.onClear,
  });

  final Category? category;
  final Status? status;
  final SortKey sort;
  final bool hasFilters;
  final ValueChanged<String> onSearch;
  final ValueChanged<Category?> onCategory;
  final ValueChanged<Status?> onStatus;
  final ValueChanged<SortKey> onSort;
  final VoidCallback onClear;

  static const _sortLabels = {
    SortKey.recent: 'Recently added',
    SortKey.consumed: 'Date consumed',
    SortKey.overall: 'Overall score',
    SortKey.title: 'Title (A–Z)',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category as a quiet text segmented control.
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _Segment(
                  label: 'All',
                  selected: category == null,
                  onTap: () => onCategory(null),
                ),
                for (final c in categories)
                  _Segment(
                    label: c.label,
                    selected: category == c,
                    onTap: () => onCategory(c),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearch,
                  style: AppText.body(context),
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18, color: AppColors.inkFaint),
                    hintText: 'Search title or creator',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _MenuButton<Status?>(
                value: status,
                label: status?.label ?? 'All statuses',
                items: [
                  const PopupMenuItem(value: null, child: Text('All statuses')),
                  for (final s in Status.values)
                    PopupMenuItem(value: s, child: Text(s.label)),
                ],
                onSelected: onStatus,
              ),
              const SizedBox(width: AppSpacing.xs),
              _MenuButton<SortKey>(
                value: sort,
                label: _sortLabels[sort]!,
                items: [
                  for (final e in _sortLabels.entries)
                    PopupMenuItem(value: e.key, child: Text(e.value)),
                ],
                onSelected: (v) => onSort(v ?? SortKey.recent),
              ),
              if (hasFilters)
                IconButton(
                  tooltip: 'Clear filters',
                  icon: const Icon(Icons.close, size: 18, color: AppColors.inkSoft),
                  onPressed: onClear,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Text(
            label,
            style: AppText.label(context).copyWith(
              color: selected ? AppColors.paper : AppColors.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton<T> extends StatelessWidget {
  const _MenuButton({
    required this.value,
    required this.label,
    required this.items,
    required this.onSelected,
  });

  final T value;
  final String label;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: const BorderSide(color: AppColors.line),
      ),
      itemBuilder: (_) => items,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppText.label(context, color: AppColors.inkSoft)),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 16, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────── empty / fab ────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered, required this.onAdd});

  final bool filtered;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filtered ? Icons.search_off_outlined : Icons.auto_stories_outlined,
              size: 40,
              color: AppColors.inkFaint,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              filtered ? 'Nothing matches' : 'Your library is empty',
              style: AppText.headline(context),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              filtered
                  ? 'Try a different search or clear your filters.'
                  : 'Add the first film or book you want to remember.',
              textAlign: TextAlign.center,
              style: AppText.meta(context),
            ),
            if (!filtered) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onAdd, child: const Text('Add an entry')),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewEntryButton extends StatelessWidget {
  const _NewEntryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.ink,
      foregroundColor: AppColors.paper,
      elevation: 2,
      highlightElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      icon: const Icon(Icons.add, size: 20),
      label: Text(
        'New entry',
        style: AppText.label(context, color: AppColors.paper).copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
