import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  const UserProductScreen({Key? key}) : super(key: key);


  Future<void> _refreshProducts(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Product',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (() => _refreshProducts(context)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (_, index) => Column(
              children: [
                UserProduct(
                  productData.items[index].id,
                  productData.items[index].title,
                  productData.items[index].imageUrl,
                ),
                const Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
