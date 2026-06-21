import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../core/categories.dart';
import '../../data/entry_input.dart';
import 'rating_input.dart';

/// Config-driven create/edit form. Renders rating axes from [categoryAxes]
/// for the entry's category. Creates when [entryId] is null, else updates.
class EntryForm extends StatefulWidget {
  const EntryForm({
    super.key,
    required this.initial,
    required this.submitLabel,
    required this.onSaved,
    this.entryId,
    this.onCancel,
  });

  final EntryInput initial;
  final String submitLabel;
  final String? entryId;
  final void Function(String id) onSaved;
  final VoidCallback? onCancel;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  late final Category _category = widget.initial.category;
  late final TextEditingController _title =
      TextEditingController(text: widget.initial.title);
  late final TextEditingController _creators =
      TextEditingController(text: widget.initial.creators);
  late final TextEditingController _year = TextEditingController(
    text: widget.initial.year?.toString() ?? '',
  );
  late final TextEditingController _coverUrl =
      TextEditingController(text: widget.initial.coverUrl ?? '');
  late final TextEditingController _pro =
      TextEditingController(text: widget.initial.pro);
  late final TextEditingController _con =
      TextEditingController(text: widget.initial.con);
  late final TextEditingController _notes =
      TextEditingController(text: widget.initial.notes);

  late Status _status = widget.initial.status;
  late String? _consumedDate = widget.initial.consumedDate;
  late final Map<AxisKey, int?> _axes = {...widget.initial.axes};

  Map<String, String> _errors = {};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_title, _creators, _year, _coverUrl, _pro, _con, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _creatorsLabel => switch (_category) {
    Category.movie => 'Director(s)',
    Category.tv => 'Creator(s)',
    _ => 'Author(s)',
  };

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_consumedDate ?? '') ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _consumedDate =
            '${picked.year.toString().padLeft(4, '0')}-'
            '${picked.month.toString().padLeft(2, '0')}-'
            '${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  EntryInput _collect() {
    return EntryInput(
      category: _category,
      title: _title.text,
      creators: _creators.text,
      year: _year.text.trim().isEmpty ? null : int.tryParse(_year.text.trim()),
      coverUrl: _coverUrl.text,
      source: widget.initial.source,
      externalId: widget.initial.externalId,
      externalRaw: widget.initial.externalRaw,
      status: _status,
      consumedDate: _consumedDate,
      axes: {for (final a in _category.axes) a.key: _axes[a.key]},
      pro: _pro.text,
      con: _con.text,
      notes: _notes.text,
    );
  }

  Future<void> _submit() async {
    final input = _collect();
    final errors = input.validate();
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      _toast(errors.values.first, error: true);
      return;
    }
    setState(() {
      _errors = {};
      _saving = true;
    });
    final repo = AppScope.of(context);
    try {
      final id = widget.entryId == null
          ? await repo.create(input)
          : (await repo.update(widget.entryId!, input) ? widget.entryId! : null);
      if (id == null) {
        _toast('Entry not found', error: true);
        setState(() => _saving = false);
        return;
      }
      if (!mounted) return;
      _toast('Saved');
      widget.onSaved(id);
    } catch (e) {
      _toast('Failed to save: $e', error: true);
      setState(() => _saving = false);
    }
  }

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionRow([
          Text('Category', style: theme.textTheme.bodySmall),
          const SizedBox(width: 8),
          Chip(
            label: Text(_category.label),
            visualDensity: VisualDensity.compact,
          ),
        ]),
        const SizedBox(height: 16),
        TextField(
          controller: _title,
          decoration: InputDecoration(
            labelText: 'Title',
            border: const OutlineInputBorder(),
            errorText: _errors['title'],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _creators,
                decoration: InputDecoration(
                  labelText: _creatorsLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _year,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: const OutlineInputBorder(),
                  errorText: _errors['year'],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Status>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final s in Status.values)
                    DropdownMenuItem(value: s, child: Text(s.label)),
                ],
                onChanged: (v) => setState(() => _status = v ?? Status.done),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date consumed',
                    border: const OutlineInputBorder(),
                    errorText: _errors['consumedDate'],
                    suffixIcon: _consumedDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () =>
                                setState(() => _consumedDate = null),
                          )
                        : const Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(_consumedDate ?? 'Not set'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _coverUrl,
          decoration: InputDecoration(
            labelText: 'Cover image URL',
            hintText: 'https://…',
            border: const OutlineInputBorder(),
            errorText: _errors['coverUrl'],
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Ratings (1–10)'),
        const SizedBox(height: 12),
        ..._category.axes.map(
          (axis) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RatingInput(
              label: axis.label,
              value: _axes[axis.key],
              onChanged: (v) => setState(() => _axes[axis.key] = v),
              error: _errors[axis.key.wire],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _sectionTitle('Reactions'),
        const SizedBox(height: 12),
        TextField(
          controller: _pro,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'What worked',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _con,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "What didn't",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notes,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: Text(_saving ? 'Saving…' : widget.submitLabel),
            ),
            if (widget.onCancel != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: _saving ? null : widget.onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _sectionRow(List<Widget> children) =>
      Row(children: children);

  Widget _sectionTitle(String text) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      letterSpacing: 0.8,
      color: Theme.of(context).colorScheme.outline,
      fontWeight: FontWeight.w600,
    ),
  );
}
