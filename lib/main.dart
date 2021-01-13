import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talabat/providers/databaseProvider.dart';

import 'package:talabat/providers/favoriteProvider.dart';
import 'package:talabat/screens/loading.dart';
import 'providers/restaurantProvider.dart';
import 'providers/orderProvider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider()),
      ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider()),
      ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider()),
      ChangeNotifierProvider<DatabaseProvider>(
        create: (context) => DatabaseProvider.db,
      )
    ],
    child: mainApp(),
  ));
}

class mainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talabat',
      home: Loading(),
    );
  }
}
