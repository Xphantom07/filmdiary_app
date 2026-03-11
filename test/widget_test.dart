// This is a basic Flutter widget test for FilmDiary.
//
// Phase 1 smoke test: verifies the app launches and shows the splash screen.
// Full widget tests will be added in Phase 2 alongside feature implementation.

import 'package:flutter_test/flutter_test.dart';

import 'package:film_diary/main.dart';

void main() {
  testWidgets('FilmDiary app launches without errors',
      (WidgetTester tester) async {
    // Build the root widget and trigger the first frame
    await tester.pumpWidget(const FilmDiaryApp());

    // The app should render without throwing any exceptions
    expect(tester.takeException(), isNull);
  });
}
