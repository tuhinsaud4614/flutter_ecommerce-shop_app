import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    /// TODO: If we use provider listen: false we need not use Future delayed

    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    /// TODO: this is the alernative of future delayed Future delayed
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      // body: FutureBuilder(
      //   future:
      //       Provider.of<Orders>(context, listen: false).fetchAndSetProducts(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       if (snapshot.error != null) {
      //         return Center(
      //           child: Text("Something went wrong!"),
      //         );
      //       } else {
      //         return ListView.builder(
      //           itemCount: orderData.orders.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return OrderItem(
      //               order: orderData.orders[index],
      //             );
      //           },
      //         );
      //       }
      //     }
      //   },
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderItem(
                  order: orderData.orders[index],
                );
              },
            ),
      drawer: AppDrawer(),
    );
  }
}
