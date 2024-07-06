import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './provider/products.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './provider/auth.dart';

import './pages/product_overview.dart';
import './pages/product_detail.dart';
import './pages/cart_screen.dart';
import './pages/orders_screen.dart';
import './pages/user_product_screen.dart';
import './pages/edit_product_screen.dart';
import './pages/splash_screen.dart';
import './pages/auth_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (TargetPlatform.android == true || TargetPlatform.iOS == true) {
  //   await Firebase.initializeApp();
  // } else {
  //   return;
  // }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var kColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.deepPurple, error: Colors.red[700]);
    var kDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.deepPurpleAccent, brightness: Brightness.dark);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: kDarkColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer),
        ),
        theme: ThemeData(fontFamily: 'Lato').copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          hintColor: Colors.deepOrange,
          appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.onPrimaryContainer,
              foregroundColor: kColorScheme.primaryContainer),
          // textTheme: const TextTheme().copyWith(
          //   titleLarge: const TextStyle(fontFamily: 'Lato'),
          // )
        ),
        // themeMode: ThemeMode.system, // by default

        home: const SplashScreen(),
        // StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return const ProductOverView();
        //     }
        //     return const AuthScreen();
        //   },
        // ),
        routes: {
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          ProductOverView.routeName: (ctx) => const ProductOverView(),
          ProductDetail.routeName: (ctx) => const ProductDetail(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductScreen.routeName: (ctx) => const UserProductScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
