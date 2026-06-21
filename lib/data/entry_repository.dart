import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/categories.dart';
import 'database.dart';
import 'entry_domain.dart';
import 'entry_input.dart';

enum SortKey { recent, consumed, overall, title }

const _uuid = Uuid();

/// All entry reads/writes go through here. Drift keeps SQL out of call sites;
/// swapping the underlying store later is localized to [AppDatabase].
class EntryRepository {
  EntryRepository(this.db);
  final AppDatabase db;

  Future<List<Entry>> list({
    Category? category,
    Status? status,
    String? q,
    SortKey sort = SortKey.recent,
  }) async {
    final query = db.select(db.entries);

    if (category != null) {
      query.where((t) => t.category.equals(category.wire));
    }
    if (status != null) {
      query.where((t) => t.status.equals(status.wire));
    }
    final text = q?.trim() ?? '';
    if (text.isNotEmpty) {
      final pattern = '%$text%';
      query.where((t) => t.title.like(pattern) | t.creators.like(pattern));
    }

    switch (sort) {
      case SortKey.title:
        query.orderBy([(t) => OrderingTerm.asc(t.title)]);
      case SortKey.consumed:
        // NULL consumedDate sorts last under DESC in SQLite.
        query.orderBy([
          (t) => OrderingTerm(
            expression: t.consumedDate,
            mode: OrderingMode.desc,
          ),
        ]);
      case SortKey.recent:
      case SortKey.overall:
        query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    }

    var rows = await query.get();

    if (sort == SortKey.overall) {
      // Derived score isn't a column; sort in Dart. Unrated entries sort last.
      rows = [...rows]..sort((a, b) {
        final av = a.overallScore ?? double.negativeInfinity;
        final bv = b.overallScore ?? double.negativeInfinity;
        return bv.compareTo(av);
      });
    }
    return rows;
  }

  Future<Entry?> getById(String id) {
    return (db.select(
      db.entries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<String> create(EntryInput input) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final companion = _common(input, now).copyWith(
      id: Value(id),
      createdAt: Value(now),
    );
    await db.into(db.entries).insert(companion);
    return id;
  }

  Future<bool> update(String id, EntryInput input) async {
    final now = DateTime.now();
    final count = await (db.update(db.entries)..where((t) => t.id.equals(id)))
        .write(_common(input, now));
    return count > 0;
  }

  Future<int> delete(String id) =>
      (db.delete(db.entries)..where((t) => t.id.equals(id))).go();

  /// Companion with every field except `id`/`createdAt`. Axis columns not valid
  /// for the category are forced to null, guaranteeing a clean column set.
  EntriesCompanion _common(EntryInput i, DateTime updatedAt) {
    String? clean(String? v) {
      final t = v?.trim();
      return (t == null || t.isEmpty) ? null : t;
    }

    int? ax(AxisKey k) => i.axisFor(k);

    return EntriesCompanion(
      category: Value(i.category.wire),
      title: Value(i.title.trim()),
      creators: Value(i.creators.trim()),
      year: Value(i.year),
      coverUrl: Value(clean(i.coverUrl)),
      source: Value(i.source.wire),
      externalId: Value(clean(i.externalId)),
      externalRaw: Value(i.externalRaw),
      status: Value(i.status.wire),
      consumedDate: Value(clean(i.consumedDate)),
      entertainment: Value(ax(AxisKey.entertainment)),
      thematicDepth: Value(ax(AxisKey.thematicDepth)),
      atmosphere: Value(ax(AxisKey.atmosphere)),
      performances: Value(ax(AxisKey.performances)),
      narrativeArc: Value(ax(AxisKey.narrativeArc)),
      characters: Value(ax(AxisKey.characters)),
      insight: Value(ax(AxisKey.insight)),
      rigor: Value(ax(AxisKey.rigor)),
      engagement: Value(ax(AxisKey.engagement)),
      pro: Value(i.pro),
      con: Value(i.con),
      notes: Value(i.notes),
      updatedAt: Value(updatedAt),
    );
  }
}
