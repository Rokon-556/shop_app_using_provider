import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart' show Order;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Order'),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Order>(context,listen: false).getAndSetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('No Orders Found'),
                );
              } else {
                return Consumer<Order>(
                    builder: (context, orderData, child) => ListView.builder(
                          itemBuilder: ((context, index) =>
                              OrderItem(orderData.orders[index])),
                          itemCount: orderData.orders.length,
                        ));
              }
            }
          },
        ));
  }
}
