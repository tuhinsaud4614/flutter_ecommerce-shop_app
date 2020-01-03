import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          // create: (context) => Products("", "",[]),
          builder: (context, auth, previousProducts) => Products(auth.token,auth.userId,
              previousProducts == null ? [] : previousProducts.items),
          // child: ,
          // value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          // create: (context) => Orders("", []),
          builder: (context, auth, previousOrders) => Orders(auth.token,
              previousOrders == null ? [] : previousOrders.orders),
          // child: ,
          // value: Products(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
          ),
          // home: ProductsOverviewScreen(),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: <String, WidgetBuilder>{
            ProductDetailScreen.routeName: (BuildContext context) =>
                ProductDetailScreen(),
            CartScreen.routeName: (BuildContext context) => CartScreen(),
            OrdersScreen.routeName: (BuildContext context) => OrdersScreen(),
            UserProductsScreen.routeName: (BuildContext context) =>
                UserProductsScreen(),
            EditProductScreen.routeName: (BuildContext context) =>
                EditProductScreen(),
          },
        ),
      ),
    );
  }
}
