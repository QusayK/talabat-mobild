import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:talabat/providers/orderProvider.dart';
import '../providers/databaseProvider.dart';

class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  void initState() {
    DatabaseProvider.db.getOrders().then((value) {
      context.read<OrderProvider>().orders = value;
      context.read<OrderProvider>().calculateTotalPrice();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders List'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(17.0),
            child: Text(
              'Total Price: ${context.watch<OrderProvider>().totalPrice}',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Consumer<OrderProvider>(
            builder: (context, value, child) {
              if (value.orders.isEmpty) {
                return Center(
                  child: Container(
                    child: Text(
                      'No items in your orders list',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: value.orders?.length,
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
                                value.orders[index].image,
                                width: 80.0,
                              ),
                              title: Text(value.orders[index].name),
                              subtitle: Text(value.orders[index].descr),
                              trailing: Text('${value.orders[index].price}'),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
                              child: Text('Rating'),
                            ),
                          ],
                        ),
                      ),
                      key: Key(value.orders[index].name),
                      onDismissed: (direction) {
                        value.remove(value.orders[index]);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
