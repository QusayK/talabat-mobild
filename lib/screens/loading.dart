import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:talabat/providers/restaurantProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:talabat/screens/restaurants.dart';
import '../models/restaurant.dart';

const URL = 'http://appback.ppu.edu/restaurants';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void fetchData() async {
    http.Response response = await http.get(URL);

    List<Restaurant> _restaurants = [];
    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      _restaurants = jsonArray.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      context.read<RestaurantProvider>().errMessage =
          "Error occurred! Couldn't load data.";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Restaurants()));
    }

    context.read<RestaurantProvider>().restaurants = _restaurants;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Restaurants()));
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SpinKitRipple(
            color: Colors.black,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
