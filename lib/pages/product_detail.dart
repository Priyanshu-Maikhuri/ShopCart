import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/ProductDetail';
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    Product loadedProduct =
        Provider.of<Products>(context, listen: false).getById(productId);
    return Scaffold(
        // appBar: AppBar(title: Text(loadedProduct.title)),
        body: CustomScrollView(slivers: [
          SliverAppBar(
              leading: BackButton(color: Theme.of(context).primaryColor),
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title, style: const TextStyle(fontWeight: FontWeight.w900),),
                background: Hero(
                    tag: loadedProduct.id,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    )),
              )),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 10),
              Text(
                '₹ ${loadedProduct.price}',
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ],
          )),
          // Column(children: <Widget>[
          //   Container(
          //       width: double.infinity,
          //       height: MediaQuery.of(context).size.height * 0.41,
          //       padding: const EdgeInsets.only(bottom: 5),
          //       decoration: const BoxDecoration(
          //           border: Border(
          //               bottom: BorderSide(
          //         width: 2,
          //         color: Colors.blueGrey,
          //       ))),
          //       child: ),

          // ]),
        ]));
  }
}
