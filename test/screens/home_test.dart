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
      await tester.pumpWidget(createHomeScreen());
      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.widgetWithIcon(IconButton, Icons.favorite_border), findsWidgets);
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.widgetWithIcon(IconButton, Icons.favorite_border).at(1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text('Added to favorites.'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });
  });
}
