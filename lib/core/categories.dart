/// Single source of truth for categories and their rating axes.
///
/// This config drives the add/edit rating form, validation, and the stats
/// page. Do NOT hardcode axes anywhere else.
///
/// The `atmosphere` column is reused for the "vibe" axis across
/// movie/tv/fiction with a per-category label. Nonfiction uses none of the
/// narrative axes.
library;

enum Category { movie, tv, fiction, nonfiction }

enum AxisKey {
  entertainment,
  thematicDepth,
  atmosphere,
  performances,
  narrativeArc,
  characters,
  insight,
  rigor,
  engagement,
}

enum Status { want, inProgress, done }

enum Source { tmdb, openlibrary, googlebooks, manual }

class Axis {
  final AxisKey key;
  final String label;
  const Axis(this.key, this.label);
}

const Map<Category, List<Axis>> categoryAxes = {
  Category.movie: [
    Axis(AxisKey.entertainment, 'Entertainment'),
    Axis(AxisKey.thematicDepth, 'Thematic depth'),
    Axis(AxisKey.atmosphere, 'Atmosphere & vibe'),
    Axis(AxisKey.performances, 'Performances'),
  ],
  Category.tv: [
    Axis(AxisKey.entertainment, 'Entertainment'),
    Axis(AxisKey.thematicDepth, 'Thematic depth'),
    Axis(AxisKey.atmosphere, 'Atmosphere & vibe'),
    Axis(AxisKey.performances, 'Performances'),
    Axis(AxisKey.narrativeArc, 'Narrative arc & payoff'),
  ],
  Category.fiction: [
    Axis(AxisKey.entertainment, 'Entertainment'),
    Axis(AxisKey.thematicDepth, 'Thematic depth'),
    Axis(AxisKey.atmosphere, 'Setting & worldbuilding'), // reuses "vibe" column
    Axis(AxisKey.characters, 'Characters'),
  ],
  Category.nonfiction: [
    Axis(AxisKey.insight, 'Insight'),
    Axis(AxisKey.rigor, 'Rigor'),
    Axis(AxisKey.engagement, 'Engagement'),
  ],
};

const List<Category> categories = Category.values;

const int axisMin = 1;
const int axisMax = 10;

extension CategoryX on Category {
  /// Stable wire/storage name (matches the web app's enum values).
  String get wire => name; // movie | tv | fiction | nonfiction
  String get label => switch (this) {
    Category.movie => 'Movie',
    Category.tv => 'TV',
    Category.fiction => 'Fiction',
    Category.nonfiction => 'Nonfiction',
  };
  List<Axis> get axes => categoryAxes[this]!;
  List<AxisKey> get axisKeys => axes.map((a) => a.key).toList();
}

extension AxisKeyX on AxisKey {
  /// snake_case storage/JSON name (matches the web app's column names).
  String get wire => switch (this) {
    AxisKey.thematicDepth => 'thematic_depth',
    AxisKey.narrativeArc => 'narrative_arc',
    _ => name,
  };
}

extension StatusX on Status {
  String get wire => switch (this) {
    Status.want => 'want',
    Status.inProgress => 'in_progress',
    Status.done => 'done',
  };
  String get label => switch (this) {
    Status.want => 'Want',
    Status.inProgress => 'In progress',
    Status.done => 'Done',
  };
}

extension SourceX on Source {
  String get wire => name;
}

Category categoryFromWire(String value) =>
    Category.values.firstWhere((c) => c.wire == value);

Status statusFromWire(String value) =>
    Status.values.firstWhere((s) => s.wire == value, orElse: () => Status.done);

Source sourceFromWire(String value) =>
    Source.values.firstWhere((s) => s.wire == value, orElse: () => Source.manual);

AxisKey? axisKeyFromWire(String value) {
  for (final k in AxisKey.values) {
    if (k.wire == value) return k;
  }
  return null;
}

bool isAxisValidForCategory(Category category, AxisKey key) =>
    category.axisKeys.contains(key);

/// Derived overall score: the mean of the present axis values for the entry's
/// category. Returns null when no axis for the category has a value.
double? computeOverallScore(Category category, Map<AxisKey, int?> values) {
  final present = <int>[];
  for (final key in category.axisKeys) {
    final v = values[key];
    if (v != null) present.add(v);
  }
  if (present.isEmpty) return null;
  return present.reduce((a, b) => a + b) / present.length;
}
