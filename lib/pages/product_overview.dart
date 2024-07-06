import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../widgets/cart_badge.dart';
import '../provider/cart.dart';
import '../widgets/product_grid.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../provider/products.dart';

enum FilterOptions { favoritesOnly, all }

class ProductOverView extends StatefulWidget {
  const ProductOverView({super.key});
  static const routeName = '/product-overview';

  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Products>(context).fetchToSetProduxts();
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // final auth = Provider.of<Auth>(context, listen: false);
      Provider.of<Products>(context).fetchToSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Consumer<Cart>(
            builder: (_, cartData, ch) => CartBadge(
              value: cartData.itemsCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favoritesOnly,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.filter_alt),
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.favoritesOnly) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoritesOnly),
    );
  }
}
