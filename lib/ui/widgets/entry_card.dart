import 'package:flutter/material.dart';

import '../../core/categories.dart';
import '../../data/database.dart';
import '../../data/entry_domain.dart';
import '../theme/app_text.dart';
import '../theme/tokens.dart';
import 'common.dart';
import 'cover_image.dart';

/// A single library cell: a cover presented like an object on a shelf, with
/// quiet editorial text beneath. No card chrome — covers carry the personality.
class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry, required this.onTap});

  final Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = [
      entry.creators,
      if (entry.year != null) '${entry.year}',
    ].where((s) => s.isNotEmpty).join('  ·  ');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: PosterFrame(
                url: entry.coverUrl,
                heroTag: 'cover_${entry.id}',
                fill: true,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitle(context),
                ),
              ),
              if (entry.overallScore != null) ...[
                const SizedBox(width: AppSpacing.xs),
                ScoreBadge(entry.overallScore),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            meta.isEmpty ? entry.categoryEnum.label : meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.meta(context),
          ),
          if (entry.statusEnum != Status.done) ...[
            const SizedBox(height: 6),
            SectionLabel(entry.statusEnum.label),
          ],
        ],
      ),
    );
  }
}
