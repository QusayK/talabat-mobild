import 'package:flutter/cupertino.dart';

import '../models/menu_item.dart';
import 'databaseProvider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<MenuItem> _favorites = [];

  get favorites => _favorites;

  set favorites(List<MenuItem> favorites) {
    _favorites = favorites;
    notifyListeners();
  }

  isExists(MenuItem favorite) {
    return _favorites.indexOf(favorite) != -1 ? true : false;
  }

  add(MenuItem favorite) {
    _favorites.add(favorite);

    notifyListeners();

    DatabaseProvider.db.addFavorite(favorite);
  }

  remove(MenuItem favorite) {
    _favorites.remove(favorite);

    notifyListeners();

    DatabaseProvider.db.deleteFavorite(favorite.id);
  }
}
