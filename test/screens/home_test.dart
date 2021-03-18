import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:learn_test/models/favorites.dart';
import 'package:learn_test/screens/home.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(home: HomePage()),
    );

void main() {
  group('Group test home widget', () {
    testWidgets('Scrolling should perform correctly', (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1110, 1900);

      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Item 0'), findsOneWidget);

      await tester.fling(find.byType(ListView), Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    });

    testWidgets('Test tap on Favorite an Item', (tester) async {
      // Init, pump the Home widget up for testing
      await tester.pumpWidget(createHomeScreen());

      // Expect there is NO favorite item yet
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap on Favorite the 1st item, note that tester.tap doesn't work as expected on IconButton
      IconButton fav = find
          .widgetWithIcon(IconButton, Icons.favorite_border)
          .evaluate()
          .first
          .widget;
      fav.onPressed();
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Expect to see there is an Favorite item - filled heart icon; a toast show up
      expect(find.byIcon(Icons.favorite), findsWidgets);
      expect(find.text('Added to favorites.'), findsOneWidget);

      // Tap on Favorite the 1st item again, now expect it to be removed
      IconButton unFavorite = find
          .widgetWithIcon(IconButton, Icons.favorite)
          .evaluate()
          .first
          .widget;
      unFavorite.onPressed();
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Expect to see there is NO Favorite item; a toast show up notifies Removed
      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
