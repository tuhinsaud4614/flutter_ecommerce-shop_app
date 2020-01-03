import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  Orders(this.authToken, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        "https://flutter-update-7979f.firebaseio.com/orders.json?auth=$authToken";
    final List<OrderItem> loadedOrders = [];
    try {
      final res = await http.get(url);
      // print(json.decode(res.body));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      //TODO: if extractedData cant't find any data
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((ci) {
              return CartItem(
                id: ci['id'],
                price: ci['price'],
                title: ci['title'],
                quantity: ci['quantity'],
              );
            }).toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-update-7979f.firebaseio.com/orders.json?auth=$authToken";
    final timestamp = DateTime.now();
    try {
      final res = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts.map(
              (cp) {
                return {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                };
              },
            ).toList(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
