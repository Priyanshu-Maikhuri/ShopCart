import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: [
            Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        const Text('Total',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '₹${cart.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .titleLarge!
                                    .color),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        OrderButton(cart: cart)
                      ],
                    ))),
            Expanded(
              child: cart.itemsCount == 0
                  ? const Center(
                      child: Text(
                      'No products in the cart. Start adding some!',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ))
                  : ListView.builder(
                      itemCount: cart.itemsCount,
                      itemBuilder: (_, i) => CartItem(
                          cart.items.values.toList()[i].id,
                          cart.items.keys.toList()[i],
                          cart.items.values.toList()[i].title,
                          cart.items.values.toList()[i].quantity,
                          cart.items.values.toList()[i].price)),
            )
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cart.totalAmount <= 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).placeOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clear();
                setState(() {
                  _isLoading = false;
                });
              },
        child: _isLoading? const CircularProgressIndicator() : Text(
          'ORDER NOW',
          style: TextStyle(
              color: widget.cart.totalAmount == 0.0
                  ? Colors.grey
                  : Theme.of(context).primaryColor),
        ));
  }
}
