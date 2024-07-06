import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../provider/cart.dart' show Cart;
import '../provider/orders.dart';
import '../widgets/cart_item.dart';

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
  final Razorpay _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    final cart = Provider.of<Cart>(context);

    return TextButton(
        onPressed: widget.cart.totalAmount <= 0
            ? null
            : () async {
                User? user = FirebaseAuth.instance.currentUser;
                setState(() {
                  _isLoading = true;
                });
                int amount = (100 * cart.totalAmount).toInt();
                List<String> cartProducts = [];
                cart.items.forEach((key, cartItem) {
                  cartProducts.add('${cartItem.quantity} ${cartItem.title}');
                });
                String orderDescription = cartProducts.join(', ');
                var options = {
                  'key': 'rzp_test_4YjgQBg1A17Bvf',
                  'amount': amount,
                  'name': 'ShopCart Inc',
                  'description': orderDescription,
                  'prefill': {
                    // 'contact': '8888888888',
                    'email': user!.email
                  },
                };
                try {
                  _razorpay.open(options);
                } catch (e) {
                  debugPrint('Error: $e');
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                'ORDER NOW',
                style: TextStyle(
                    color: widget.cart.totalAmount == 0.0
                        ? Colors.grey
                        : Theme.of(context).primaryColor),
              ));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      await Provider.of<Orders>(context, listen: false).placeOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
          response.paymentId!);
      widget.cart.clear();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
    Fluttertoast.showToast(msg: 'Payment Successful');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(msg: 'Payment Failed');
  }

  @override
  void dispose() {
    super.dispose();

    try {
      _razorpay.clear(); // Removes all listeners
    } catch (e) {
      debugPrint('While exiting razorpay payment gateway: $e');
    }
  }
}
