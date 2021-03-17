import 'package:test/test.dart';
import 'package:learn_test/models/favorites.dart';

void main() {
  group('When add or remove a new item', () {
    var fav = Favorites();
    var number = 35;

    test('it contains item when adding', () {
      fav.add(number);
      expect(fav.items.contains(number), true);
    });

    test('it does not contain item when removed', () {
      fav.remove(number);
      expect(fav.items.contains(number), false);
    });
  });
}
