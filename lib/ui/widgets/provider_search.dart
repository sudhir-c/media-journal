import 'package:flutter/material.dart';

import '../../core/categories.dart';
import '../../providers/provider_facade.dart';
import 'cover_image.dart';

/// Step 2 of the add flow: search a provider, or fall back to manual entry.
class ProviderSearch extends StatefulWidget {
  const ProviderSearch({
    super.key,
    required this.category,
    required this.onPick,
    required this.onManual,
  });

  final Category category;
  final void Function(NormalizedResult details) onPick;
  final VoidCallback onManual;

  @override
  State<ProviderSearch> createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  final _controller = TextEditingController();
  List<NormalizedResult>? _results;
  bool _searching = false;
  String? _pickingId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _hint => switch (widget.category) {
    Category.tv => 'Search TV shows…',
    Category.movie => 'Search movies…',
    _ => 'Search books…',
  };

  Future<void> _search() async {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    setState(() => _searching = true);
    try {
      final results = await searchProviders(widget.category, q);
      if (!mounted) return;
      setState(() => _results = results);
    } catch (e) {
      if (!mounted) return;
      setState(() => _results = []);
      _toast(e is ProviderException ? e.message : 'Search failed');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _pick(NormalizedResult r) async {
    setState(() => _pickingId = r.externalId);
    try {
      final details = await getProviderDetails(r.source, r.externalId);
      if (!mounted) return;
      widget.onPick(details);
    } catch (_) {
      if (!mounted) return;
      _toast("Couldn't load full details — using search result.");
      widget.onPick(r); // graceful fallback to search-result data
    } finally {
      if (mounted) setState(() => _pickingId = null);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: _hint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _searching ? null : _search,
              icon: _searching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search, size: 18),
              label: const Text('Search'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (results != null)
          results.isEmpty
              ? Text(
                  'No results. Try another search or enter it manually.',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline),
                )
              : Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final r in results)
                        ListTile(
                          leading: SizedBox(
                            width: 36,
                            height: 54,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CoverImage(url: r.coverUrl, iconSize: 18),
                            ),
                          ),
                          title: Text(
                            r.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            [
                              r.creators,
                              if (r.year != null) '${r.year}',
                            ].where((s) => s.isNotEmpty).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: _pickingId == r.externalId
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : null,
                          onTap: _pickingId == null ? () => _pick(r) : null,
                        ),
                    ],
                  ),
                ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              "Can't find it?",
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: widget.onManual,
              child: const Text('Enter manually'),
            ),
          ],
        ),
      ],
    );
  }
}
