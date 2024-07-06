import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/product_detail.dart';
import '../provider/cart.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  (item.isFavorite) ? Icons.favorite : Icons.favorite_outline),
              color: Theme.of(context).hintColor,
              onPressed: () {
                item.toggleFavorites();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(cart.inCart(item.id)
                ? Icons.shopping_cart
                : Icons.shopping_cart_outlined),
            color: Colors.blue,
            onPressed: () {
              cart.addItem(item.id, item.title, item.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${item.title} is added in your cart'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Theme.of(context).hintColor,
                    onPressed: () {
                      cart.removeSingleItem(item.id);
                    }),
              ));
            },
          ),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routeName, arguments: item.id);
          },
          child: Hero(
            tag: item.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
