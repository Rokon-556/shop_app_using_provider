import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/widgets/product_item.dart';



class ProductGrid extends StatelessWidget {
  final bool showFavs;
   const ProductGrid(this.showFavs, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final product = showFavs?productData.favoriteItems:productData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0),
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(

            //create: (context) => product[index],
            //if reusseable widget then we can use .value that is the convention
            value: product[index],
            child: const ProductItem(
              // product[index].id,
              // product[index].title,
              // product[index].imageUrl,
            ),
          )),
      itemCount: product.length,
    );
  }
}
