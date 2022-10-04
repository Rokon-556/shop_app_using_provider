import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MMM yy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 10, 100)
                : 0,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
            child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            prod.title,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${prod.quantity}X\$${prod.price}',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                    .toList()),
          )
        ]),
      ),
    );
  }
}
