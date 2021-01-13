import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:talabat/models/restaurant.dart';
import 'package:talabat/screens/map.dart';
import 'package:talabat/screens/menu_items.dart';
import '../providers/restaurantProvider.dart';

const URL = 'http://appback.ppu.edu/restaurants';

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  List<String> _cities = ['Select a city', 'Hebron', 'Bethlahem', 'Beit Jala'];
  List<String> _ratings = [
    'Select rating',
    '5 Stars',
    '4 Stars',
    '3 Stars',
  ];
  String _selectedCity = 'Select a city';
  String _selectedRating = 'Select rating';

  void fetchData() async {
    http.Response response = await http.get(URL);

    List<Restaurant> _restaurants = [];
    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _restaurants = jsonArray.map((e) => Restaurant.fromJson(e)).toList();

      List<Restaurant> _filteredRestaurants = [];
      if (_selectedCity != 'Select a city') {
        int item;
        for (item = 0; item < _restaurants.length; item++) {
          if (_restaurants[item].city.toLowerCase() ==
              _selectedCity.toLowerCase())
            _filteredRestaurants.add(_restaurants[item]);
        }

        if (_filteredRestaurants.isNotEmpty) {
          context.read<RestaurantProvider>().restaurants = _filteredRestaurants;
          _filteredRestaurants = [];
        }
      }

      if (_selectedCity == 'Select a city') {
        context.read<RestaurantProvider>().restaurants = _restaurants;
      }

      if (_selectedRating != 'Select rating') {
        int rating = int.parse(_selectedRating.substring(0, 1));

        List<Restaurant> _restaurants =
            context.read<RestaurantProvider>().restaurants;
        List<Restaurant> _filteredOnRating = [];

        int item;
        for (item = 0; item < _restaurants.length; item++) {
          if (((_restaurants[item].rating / 2).floor()) == rating)
            _filteredOnRating.add(_restaurants[item]);
        }

        if (_filteredOnRating.isNotEmpty) {
          context.read<RestaurantProvider>().restaurants = _filteredOnRating;
          _filteredOnRating = [];
        }
      }

      if (_selectedCity == 'Select a city' &&
          _selectedRating == 'Select rating') {
        context.read<RestaurantProvider>().restaurants = _restaurants;
      }
    } else {
      context.read<RestaurantProvider>().errMessage =
          "Error occurred! Couldn't load data.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talabat'),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ));
              },
              child: Text(
                'Map',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              )),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                  hint: Text('Select a city'),
                  value: _selectedCity,
                  items: _cities
                      .map((city) =>
                          DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                  onChanged: (newCity) {
                    setState(() {
                      _selectedCity = newCity;
                      fetchData();
                    });
                  }),
              SizedBox(
                width: 30.0,
              ),
              DropdownButton(
                  hint: Text('Select rating'),
                  value: _selectedRating,
                  items: _ratings
                      .map((rating) =>
                          DropdownMenuItem(value: rating, child: Text(rating)))
                      .toList(),
                  onChanged: (newRating) {
                    setState(() {
                      _selectedRating = newRating;
                      fetchData();
                    });
                  }),
            ],
          ),
          Consumer<RestaurantProvider>(builder: (context, value, child) {
            if (value.errMessage != '') {
              return Container(
                child: Center(
                  child: Text(
                    value.errMessage,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else if (value.restaurants.isEmpty) {
              return Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Center(
                  child: SpinKitRing(
                    color: Colors.black,
                    size: 50.0,
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: value.restaurants.length,
                    itemExtent: 110,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 0),
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
                                  value.restaurants[index].image,
                                  width: 80.0,
                                ),
                                title: Text(value.restaurants[index].name),
                                subtitle: Row(
                                  children: [
                                    Row(children: [
                                      Row(
                                        children: List.generate(
                                          (value.restaurants[index].rating / 2)
                                              .floor(),
                                          (index) => Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          (5 -
                                                  (value.restaurants[index]
                                                          .rating /
                                                      2))
                                              .round(),
                                          (index) => Icon(
                                            Icons.star_border,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      width: 50.0,
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  child: Text('Show menu',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MenuItems(
                                              value.restaurants[index].id),
                                        ));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20.0),
                                child: Text(value.restaurants[index].city),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
        ],
      ),
    );
  }
}
