import 'package:flutter/cupertino.dart';

import '../models/menu_item.dart';
import 'databaseProvider.dart';

class OrderProvider extends ChangeNotifier {
  List<MenuItem> _orders = [];
  double _totalPrice = 0;

  get orders => _orders;

  set orders(List<MenuItem> orders) {
    _orders = orders;
    notifyListeners();
  }

  get totalPrice => _totalPrice;

  isExists(MenuItem order) {
    notifyListeners();
    return _orders.indexOf(order) != -1 ? true : false;
  }

  add(MenuItem order) {
    if (_orders.indexOf(order) == -1) {
      _orders.add(order);

      notifyListeners();

      DatabaseProvider.db.addOrder(order);
    }

    _totalPrice += order.price;
  }

  update(int index, MenuItem newOrder) {
    _orders[index] = newOrder;
    notifyListeners();
  }

  remove(MenuItem order) {
    _orders.remove(order);
    _totalPrice -= order.price;

    notifyListeners();

    DatabaseProvider.db.deleteOrder(order.id);
  }

  calculateTotalPrice() {
    if (_totalPrice == 0) {
      _orders.forEach((order) {
        _totalPrice += order.price;
      });

      notifyListeners();
    }
  }
}
