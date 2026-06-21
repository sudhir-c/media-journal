import '../core/categories.dart';

/// Mutable form/input model for creating and editing entries. Mirrors the
/// web app's Zod-validated input contract.
class EntryInput {
  Category category;
  String title;
  String creators;
  int? year;
  String? coverUrl;
  Source source;
  String? externalId;
  String? externalRaw; // JSON string snapshot
  Status status;
  String? consumedDate; // YYYY-MM-DD
  Map<AxisKey, int?> axes;
  String pro;
  String con;
  String notes;

  EntryInput({
    required this.category,
    this.title = '',
    this.creators = '',
    this.year,
    this.coverUrl,
    this.source = Source.manual,
    this.externalId,
    this.externalRaw,
    this.status = Status.done,
    this.consumedDate,
    Map<AxisKey, int?>? axes,
    this.pro = '',
    this.con = '',
    this.notes = '',
  }) : axes = axes ?? {};

  static final _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Returns a map of field-key -> error message. Empty means valid.
  /// Axis errors are keyed by the axis wire name.
  Map<String, String> validate() {
    final errors = <String, String>{};

    if (title.trim().isEmpty) {
      errors['title'] = 'Title is required';
    }
    if (year != null && (year! < 0 || year! > 3000)) {
      errors['year'] = 'Enter a valid year';
    }
    final cover = coverUrl?.trim() ?? '';
    if (cover.isNotEmpty) {
      final uri = Uri.tryParse(cover);
      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
        errors['coverUrl'] = 'Must be a valid URL';
      }
    }
    final date = consumedDate?.trim() ?? '';
    if (date.isNotEmpty && !_datePattern.hasMatch(date)) {
      errors['consumedDate'] = 'Use YYYY-MM-DD';
    }

    final validKeys = category.axisKeys.toSet();
    axes.forEach((key, value) {
      if (value == null) return;
      if (!validKeys.contains(key)) {
        errors[key.wire] = '"${key.wire}" is not valid for ${category.wire}';
      } else if (value < axisMin || value > axisMax) {
        errors[key.wire] = 'Must be $axisMin–$axisMax';
      }
    });

    return errors;
  }

  /// Axis value for a key, only if it belongs to this category.
  int? axisFor(AxisKey key) =>
      category.axisKeys.contains(key) ? axes[key] : null;
}
