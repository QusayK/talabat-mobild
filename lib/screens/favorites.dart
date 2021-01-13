import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'package:talabat/providers/orderProvider.dart';
import 'package:talabat/providers/favoriteProvider.dart';
import '../providers/databaseProvider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db
        .getFavorites()
        .then((value) => context.read<FavoriteProvider>().favorites = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(17.0),
            child: Text(
              'Click on any meal to add to your order list',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Consumer<FavoriteProvider>(
                builder: (context, value, child) {
                  if (value.favorites.isEmpty) {
                    return Center(
                      child: Container(
                        child: Text(
                          'No items in your favorites list',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: value.favorites.length,
                    itemExtent: 110.0,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Image.network(
                                  value.favorites[index].image,
                                  width: 80.0,
                                ),
                                title: Text(value.favorites[index].name),
                                subtitle: Text(value.favorites[index].descr),
                                trailing:
                                    Text('${value.favorites[index].price}'),
                                onTap: () {
                                  if (context
                                      .read<OrderProvider>()
                                      .isExists(value.favorites[index])) {
                                    Toast.show(
                                        "${value.favorites[index].name} already in your order list.",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                    return;
                                  }

                                  context
                                      .read<OrderProvider>()
                                      .add(value.favorites[index]);
                                  Toast.show(
                                      "${value.favorites[index].name} has been added to your order list.",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                },
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
                                child: Text('Rating'),
                              ),
                            ],
                          ),
                        ),
                        key: Key(value.favorites[index].name),
                        onDismissed: (direction) {
                          value.remove(value.favorites[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
