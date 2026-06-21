import 'package:flutter/material.dart';

import '../core/categories.dart';
import '../data/entry_input.dart';
import '../providers/provider_facade.dart';
import 'widgets/entry_form.dart';
import 'widgets/provider_search.dart';

enum _Step { pick, search, form }

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  _Step _step = _Step.pick;
  Category? _category;
  EntryInput? _initial;

  void _choose(Category c) {
    setState(() {
      _category = c;
      _initial = null;
      _step = _Step.search;
    });
  }

  EntryInput _fromDetails(NormalizedResult d) => EntryInput(
    category: _category!,
    title: d.title,
    creators: d.creators,
    year: d.year,
    coverUrl: d.coverUrl,
    source: d.source,
    externalId: d.externalId,
    externalRaw: d.rawJson,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _category == null ? 'Add entry' : 'Add ${_category!.label}',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: switch (_step) {
              _Step.pick => _CategoryPicker(onPick: _choose),
              _Step.search => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _step = _Step.pick),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Change category'),
                  ),
                  const SizedBox(height: 8),
                  ProviderSearch(
                    category: _category!,
                    onPick: (details) => setState(() {
                      _initial = _fromDetails(details);
                      _step = _Step.form;
                    }),
                    onManual: () => setState(() {
                      _initial = null;
                      _step = _Step.form;
                    }),
                  ),
                ],
              ),
              _Step.form => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _step = _Step.search),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to search'),
                  ),
                  const SizedBox(height: 8),
                  EntryForm(
                    initial: _initial ?? EntryInput(category: _category!),
                    submitLabel: 'Save entry',
                    onSaved: (_) => Navigator.of(context).pop(),
                    onCancel: () => setState(() => _step = _Step.search),
                  ),
                ],
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({required this.onPick});

  final void Function(Category) onPick;

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  bool _bookOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are you logging?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PickTile(label: 'Movie', onTap: () => widget.onPick(Category.movie)),
            _PickTile(label: 'TV', onTap: () => widget.onPick(Category.tv)),
            _PickTile(
              label: 'Book',
              active: _bookOpen,
              onTap: () => setState(() => _bookOpen = !_bookOpen),
            ),
          ],
        ),
        if (_bookOpen) ...[
          const SizedBox(height: 24),
          Text(
            'Fiction or nonfiction?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PickTile(
                label: 'Fiction',
                onTap: () => widget.onPick(Category.fiction),
              ),
              _PickTile(
                label: 'Nonfiction',
                onTap: () => widget.onPick(Category.nonfiction),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.label, required this.onTap, this.active = false});

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 160,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          backgroundColor: active ? scheme.secondaryContainer : null,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
