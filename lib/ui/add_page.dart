import 'package:flutter/material.dart';

import '../core/categories.dart';
import '../data/entry_input.dart';
import '../providers/provider_facade.dart';
import 'theme/app_text.dart';
import 'theme/tokens.dart';
import 'widgets/common.dart';
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
        title: Text(_category == null ? 'New entry' : 'New ${_category!.label}'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.huge,
              ),
              child: AnimatedSwitcher(
                duration: AppDurations.base,
                switchInCurve: appEase,
                child: _buildStep(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case _Step.pick:
        return _CategoryPicker(key: const ValueKey('pick'), onPick: _choose);
      case _Step.search:
        return Column(
          key: const ValueKey('search'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackLink('Change category', () => setState(() => _step = _Step.pick)),
            const SizedBox(height: AppSpacing.md),
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
        );
      case _Step.form:
        return Column(
          key: const ValueKey('form'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackLink('Back to search', () => setState(() => _step = _Step.search)),
            const SizedBox(height: AppSpacing.md),
            EntryForm(
              initial: _initial ?? EntryInput(category: _category!),
              submitLabel: 'Save entry',
              onSaved: (_) => Navigator.of(context).pop(),
              onCancel: () => setState(() => _step = _Step.search),
            ),
          ],
        );
    }
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 16, color: AppColors.inkSoft),
            const SizedBox(width: 6),
            Text(label, style: AppText.label(context, color: AppColors.inkSoft)),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({super.key, required this.onPick});
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
        const SectionLabel('Add to library'),
        const SizedBox(height: AppSpacing.sm),
        Text('What are you logging?', style: AppText.title(context)),
        const SizedBox(height: AppSpacing.xl),
        _PickRow(
          icon: Icons.movie_outlined,
          label: 'Movie',
          onTap: () => widget.onPick(Category.movie),
        ),
        _PickRow(
          icon: Icons.live_tv_outlined,
          label: 'TV',
          onTap: () => widget.onPick(Category.tv),
        ),
        _PickRow(
          icon: Icons.menu_book_outlined,
          label: 'Book',
          trailing: AnimatedRotation(
            turns: _bookOpen ? 0.5 : 0,
            duration: AppDurations.fast,
            child: const Icon(Icons.expand_more, size: 18, color: AppColors.inkFaint),
          ),
          onTap: () => setState(() => _bookOpen = !_bookOpen),
        ),
        AnimatedCrossFade(
          duration: AppDurations.base,
          crossFadeState:
              _bookOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xl),
            child: Column(
              children: [
                _PickRow(
                  label: 'Fiction',
                  dense: true,
                  onTap: () => widget.onPick(Category.fiction),
                ),
                _PickRow(
                  label: 'Nonfiction',
                  dense: true,
                  onTap: () => widget.onPick(Category.nonfiction),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.dense = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: dense ? 14 : 18,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.ink),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                label,
                style: dense
                    ? AppText.body(context)
                    : AppText.headline(context).copyWith(fontSize: 18),
              ),
            ),
            trailing ??
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
