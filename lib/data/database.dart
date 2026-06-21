import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Single table for all media entries, mirroring the web app's schema.
/// Axis columns are nullable integers (valid range 1-10, enforced in the
/// repository/validation layer). Only the axes listed for an entry's category
/// should be set.
class Entries extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get creators => text().withDefault(const Constant(''))();
  IntColumn get year => integer().nullable()();
  TextColumn get coverUrl => text().named('cover_url').nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  TextColumn get externalId => text().named('external_id').nullable()();
  // Snapshot of fetched provider metadata, stored as a JSON string.
  TextColumn get externalRaw => text().named('external_raw').nullable()();
  TextColumn get status => text().withDefault(const Constant('done'))();
  // ISO date string (YYYY-MM-DD) the item was watched/read.
  TextColumn get consumedDate => text().named('consumed_date').nullable()();

  // Axis columns (nullable). See categoryAxes for which apply per category.
  IntColumn get entertainment => integer().nullable()();
  IntColumn get thematicDepth => integer().named('thematic_depth').nullable()();
  IntColumn get atmosphere => integer().nullable()();
  IntColumn get performances => integer().nullable()();
  IntColumn get narrativeArc => integer().named('narrative_arc').nullable()();
  IntColumn get characters => integer().nullable()();
  IntColumn get insight => integer().nullable()();
  IntColumn get rigor => integer().nullable()();
  IntColumn get engagement => integer().nullable()();

  TextColumn get pro => text().withDefault(const Constant(''))();
  TextColumn get con => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Entries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test/in-memory constructor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'media_journal.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
