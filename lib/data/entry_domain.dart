import '../core/categories.dart';
import 'database.dart';
import 'entry_input.dart';

/// Domain helpers layered over the Drift-generated [Entry] data class:
/// typed enums, dynamic axis access, and the derived overall score.
extension EntryDomain on Entry {
  Category get categoryEnum => categoryFromWire(category);
  Status get statusEnum => statusFromWire(status);
  Source get sourceEnum => sourceFromWire(source);

  int? axis(AxisKey key) => switch (key) {
    AxisKey.entertainment => entertainment,
    AxisKey.thematicDepth => thematicDepth,
    AxisKey.atmosphere => atmosphere,
    AxisKey.performances => performances,
    AxisKey.narrativeArc => narrativeArc,
    AxisKey.characters => characters,
    AxisKey.insight => insight,
    AxisKey.rigor => rigor,
    AxisKey.engagement => engagement,
  };

  Map<AxisKey, int?> get axisValues => {
    for (final k in categoryEnum.axisKeys) k: axis(k),
  };

  /// Derived (never stored): mean of present axis values for this category.
  double? get overallScore => computeOverallScore(categoryEnum, axisValues);
}

/// Builds an editable input model from a stored entry.
EntryInput entryToInput(Entry e) => EntryInput(
  category: e.categoryEnum,
  title: e.title,
  creators: e.creators,
  year: e.year,
  coverUrl: e.coverUrl,
  source: e.sourceEnum,
  externalId: e.externalId,
  externalRaw: e.externalRaw,
  status: e.statusEnum,
  consumedDate: e.consumedDate,
  axes: {for (final k in e.categoryEnum.axisKeys) k: e.axis(k)},
  pro: e.pro,
  con: e.con,
  notes: e.notes,
);
