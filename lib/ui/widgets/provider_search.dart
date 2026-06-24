import 'package:flutter/material.dart';

import '../../core/categories.dart';
import '../../providers/provider_facade.dart';
import '../theme/app_text.dart';
import '../theme/tokens.dart';
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
    Category.tv => 'Search TV shows',
    Category.movie => 'Search movies',
    _ => 'Search books',
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
      widget.onPick(r);
    } finally {
      if (mounted) setState(() => _pickingId = null);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                style: AppText.body(context),
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: _hint,
                  prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.inkFaint),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: _searching ? null : _search,
              child: _searching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.paper,
                      ),
                    )
                  : const Text('Search'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (results != null)
          if (results.isEmpty)
            Text(
              'No results. Try another search, or enter it manually below.',
              style: AppText.meta(context),
            )
          else
            ...results.map(_resultRow),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Text("Can't find it?", style: AppText.meta(context)),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: widget.onManual,
              child: const Text('Enter manually'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultRow(NormalizedResult r) {
    final busy = _pickingId == r.externalId;
    final meta = [
      r.creators,
      if (r.year != null) '${r.year}',
    ].where((s) => s.isNotEmpty).join('  ·  ');

    return InkWell(
      onTap: _pickingId == null ? () => _pick(r) : null,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: PosterFrame(url: r.coverUrl, elevated: false, radius: 6),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle(context).copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta.isEmpty ? '—' : meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.meta(context),
                  ),
                ],
              ),
            ),
            if (busy)
              const Padding(
                padding: EdgeInsets.only(left: AppSpacing.sm),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
