import 'package:flutter/cupertino.dart';

import '../models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  String _errMessage = '';

  List<Restaurant> get restaurants => _restaurants;

  set restaurants(List<Restaurant> restaurants) {
    _restaurants = restaurants;
    notifyListeners();
  }

  get errMessage => _errMessage;

  set errMessage(String errMessage) {
    _errMessage = errMessage;
    notifyListeners();
  }

  add(Restaurant restaurant) {
    _restaurants.add(restaurant);
    notifyListeners();
  }

  update(int index, Restaurant newRestaurant) {
    _restaurants[index] = newRestaurant;
    notifyListeners();
  }

  remove(Restaurant restaurant) {
    _restaurants.remove(restaurant);
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}
