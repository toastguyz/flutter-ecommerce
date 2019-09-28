import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/helpers/custom_route.dart';
import 'package:flutter_ecommerce/providers/auth.dart';
import 'package:flutter_ecommerce/providers/cart.dart';
import 'package:flutter_ecommerce/providers/orders.dart';
import 'package:flutter_ecommerce/providers/products.dart';
import 'package:flutter_ecommerce/screens/auth_screen.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/screens/edit_product_screen.dart';
import 'package:flutter_ecommerce/screens/orders_screen.dart';
import 'package:flutter_ecommerce/screens/splash_screen.dart';
import 'package:flutter_ecommerce/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //    return ChangeNotifierProvider(
    //      builder: (BuildContext context) => Products(),
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (context, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (context, auth, previousOrders) => Orders(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (BuildContext context, Auth auth, Widget child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E-Store',
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.redAccent,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                }),
              ),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              });
        },
      ),
    );
  }
}
