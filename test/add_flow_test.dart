// Verifies the fix for "new entry doesn't show up after adding": the library
// now consumes a reactive Drift stream (repo.watch), so an insert pushes an
// updated list to the UI with no manual refresh. This tests that mechanism
// directly at the repository level.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_journal/core/categories.dart';
import 'package:media_journal/data/database.dart';
import 'package:media_journal/data/entry_input.dart';
import 'package:media_journal/data/entry_repository.dart';

void main() {
  test('watch() emits an updated list immediately when an entry is created', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = EntryRepository(db);

    final emissions = <List<Entry>>[];
    final sub = repo.watch().listen(emissions.add);

    // Initial emission: empty library.
    await pumpEventQueue();
    expect(emissions.last, isEmpty);

    // Creating an entry pushes a new emission containing it — no manual reload.
    await repo.create(EntryInput(category: Category.movie, title: 'Test Movie'));
    await pumpEventQueue();

    expect(emissions.last.map((e) => e.title), contains('Test Movie'));

    await sub.cancel();
    await db.close();
  });

  test('watch() reflects deletions too', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = EntryRepository(db);

    final id = await repo.create(
      EntryInput(category: Category.movie, title: 'Temp'),
    );

    final emissions = <List<Entry>>[];
    final sub = repo.watch().listen(emissions.add);
    await pumpEventQueue();
    expect(emissions.last, hasLength(1));

    await repo.delete(id);
    await pumpEventQueue();
    expect(emissions.last, isEmpty);

    await sub.cancel();
    await db.close();
  });
}
