// Smoke tests for the domain layer that don't require a database connection.

import 'package:flutter_test/flutter_test.dart';
import 'package:media_journal/core/categories.dart';

void main() {
  test('overall score is the mean of present axis values', () {
    final score = computeOverallScore(Category.movie, {
      AxisKey.entertainment: 8,
      AxisKey.thematicDepth: 7,
      AxisKey.atmosphere: 9,
      AxisKey.performances: 6,
    });
    expect(score, 7.5);
  });

  test('overall score ignores nulls', () {
    final score = computeOverallScore(Category.nonfiction, {
      AxisKey.insight: 9,
      AxisKey.rigor: 8,
      AxisKey.engagement: 9,
    });
    expect(score, closeTo(8.666, 0.01));
  });

  test('wire names match the web schema', () {
    expect(Category.nonfiction.wire, 'nonfiction');
    expect(Status.inProgress.wire, 'in_progress');
    expect(AxisKey.thematicDepth.wire, 'thematic_depth');
    expect(AxisKey.narrativeArc.wire, 'narrative_arc');
  });
}
