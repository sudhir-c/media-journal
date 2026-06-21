import '../core/categories.dart';
import 'types.dart';

/// Book metadata. Open Library is primary (no key); Google Books is the
/// fallback when Open Library returns nothing. Each result carries its own
/// source so getDetails routes correctly. Fiction vs nonfiction is chosen
/// manually in the add flow — never inferred here.

// --- Open Library -----------------------------------------------------------

const _olBase = 'https://openlibrary.org';
const _olCover = 'https://covers.openlibrary.org/b/id';

String _olWorkId(String key) => key.replaceFirst('/works/', '');

String? _olCoverUrl(Object? coverId) =>
    coverId is int ? '$_olCover/$coverId-L.jpg' : null;

Future<List<NormalizedResult>> _olSearch(String query) async {
  final url =
      '$_olBase/search.json?q=${Uri.encodeComponent(query)}&limit=12'
      '&fields=key,title,author_name,first_publish_year,cover_i';
  final data = await fetchJson(url, label: 'Open Library');
  final docs = (data['docs'] as List?) ?? [];
  return docs
      .where((d) => d['title'] != null)
      .map<NormalizedResult>((d) {
        final m = d as Map<String, dynamic>;
        final authors = (m['author_name'] as List?)?.cast<String>() ?? [];
        return NormalizedResult(
          source: Source.openlibrary,
          externalId: _olWorkId(m['key'] as String),
          title: m['title'] as String? ?? 'Untitled',
          year: m['first_publish_year'] as int?,
          creators: joinCreators(authors),
          coverUrl: _olCoverUrl(m['cover_i']),
          raw: m,
        );
      })
      .toList();
}

Future<String?> _olAuthorName(String authorKey) async {
  try {
    final data = await fetchJson(
      '$_olBase$authorKey.json',
      label: 'Open Library',
      timeout: const Duration(seconds: 4),
    );
    return data['name'] as String?;
  } catch (_) {
    return null;
  }
}

Future<NormalizedResult> _olDetails(String workId) async {
  final work =
      await fetchJson('$_olBase/works/$workId.json', label: 'Open Library')
          as Map<String, dynamic>;
  final authorKeys = ((work['authors'] as List?) ?? [])
      .map((a) => a['author']?['key'] as String?)
      .whereType<String>()
      .take(4)
      .toList();
  final names = await Future.wait(authorKeys.map(_olAuthorName));
  final covers = (work['covers'] as List?)?.cast<int>();
  return NormalizedResult(
    source: Source.openlibrary,
    externalId: workId,
    title: work['title'] as String? ?? 'Untitled',
    year: parseYear(work['first_publish_date']),
    creators: joinCreators(names),
    coverUrl: _olCoverUrl(covers != null && covers.isNotEmpty ? covers.first : null),
    raw: work,
  );
}

// --- Google Books (fallback) ------------------------------------------------

const _gbBase = 'https://www.googleapis.com/books/v1/volumes';

NormalizedResult _gbNormalize(Map<String, dynamic> v) {
  final info = (v['volumeInfo'] as Map<String, dynamic>?) ?? {};
  final links = info['imageLinks'] as Map<String, dynamic>?;
  final thumb = (links?['thumbnail'] ?? links?['smallThumbnail']) as String?;
  final authors = (info['authors'] as List?)?.cast<String>() ?? [];
  return NormalizedResult(
    source: Source.googlebooks,
    externalId: v['id'] as String,
    title: info['title'] as String? ?? 'Untitled',
    year: parseYear(info['publishedDate']),
    creators: joinCreators(authors),
    coverUrl: thumb?.replaceFirst('http:', 'https:'),
    raw: v,
  );
}

Future<List<NormalizedResult>> _gbSearch(String query) async {
  final data = await fetchJson(
    '$_gbBase?q=${Uri.encodeComponent(query)}&maxResults=12',
    label: 'Google Books',
  );
  final items = (data['items'] as List?) ?? [];
  return items
      .map<NormalizedResult>((v) => _gbNormalize(v as Map<String, dynamic>))
      .toList();
}

Future<NormalizedResult> _gbDetails(String volumeId) async {
  final data = await fetchJson(
    '$_gbBase/${Uri.encodeComponent(volumeId)}',
    label: 'Google Books',
  ) as Map<String, dynamic>;
  return _gbNormalize(data);
}

// --- Combined ---------------------------------------------------------------

Future<List<NormalizedResult>> bookSearch(Category category, String query) async {
  final primary = await _olSearch(query);
  if (primary.isNotEmpty) return primary;
  return _gbSearch(query); // only when Open Library returns nothing
}

Future<NormalizedResult> bookDetails(Source source, String externalId) {
  if (source == Source.googlebooks) return _gbDetails(externalId);
  return _olDetails(externalId);
}
