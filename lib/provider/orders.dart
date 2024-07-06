import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  @override
  OrderItem(
      {required this.id,
      required this.total,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchToSetOrders() async {
    final url =
        Uri.https('shop-app-4d0e6-default-rtdb.firebaseio.com', '/orders.json');
    // try {
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.insert(
          0,
          OrderItem(
              id: orderId,
              total: orderData['total']!,
              products: (orderData['products'] as List<dynamic>)
                  .map((items) => CartItem(
                      id: items['id'],
                      title: items['title'],
                      quantity: items['quantity'],
                      price: items['price']))
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders;
    notifyListeners();
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<void> placeOrder(List<CartItem> products, double amount, String paymentId) async {
    final urlOrder =
        Uri.https('shop-app-4d0e6-default-rtdb.firebaseio.com', '/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(urlOrder,
        body: json.encode({
          'total': amount,
          'products': products
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList(),
          'paymentId': paymentId,
          'dateTime': timeStamp.toIso8601String(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            total: amount,
            products: products,
            dateTime: timeStamp));
    notifyListeners();
  }
}
