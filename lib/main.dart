import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_scope.dart';
import 'data/database.dart';
import 'data/entry_repository.dart';
import 'ui/library_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load the bundled .env for the TMDB token; tolerate it being absent.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // No .env bundled — books still work; TMDB will report a missing token.
  }

  final repo = EntryRepository(AppDatabase());

  runApp(MediaJournalApp(repo: repo));
}

class MediaJournalApp extends StatelessWidget {
  const MediaJournalApp({super.key, required this.repo});

  final EntryRepository repo;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF18181B),
      brightness: Brightness.light,
    );
    return AppScope(
      repo: repo,
      child: MaterialApp(
        title: 'Media Journal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: scheme,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LibraryPage(),
      ),
    );
  }
}
