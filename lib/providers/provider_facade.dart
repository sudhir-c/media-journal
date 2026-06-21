import '../core/categories.dart';
import 'books.dart';
import 'tmdb.dart';
import 'types.dart';

export 'types.dart' show NormalizedResult, ProviderException;

/// Provider-agnostic search. Movies/TV -> TMDB; fiction/nonfiction -> books
/// (Open Library primary, Google Books fallback). Each result carries its own
/// source for the subsequent details fetch.
Future<List<NormalizedResult>> searchProviders(
  Category category,
  String query,
) {
  final q = query.trim();
  if (q.isEmpty) return Future.value(const []);
  return isBookCategory(category) ? bookSearch(category, q) : tmdbSearch(category, q);
}

/// Source-aware details fetch used to enrich + snapshot a selected result.
Future<NormalizedResult> getProviderDetails(Source source, String externalId) {
  if (source == Source.tmdb) return tmdbDetails(externalId);
  return bookDetails(source, externalId);
}
