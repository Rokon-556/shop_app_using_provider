import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import '../provider/cart.dart';
import '../provider/product_provider.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  // ignore: constant_identifier_names
  Favorite,
  // ignore: constant_identifier_names
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = true;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_){
    //   Provider.of<Products>(context,listen: false).fetchAndSetProduct();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productContainer=Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Shop App',
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.Favorite) {
                    // productContainer.showFavorite();
                    _showFavoritesOnly = true;
                  } else {
                    //productContainer.showAll();
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text(
                    'Show All',
                  ),
                ),
                const PopupMenuItem(
                  value: FilterOptions.Favorite,
                  child: Text(
                    'Show Favorite',
                  ),
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) =>
                  Badge(value: cart.itemCount.toString(), child: child),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showFavoritesOnly));
  }
}
