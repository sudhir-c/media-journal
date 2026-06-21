# Media Journal (Flutter / macOS)

A personal, single-user desktop app for logging movies, TV, fiction, and
nonfiction — with quantitative, category-specific ratings and free-form
reactions. This is a Flutter port of the Next.js web app, sharing the same
domain model, rating spec, and metadata providers.

## Stack

- **Flutter** (macOS desktop) + Dart
- **Drift** over **SQLite** (`sqlite3` / `sqlite3_flutter_libs`) — local DB
- **http** for metadata providers
- **fl_chart** for the stats dashboard
- **flutter_dotenv** for the bundled TMDB token
- **file_selector** for JSON export

## Architecture

```
lib/
  core/categories.dart   # single source of truth: CATEGORY_AXES, enums, score
  core/format.dart
  data/
    database.dart        # Drift `entries` table (+ generated database.g.dart)
    entry_repository.dart # list/filter/sort/search + CRUD; SQL stays here
    entry_input.dart     # form model + per-category axis validation
    entry_domain.dart    # typed enums, dynamic axis access, derived score
    stats.dart           # per-category aggregation
    export.dart          # JSON export via save dialog
    seed.dart            # ~2 sample entries per category (if empty)
  providers/             # provider-agnostic adapters (TMDB, Open Library, Google Books)
  ui/                    # library, add flow, entry detail/edit, stats
```

The rating axes live **only** in `core/categories.dart` (`categoryAxes`), which
drives the form, validation, and stats. The overall score is the mean of the
present axis values for an entry's category, computed on read (never stored).
Categories are never compared across each other.

## Getting started

```bash
flutter pub get
dart run build_runner build          # generate Drift code (database.g.dart)
cp .env.example .env                  # then fill in TMDB_READ_TOKEN (optional)
flutter run -d macos
```

The first launch seeds ~2 sample entries per category. The database lives at
`~/Library/Application Support/com.mediajournal.mediaJournal/media_journal.sqlite`.

## TMDB token (movies & TV)

Books need no key (Open Library, with a Google Books fallback). For movie/TV
import, put your **API Read Access Token** (the long JWT, not the v3 key) into
`.env`:

```
TMDB_READ_TOKEN=your_read_access_token_here
```

Get one at themoviedb.org → Settings → API → "Developer". The token is bundled
into the app via the `.env` asset (acceptable for a personal, single-user app;
unlike the web version there is no server to hide it behind). Without a token,
books still work and movie/TV import reports a clear "token not set" message.

## Code signing note (important for local builds)

If the project lives under an **iCloud-synced folder** (e.g. `~/Desktop` or
`~/Documents`), the iCloud daemon continuously stamps the built `.app` with
`com.apple.FinderInfo` / fileprovider extended attributes that `codesign`
rejects:

> resource fork, Finder information, or similar detritus not allowed

To keep local builds working, **code signing is disabled for the Debug config**
(`macos/Runner/Configs/Debug.xcconfig`). Unsigned debug builds run fine
locally. For a signed release build, either move the project to a non-synced
path (e.g. `~/dev/media_journal_flutter`) or re-enable signing.

## Commands

| Command | What it does |
| --- | --- |
| `flutter run -d macos` | Run the app |
| `dart run build_runner build` | Regenerate Drift code after schema changes |
| `flutter analyze` | Static analysis |
| `flutter test` | Domain unit tests |
| `flutter build macos --debug` | Build the macOS app |

## Feature parity with the web app

- Config-driven rating CRUD (create / edit / view / delete)
- Metadata import: TMDB (movies/TV) + Open Library / Google Books (books)
- Library: category & status filters, sort, text search
- Stats: per-category axis averages, score distribution, entries-over-time,
  top-rated
- JSON export of all entries
