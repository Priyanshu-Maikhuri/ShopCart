import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _getFutureOrders() {
    return Provider.of<Orders>(context, listen: false).fetchToSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _getFutureOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture!,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              }
              //else if (snapshot.data == null) {
              //   return const Center(
              //       child: Text(
              //     'No products in the cart. Start buying some!',
              //     style: TextStyle(
              //       color: Colors.blueGrey,
              //       fontSize: 20,
              //       fontStyle: FontStyle.italic,
              //     ),
              //     textAlign: TextAlign.center,
              //     softWrap: true,
              //   ));
              // }
              else {
                return Consumer<Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (_, i) => OrderItem(orderData.orders[i]),
                        ));
              }
            })));
  }
}
