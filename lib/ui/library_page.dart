import 'dart:async';

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/categories.dart';
import '../data/database.dart';
import '../data/entry_repository.dart';
import '../data/export.dart';
import 'add_page.dart';
import 'entry_detail_page.dart';
import 'stats_page.dart';
import 'widgets/entry_card.dart';

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
  // appear automatically because the stream is reactive, so navigating back
  // from the add/detail screens needs no manual refresh.
  void _applyFilters() => setState(() => _stream = _buildStream());

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _q = value;
      _applyFilters();
    });
  }

  bool get _hasFilters =>
      _category != null || _status != null || _sort != SortKey.recent || _q.isNotEmpty;

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
          behavior: SnackBarBehavior.floating,
          content: Text(saved == null ? 'Export cancelled' : 'Exported to $saved'),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Export failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Stats',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StatsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export JSON',
            onPressed: _export,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
      ),
      body: Column(
        children: [
          _FilterBar(
            category: _category,
            status: _status,
            sort: _sort,
            hasFilters: _hasFilters,
            onSearch: _onSearch,
            onCategory: (c) => setState(() {
              _category = c;
              _stream = _buildStream();
            }),
            onStatus: (s) => setState(() {
              _status = s;
              _stream = _buildStream();
            }),
            onSort: (s) => setState(() {
              _sort = s;
              _stream = _buildStream();
            }),
            onClear: () => setState(() {
              _category = null;
              _status = null;
              _sort = SortKey.recent;
              _q = '';
              _stream = _buildStream();
            }),
          ),
          Expanded(
            child: StreamBuilder<List<Entry>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snapshot.data!;
                if (entries.isEmpty) {
                  return Center(
                    child: Text(
                      _hasFilters
                          ? 'No entries match these filters.'
                          : 'Nothing logged yet. Tap “Add entry”.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.52,
                  ),
                  itemCount: entries.length,
                  itemBuilder: (context, i) => EntryCard(
                    entry: entries[i],
                    onTap: () => _openEntry(entries[i].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 260,
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 20),
                hintText: 'Search title or creator…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          DropdownMenu<Category?>(
            initialSelection: category,
            label: const Text('Category'),
            onSelected: onCategory,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: 'All categories'),
              for (final c in categories)
                DropdownMenuEntry(value: c, label: c.label),
            ],
          ),
          DropdownMenu<Status?>(
            initialSelection: status,
            label: const Text('Status'),
            onSelected: onStatus,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: 'All statuses'),
              for (final s in Status.values)
                DropdownMenuEntry(value: s, label: s.label),
            ],
          ),
          DropdownMenu<SortKey>(
            initialSelection: sort,
            label: const Text('Sort'),
            onSelected: (v) => onSort(v ?? SortKey.recent),
            dropdownMenuEntries: [
              for (final entry in _sortLabels.entries)
                DropdownMenuEntry(value: entry.key, label: entry.value),
            ],
          ),
          if (hasFilters)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear'),
            ),
        ],
      ),
    );
  }
}
