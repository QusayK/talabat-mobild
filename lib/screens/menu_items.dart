import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../screens/favorites.dart';
import '../models/menu_item.dart';
import '../providers/orderProvider.dart';
import '../screens/orders_list.dart';
import '../providers/favoriteProvider.dart';
import '../providers/databaseProvider.dart';

class MenuItems extends StatefulWidget {
  int res_id;
  MenuItems(this.res_id);

  @override
  _MenuItemsState createState() => _MenuItemsState(res_id);
}

class _MenuItemsState extends State<MenuItems> {
  Future<List<MenuItem>> menus;
  int res_id;
  String errMessage = '';

  _MenuItemsState(this.res_id);

  Future<List<MenuItem>> fetchData() async {
    http.Response response =
        await http.get('http://appback.ppu.edu/menus/$res_id');

    List<MenuItem> _menus = [];
    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _menus = jsonArray.map((e) => MenuItem.fromJson(e)).toList();
    } else {
      errMessage = "Error occurred! Couldn't load data.";
    }

    return _menus;
  }

  @override
  void initState() {
    super.initState();
    menus = fetchData();
    /*DatabaseProvider.db
        .getFavorites()
        .then((value) => context.read<FavoriteProvider>().favorites = value);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersList(),
                    ));
              },
              child: Text(
                'Order list',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              )),
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favorites(),
                    ));
              },
              child: Text(
                'Favorites',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              )),
        ],
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
          FutureBuilder(
            future: menus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MenuItem> menus = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: menus?.length,
                    itemExtent: 135,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  menus[index].image,
                                  width: 80.0,
                                ),
                              ),
                              title: Text(menus[index].name),
                              subtitle: Text(menus[index].descr),
                              trailing: Text('${menus[index].price}'),
                              onTap: () {
                                if (context
                                    .read<OrderProvider>()
                                    .isExists(menus[index])) {
                                  Toast.show(
                                      "${menus[index].name} already in your order list.",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  return;
                                }

                                context.read<OrderProvider>().add(menus[index]);
                                Toast.show(
                                    "${menus[index].name} has been added to your order list.",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              },
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20.0, 5.0, 17.0, 0),
                                child: Row(
                                  children: [
                                    Text('Rating'),
                                    SizedBox(
                                      width: 275.0,
                                    ),
                                    Consumer<FavoriteProvider>(
                                      builder: (context, value, child) {
                                        return IconButton(
                                            icon: value.isExists(menus[index])
                                                ? Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  )
                                                : Icon(Icons.star_border),
                                            onPressed: () {
                                              if (value
                                                  .isExists(menus[index])) {
                                                value.remove(menus[index]);
                                              } else {
                                                value.add(menus[index]);
                                              }
                                            });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      snapshot.error,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                return SpinKitRing(
                  color: Colors.black,
                  size: 50.0,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
