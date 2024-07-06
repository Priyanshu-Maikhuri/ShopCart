import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/pages/auth_screen.dart';

import '../pages/product_overview.dart';
import '../pages/user_product_screen.dart';
import '../pages/orders_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Container(
          //   height: 200,
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(10),
          //   color: Theme.of(context).primaryColor,
          //   child: const Text('Keep Shopping', style: TextStyle(fontSize: 26), softWrap: true,
          //   textAlign: TextAlign.center,)
          // ),
          AppBar(
            title: const Text('Keep Shopping.....'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            // autofocus: true,
            leading: const Icon(
              Icons.shop,
              size: 26,
            ),
            title: const Text('Shop'),
            onTap: () =>
                Navigator.of(context).pushNamed(ProductOverView.routeName),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            // autofocus: true,
            leading: const Icon(
              Icons.payment,
              size: 26,
            ),
            title: const Text('Orders'),
            onTap: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            // autofocus: true,
            leading: const Icon(
              Icons.edit_square,
              size: 26,
            ),
            title: const Text('Manage Products'),
            onTap: () =>
                Navigator.of(context).pushNamed(UserProductScreen.routeName),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              // autofocus: true,
              leading: const Icon(
                Icons.exit_to_app,
                size: 26,
              ),
              title: const Text('Logout'),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                // var pref = await SharedPreferences.getInstance();
                // await pref.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, AuthScreen.routeName, (route) => false);
              }),
        ],
      ),
    );
  }
}
