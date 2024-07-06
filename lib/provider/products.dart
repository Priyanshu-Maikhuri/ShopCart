import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Casual Shoes',
    //   description:
    //       'Shoes are designed keeping in mind the durability as well as trends,'
    //       'the most stylish range of shoes & sandals. They are exclusively designed to match the latest trends of the new generation.\nThis pair of shoes is all what makes you look smart & classy. These will go with most of your casual outfits. This product is made of premium quality and highly material. The perfect combo of good looks.\n\nCountry of Origin : India',
    //   price: 43.9,
    //   imageUrl:
    //       'https://images.meesho.com/images/products/119544768/7pyu4_512.jpg',
    // ),
  ];
  
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product getById(String productId) {
    return _items.firstWhere((p) => p.id == productId);
  }

  Future<void> fetchToSetProducts() async {
    final url = Uri.https('shop-app-4d0e6-default-rtdb.firebaseio.com',
        '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    final url = Uri.https(
        'shop-app-4d0e6-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'], //DateTime.now().toString(),
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // print('in provider products......');
      // print(error.toString());
      // rethrow;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'shop-app-4d0e6-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': editedProduct.title,
            'imageUrl': editedProduct.imageUrl,
            'price': editedProduct.price,
            'description': editedProduct.description
          }));
      _items[prodIndex] = editedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
        'shop-app-4d0e6-default-rtdb.firebaseio.com', '/products/$id.json');
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    Product? thisProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      //status codes are codes which server sends to client on web where codes in 100s refer successful
      // operation, 200s refer to redirection, 400s and 500s refer to error or unsuccessful
      _items.insert(productIndex, thisProduct);
      notifyListeners();
      throw HttpException('Deletion failed!');
    } else {
      thisProduct = null;
    }
  }
}
