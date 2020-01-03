import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toogleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    final url =
        "https://flutter-update-7979f.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final res = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (res.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw Exception();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      print("fail");
    }
  }
}
