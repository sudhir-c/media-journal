import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/categories.dart';
import '../core/format.dart';
import '../data/database.dart';
import '../data/entry_domain.dart';
import 'widgets/cover_image.dart';
import 'widgets/entry_form.dart';

class EntryDetailPage extends StatefulWidget {
  const EntryDetailPage({super.key, required this.id});

  final String id;

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late Future<Entry?> _future;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _future = AppScope.of(context).getById(widget.id);
  }

  void _reload() {
    setState(() => _future = AppScope.of(context).getById(widget.id));
  }

  Future<void> _confirmDelete(Entry entry) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text(
          'This permanently removes “${entry.title}”. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await AppScope.of(context).delete(widget.id);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit entry' : 'Entry')),
      body: FutureBuilder<Entry?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final entry = snapshot.data;
          if (entry == null) {
            return const Center(child: Text('Entry not found.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _editing
                    ? EntryForm(
                        initial: entryToInput(entry),
                        entryId: entry.id,
                        submitLabel: 'Save changes',
                        onSaved: (_) {
                          setState(() => _editing = false);
                          _reload();
                        },
                        onCancel: () => setState(() => _editing = false),
                      )
                    : _DetailView(
                        entry: entry,
                        onEdit: () => setState(() => _editing = true),
                        onDelete: () => _confirmDelete(entry),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final Entry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = [
      entry.creators,
      if (entry.year != null) '${entry.year}',
    ].where((s) => s.isNotEmpty).join(' · ');
    final consumed = formatConsumedDate(entry.consumedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CoverImage(url: entry.coverUrl),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(entry.categoryEnum.label),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text(entry.statusEnum.label),
                        visualDensity: VisualDensity.compact,
                      ),
                      if (entry.sourceEnum != Source.manual)
                        Chip(
                          label: Text('via ${entry.source}'),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(entry.title, style: theme.textTheme.headlineSmall),
                  if (meta.isNotEmpty)
                    Text(
                      meta,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  if (consumed != null)
                    Text(
                      'Consumed $consumed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatScore(entry.overallScore),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'overall',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 12),
        _sectionTitle(context, 'Ratings'),
        const SizedBox(height: 8),
        ...entry.categoryEnum.axes.map(
          (axis) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: Text(axis.label)),
                Text(
                  entry.axis(axis.key)?.toString() ?? '—',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        if (entry.pro.isNotEmpty || entry.con.isNotEmpty || entry.notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionTitle(context, 'Reactions'),
          const SizedBox(height: 8),
          if (entry.pro.isNotEmpty) _field(context, 'What worked', entry.pro),
          if (entry.con.isNotEmpty) _field(context, "What didn't", entry.con),
          if (entry.notes.isNotEmpty) _field(context, 'Notes', entry.notes),
        ],
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      letterSpacing: 0.8,
      color: Theme.of(context).colorScheme.outline,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _field(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(value),
      ],
    ),
  );
}
