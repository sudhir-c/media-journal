import 'package:flutter/widgets.dart';

import 'data/entry_repository.dart';

/// Minimal dependency scope exposing the [EntryRepository] to the widget tree.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.repo, required super.child});

  final EntryRepository repo;

  /// Reads the repository without registering an inherited dependency, so it is
  /// safe to call from initState/field initializers. The repo is a stable
  /// singleton, so there is nothing to depend on.
  static EntryRepository of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.repo;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => repo != oldWidget.repo;
}
