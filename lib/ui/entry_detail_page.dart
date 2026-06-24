import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../core/categories.dart';
import '../core/format.dart';
import '../data/database.dart';
import '../data/entry_domain.dart';
import 'theme/app_text.dart';
import 'theme/media_palette.dart';
import 'theme/tokens.dart';
import 'widgets/animated_gradient_border.dart';
import 'widgets/common.dart';
import 'widgets/cover_image.dart';
import 'widgets/entry_form.dart';
import 'widgets/rating_input.dart';
import 'widgets/shimmer_text.dart';

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
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
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
    messenger.showSnackBar(const SnackBar(content: Text('Deleted')));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: !_editing,
      appBar: AppBar(
        backgroundColor: _editing ? AppColors.paper : Colors.transparent,
        title: _editing ? const Text('Edit entry') : null,
      ),
      body: FutureBuilder<Entry?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final entry = snapshot.data;
          if (entry == null) {
            return Center(
              child: Text('Entry not found.', style: AppText.meta(context)),
            );
          }
          if (_editing) {
            return SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.huge,
                    ),
                    child: EntryForm(
                      initial: entryToInput(entry),
                      entryId: entry.id,
                      submitLabel: 'Save changes',
                      onSaved: (_) {
                        setState(() => _editing = false);
                        _reload();
                      },
                      onCancel: () => setState(() => _editing = false),
                    ),
                  ),
                ),
              ),
            );
          }
          return _DetailView(
            entry: entry,
            onEdit: () => setState(() => _editing = true),
            onDelete: () => _confirmDelete(entry),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── detail view ───

class _DetailView extends StatefulWidget {
  const _DetailView({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final Entry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  MediaPalette _palette = MediaPalette.neutral;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _extract();
  }

  Future<void> _extract() async {
    final url = widget.entry.coverUrl;
    final palette = await extractMediaPalette(
      (url == null || url.isEmpty) ? null : NetworkImage(url),
    );
    if (mounted) {
      setState(() {
        _palette = palette;
        _ready = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final p = _palette;
    final meta = [
      e.creators,
      if (e.year != null) '${e.year}',
    ].where((s) => s.isNotEmpty).join('  ·  ');
    final consumed = formatConsumedDate(e.consumedDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Wash spans the full viewport width and scales its height to the
        // window so the gradient always tracks the screen size.
        final washHeight = (constraints.maxHeight * 0.52).clamp(300.0, 560.0);
        return Stack(
          children: [
            // Bold ambient accent wash that fades in once the palette resolves.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: washHeight,
              child: _AnimatedWash(palette: p, ready: _ready),
            ),
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.huge,
                      AppSpacing.lg,
                      AppSpacing.huge,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(context, e, p, meta, consumed),
                        const SizedBox(height: AppSpacing.xxl),
                        _ratings(context, e, p),
                        _reflections(context, e, p),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    Entry e,
    MediaPalette p,
    String meta,
    String? consumed,
  ) {
    final cover = _Cover(entry: e, palette: p, ready: _ready);
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AppChip(
              e.categoryEnum.label,
              background: p.tint,
              foreground: p.primary,
            ),
            AppChip(
              e.statusEnum.label,
              background: p.tint,
              foreground: p.primary,
            ),
            if (e.sourceEnum != Source.manual)
              AppChip('via ${e.source}', background: AppColors.fill),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(e.title, style: AppText.title(context).copyWith(fontSize: 32)),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(meta, style: AppText.body(context, color: AppColors.inkSoft)),
        ],
        if (consumed != null) ...[
          const SizedBox(height: 2),
          Text('Consumed $consumed', style: AppText.meta(context)),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (e.overallScore != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              ShimmerText(
                text: formatScore(e.overallScore),
                style: AppText.numeral(context, color: p.primary),
                baseColor: p.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('overall', style: AppText.meta(context)),
              ),
            ],
          )
        else
          Text('Not rated yet', style: AppText.meta(context)),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            FilledButton.icon(
              onPressed: widget.onEdit,
              style: FilledButton.styleFrom(
                backgroundColor: p.primary,
                foregroundColor: p.onPrimary,
              ),
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit'),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_outline, size: 17),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth > 560) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 200, child: cover),
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: details),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 180, child: cover),
            const SizedBox(height: AppSpacing.xl),
            details,
          ],
        );
      },
    );
  }

  Widget _ratings(BuildContext context, Entry e, MediaPalette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel('Ratings', color: p.primary),
        const SizedBox(height: AppSpacing.md),
        ...e.categoryEnum.axes.map(
          (axis) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: RatingMeter(
              label: axis.label,
              value: e.axis(axis.key),
              accent: p.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _reflections(BuildContext context, Entry e, MediaPalette p) {
    final fields = <(String, String)>[
      if (e.pro.isNotEmpty) ('What worked', e.pro),
      if (e.con.isNotEmpty) ("What didn't", e.con),
      if (e.notes.isNotEmpty) ('Notes', e.notes),
    ];
    if (fields.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel('Reflections', color: p.primary),
          const SizedBox(height: AppSpacing.md),
          for (final (label, value) in fields)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kReadingMaxWidth),
                child: AnimatedGradientBorder(
                  colorA: p.primary,
                  colorB: p.secondary,
                  radius: AppRadii.md,
                  thickness: 1.5,
                  backgroundColor: p.tint.withValues(alpha: 0.4),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionLabel(label, color: p.primary),
                        const SizedBox(height: AppSpacing.xs),
                        Text(value, style: AppText.reading(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({
    required this.entry,
    required this.palette,
    required this.ready,
  });

  final Entry entry;
  final MediaPalette palette;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.slow,
      curve: appEase,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.cover + 3),
        boxShadow: [
          BoxShadow(
            color: ready
                ? palette.primary.withValues(alpha: 0.5)
                : const Color(0x1A000000),
            blurRadius: 56,
            spreadRadius: -6,
            offset: const Offset(0, 24),
          ),
          if (ready)
            BoxShadow(
              color: palette.secondary.withValues(alpha: 0.3),
              blurRadius: 36,
              spreadRadius: -10,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: AnimatedGradientBorder(
        colorA: palette.primary,
        colorB: palette.secondary,
        radius: AppRadii.cover + 3,
        thickness: 3,
        period: const Duration(seconds: 7),
        child: PosterFrame(
          url: entry.coverUrl,
          heroTag: 'cover_${entry.id}',
          elevated: false,
        ),
      ),
    );
  }
}

/// Ambient accent wash with a flowing, intensified gradient: the colored band
/// breathes vertically while a soft accent glow drifts across the width. Stays
/// vertical at the base so it always resolves to paper (no horizontal seam).
class _AnimatedWash extends StatefulWidget {
  const _AnimatedWash({required this.palette, required this.ready});

  final MediaPalette palette;
  final bool ready;

  @override
  State<_AnimatedWash> createState() => _AnimatedWashState();
}

class _AnimatedWashState extends State<_AnimatedWash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _frame(double t) {
    final p = widget.palette;
    final mid = 0.34 + 0.12 * t;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(
                  p.secondary.withValues(alpha: 0.7),
                  AppColors.paper,
                ),
                Color.alphaBlend(
                  p.primary.withValues(alpha: 0.52),
                  AppColors.paper,
                ),
                AppColors.paper,
              ],
              stops: [0.0, mid, 1.0],
            ),
          ),
        ),
        // Soft accent glow drifting horizontally — the flow.
        Align(
          alignment: Alignment(-0.85 + 1.7 * t, -0.5),
          child: FractionallySizedBox(
            widthFactor: 0.95,
            heightFactor: 0.9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.72,
                  colors: [
                    p.secondary.withValues(alpha: 0.36),
                    p.secondary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final child = reduceMotion
        ? _frame(0.5)
        : AnimatedBuilder(
            animation: _c,
            builder: (context, _) => _frame(_c.value),
          );
    return AnimatedOpacity(
      opacity: widget.ready ? 1 : 0,
      duration: AppDurations.slow,
      child: child,
    );
  }
}
