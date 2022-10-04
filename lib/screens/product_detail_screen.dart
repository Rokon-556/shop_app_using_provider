import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
     // appBar: AppBar(title: Text(loadedProduct.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(title: Text(loadedProduct.title,style: const TextStyle(color: Colors.purpleAccent),),background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),),
          ),
          SliverList(delegate: SliverChildListDelegate([
const SizedBox(
              height: 10.0,
            ),
            Text(
              '\$${loadedProduct.price}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 800,)
          ]))
        ],
        
      ),
    );
  }
}
