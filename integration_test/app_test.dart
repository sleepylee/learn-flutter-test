import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:learn_test/main.dart';

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('Scrolling test', (tester) async {
      await tester.pumpWidget(MyApp());

      final listFinder = find.byType(ListView);

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    });

    testWidgets('Favorites operations test', (tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      expect(find.text('Added to favorites.'), findsOneWidget);

      AppBar appBar = tester.widget(find.byType(AppBar));

      (appBar.actions[0] as IconButton).onPressed();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle(Duration(milliseconds: 300));
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
