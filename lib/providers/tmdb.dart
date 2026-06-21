import '../core/categories.dart';
import 'config.dart';
import 'types.dart';

/// TMDB provider for movies and TV. The externalId is encoded as
/// `movie:ID` / `tv:ID` so getDetails can route to the right endpoint.
const _apiBase = 'https://api.themoviedb.org/3';
const _imageBase = 'https://image.tmdb.org/t/p/w500';

String _token() {
  final t = tmdbToken;
  if (t == null) {
    throw ProviderException(
      'TMDB_READ_TOKEN is not set. Add it to .env to import movies and TV.',
    );
  }
  return t;
}

Future<dynamic> _tmdbFetch(String path) {
  return fetchJson(
    '$_apiBase$path',
    label: 'TMDB',
    headers: {
      'Authorization': 'Bearer ${_token()}',
      'accept': 'application/json',
    },
  );
}

String? _poster(Object? path) =>
    (path is String && path.isNotEmpty) ? '$_imageBase$path' : null;

Future<List<NormalizedResult>> tmdbSearch(Category category, String query) async {
  final kind = category == Category.tv ? 'tv' : 'movie';
  final data = await _tmdbFetch(
    '/search/$kind?query=${Uri.encodeComponent(query)}&include_adult=false',
  );
  final results = (data['results'] as List?) ?? [];
  return results.map<NormalizedResult>((item) {
    final m = item as Map<String, dynamic>;
    return NormalizedResult(
      source: Source.tmdb,
      externalId: '$kind:${m['id']}',
      title: (kind == 'movie' ? m['title'] : m['name']) as String? ?? 'Untitled',
      year: parseYear(kind == 'movie' ? m['release_date'] : m['first_air_date']),
      creators: '', // filled by getDetails
      coverUrl: _poster(m['poster_path']),
      raw: m,
    );
  }).toList();
}

Future<NormalizedResult> tmdbDetails(String externalId) async {
  final parts = externalId.split(':');
  if (parts.length != 2 || (parts[0] != 'movie' && parts[0] != 'tv')) {
    throw ProviderException('Invalid TMDB id: $externalId');
  }
  final kind = parts[0];
  final id = parts[1];

  if (kind == 'movie') {
    final m = await _tmdbFetch('/movie/$id?append_to_response=credits')
        as Map<String, dynamic>;
    final crew = ((m['credits']?['crew']) as List?) ?? [];
    final directors = crew
        .where((c) => c['job'] == 'Director')
        .map((c) => c['name'] as String?);
    return NormalizedResult(
      source: Source.tmdb,
      externalId: externalId,
      title: m['title'] as String? ?? 'Untitled',
      year: parseYear(m['release_date']),
      creators: joinCreators(directors),
      coverUrl: _poster(m['poster_path']),
      raw: m,
    );
  }

  final m = await _tmdbFetch('/tv/$id') as Map<String, dynamic>;
  final createdBy = ((m['created_by']) as List?) ?? [];
  return NormalizedResult(
    source: Source.tmdb,
    externalId: externalId,
    title: m['name'] as String? ?? 'Untitled',
    year: parseYear(m['first_air_date']),
    creators: joinCreators(createdBy.map((c) => c['name'] as String?)),
    coverUrl: _poster(m['poster_path']),
    raw: m,
  );
}
