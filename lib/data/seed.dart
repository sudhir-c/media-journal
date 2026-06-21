import '../core/categories.dart';
import 'entry_input.dart';
import 'entry_repository.dart';

/// Inserts ~2 sample entries per category, but only when the library is empty.
Future<void> seedIfEmpty(EntryRepository repo) async {
  final existing = await repo.list();
  if (existing.isNotEmpty) return;

  final samples = <EntryInput>[
    EntryInput(
      category: Category.movie,
      title: 'Parasite',
      creators: 'Bong Joon-ho',
      year: 2019,
      consumedDate: '2024-01-15',
      axes: {
        AxisKey.entertainment: 9,
        AxisKey.thematicDepth: 10,
        AxisKey.atmosphere: 9,
        AxisKey.performances: 9,
      },
      pro: 'Razor-sharp class satire that never stops being entertaining.',
      con: "The tonal whiplash won't be for everyone.",
      notes: 'The basement reveal recontextualizes the whole film.',
    ),
    EntryInput(
      category: Category.movie,
      title: 'Mad Max: Fury Road',
      creators: 'George Miller',
      year: 2015,
      consumedDate: '2024-02-03',
      axes: {
        AxisKey.entertainment: 10,
        AxisKey.thematicDepth: 7,
        AxisKey.atmosphere: 10,
        AxisKey.performances: 8,
      },
      pro: 'Practical effects and relentless kinetic energy.',
      con: 'Thin on dialogue if you want a talky film.',
      notes: 'A two-hour chase that somehow has a full arc.',
    ),
    EntryInput(
      category: Category.tv,
      title: 'The Wire',
      creators: 'David Simon',
      year: 2002,
      consumedDate: '2024-03-20',
      axes: {
        AxisKey.entertainment: 8,
        AxisKey.thematicDepth: 10,
        AxisKey.atmosphere: 9,
        AxisKey.performances: 9,
        AxisKey.narrativeArc: 10,
      },
      pro: 'Novelistic structure; every season widens the lens.',
      con: 'Slow to hook in the first few episodes.',
      notes: 'Season 4 (the schools) is the emotional peak.',
    ),
    EntryInput(
      category: Category.tv,
      title: 'Severance',
      creators: 'Dan Erickson',
      year: 2022,
      status: Status.inProgress,
      consumedDate: '2025-02-10',
      axes: {
        AxisKey.entertainment: 9,
        AxisKey.thematicDepth: 8,
        AxisKey.atmosphere: 10,
        AxisKey.performances: 9,
        AxisKey.narrativeArc: 8,
      },
      pro: 'Immaculate production design and dread-soaked tone.',
      con: 'Mystery-box pacing tests your patience between reveals.',
      notes: 'The office aesthetic does so much storytelling work.',
    ),
    EntryInput(
      category: Category.fiction,
      title: 'The Left Hand of Darkness',
      creators: 'Ursula K. Le Guin',
      year: 1969,
      consumedDate: '2024-05-01',
      axes: {
        AxisKey.entertainment: 7,
        AxisKey.thematicDepth: 10,
        AxisKey.atmosphere: 9,
        AxisKey.characters: 9,
      },
      pro: 'Gethen is one of the great thought-experiment worlds.',
      con: 'The middle journey across the ice drags a touch.',
      notes: 'Estraven is quietly devastating by the end.',
    ),
    EntryInput(
      category: Category.fiction,
      title: 'Piranesi',
      creators: 'Susanna Clarke',
      year: 2020,
      consumedDate: '2024-06-12',
      axes: {
        AxisKey.entertainment: 8,
        AxisKey.thematicDepth: 9,
        AxisKey.atmosphere: 10,
        AxisKey.characters: 8,
      },
      pro: 'The House is hauntingly realized; pure atmosphere.',
      con: 'Deliberately disorienting early on.',
      notes: 'A book about wonder and captivity at once.',
    ),
    EntryInput(
      category: Category.nonfiction,
      title: 'Thinking, Fast and Slow',
      creators: 'Daniel Kahneman',
      year: 2011,
      consumedDate: '2024-07-08',
      axes: {
        AxisKey.insight: 9,
        AxisKey.rigor: 8,
        AxisKey.engagement: 7,
      },
      pro: 'Foundational framing of System 1 vs System 2.',
      con: "Some studies cited haven't aged well in replication.",
      notes: 'Worth it for the framing even if you skim the studies.',
    ),
    EntryInput(
      category: Category.nonfiction,
      title: 'The Sixth Extinction',
      creators: 'Elizabeth Kolbert',
      year: 2014,
      status: Status.want,
      notes: "On the shelf — haven't started it yet.",
    ),
  ];

  for (final input in samples) {
    await repo.create(input);
  }
}
