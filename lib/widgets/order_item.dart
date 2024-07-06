import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {super.key});

  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      height:
          _expanded ? min(widget.order.products.length * 24.0 + 115, 220) : 82,
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Column(children: <Widget>[
          ListTile(
            tileColor: Theme.of(context).hintColor.withOpacity(0.06),
            title: Text('₹${widget.order.total}'),
            onTap: () => setState(() {
              _expanded = !_expanded;
            }),
            subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 30, 100)
                : 0,
            child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(prod.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              '₹${prod.price} x ${prod.quantity}',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Anton',
                                  fontSize: 18),
                            )
                          ],
                        ))
                    .toList()),
          )
        ]),
      ),
    );
  }
}
