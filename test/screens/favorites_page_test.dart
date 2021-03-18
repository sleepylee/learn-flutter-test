import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:learn_test/models/favorites.dart';
import 'package:learn_test/screens/favorites_page.dart';

Favorites favoritesList;

Widget createFavoritesPageScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) {
        favoritesList = Favorites();
        return favoritesList;
      },
      child: MaterialApp(
        home: FavoritesPage(),
      ),
    );

void addFakeItems() {
  for (var i = 0; i < 10; i += 2) {
    favoritesList.add(i);
  }
}

void main() {
  group('Favorites Page Widget Tests', () {
    testWidgets('When come in FavoritesPage, it shows ListView',
        (tester) async {
      await tester.pumpWidget(createFavoritesPageScreen());
      addFakeItems();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('When unfavorite an item, it shows lesser items', (tester) async {
      await tester.pumpWidget(createFavoritesPageScreen());
      addFakeItems();
      await tester.pumpAndSettle();
      var totalItems = tester.widgetList(find.byIcon(Icons.close)).length;

      // Tap on 'X' to un-favorite an item
      IconButton unFavorite = find
          .widgetWithIcon(IconButton, Icons.close)
          .evaluate()
          .first
          .widget;
      unFavorite.onPressed();
      await tester.pumpAndSettle(Duration(seconds: 1));
      var totalItemsAfter = tester.widgetList(find.byIcon(Icons.close)).length;

      // Expect the amount of items is lesser than before; a toast notifies an Item removed
      expect(totalItemsAfter, lessThan(totalItems));
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
