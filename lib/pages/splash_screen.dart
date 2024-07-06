import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../pages/product_overview.dart';
import '../pages/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  // static const String KEYLOGIN = "Login";
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _navigateInApp();
    super.initState();
  }

  void _navigateInApp() async {
    // var pref = await SharedPreferences.getInstance();
    // var isLoggedIn = pref.getBool(KEYLOGIN);
    Future.delayed(const Duration(seconds: 5, milliseconds: 275), () {
      if (user==null) {
        print('Logged out user');
        Navigator.pushNamedAndRemoveUntil(
            context, AuthScreen.routeName, (route) => false);
      } else {
        print('User was signedIn in starting');
        Navigator.pushNamedAndRemoveUntil(
            context, ProductOverView.routeName, (route) => false);
      }
      // if (isLoggedIn != null) {
      //   if (isLoggedIn) {
      //     debugPrint('It logged in');
      //     Navigator.pushReplacementNamed(context, ProductOverView.routeName);
      //   } else {
      //     Navigator.pushReplacementNamed(context, AuthScreen.routeName);
      //   }
      // }
      // debugPrint('Initially isLoggedIn is null');
      // Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade200,
        body: Center(
          child: Lottie.asset('assets/animations/splash.json'),
        ));
  }
}
