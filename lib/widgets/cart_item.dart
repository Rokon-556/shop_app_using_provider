import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

   const CartItem(this.id, this.productId, this.title, this.price, this.quantity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        padding:const EdgeInsets.all(20),
        margin:  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeProduct(productId);
      },
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (context)=>AlertDialog(title: const Text('Confirmation!!!'),content:const Text('Do you want to remove item from the cart???'),actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('NO'),),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: const Text('YES'),),
        ],));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
