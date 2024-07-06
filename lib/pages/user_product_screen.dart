import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import '../provider/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../pages/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});

  static const routeName = '/User-Products-Screen';

  Future<void> _refreshProductsList(BuildContext ctx) async {
    // final auth = Provider.of<Auth>(ctx, listen: false);
    await Provider.of<Products>(ctx, listen: false).fetchToSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProductsList(context),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (ctx, i) => Column(children: [
                        UserProductItem(
                          title: productsData.items[i].title,
                          imageUrl: productsData.items[i].imageUrl,
                          id: productsData.items[i].id,
                        ),
                        const Divider(),
                      ]))),
        ));
  }
}
