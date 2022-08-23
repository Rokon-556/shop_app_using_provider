import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', [], ''),
          update: (context, authData, previousProduct) => Products(
              authData.token ?? '',
              previousProduct == null ? [] : previousProduct.items,
              authData.userId ?? ''),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: ((_) => Order('', [], '')),
          update: (context, authData, previousOrder) => Order(
            authData.token ?? '',
            previousOrder == null ? [] : previousOrder.orders,
            authData.userId ?? '',
          ), //order provider
        )
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: ((context) => const CartScreen()),
            OrderScreen.routeName: ((context) => const OrderScreen()),
            UserProductScreen.routeName: ((context) =>
                const UserProductScreen()),
            EditProductScreen.routeName: ((context) =>
                const EditProductScreen()),
          },
        ),
      ),
    );
  }
}
