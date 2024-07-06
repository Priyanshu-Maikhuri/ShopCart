import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/pages/product_overview.dart';


enum AuthMode { Signup, Login }

FirebaseAuth _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(4.0013 * 3.1596)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            strokeAlign: BorderSide.strokeAlignCenter),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'ShopCart',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.75,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authCredentials = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _hidePassword = true;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              icon: const Icon(
                Icons.error,
                size: 90,
                shadows: [
                  Shadow(
                      offset: Offset(1.5, 2.7),
                      blurRadius: 5,
                      color: Colors.orangeAccent),
                  Shadow(
                      offset: Offset(1.5, 2.7),
                      blurRadius: 5,
                      color: Colors.grey)
                ],
              ),
              iconColor: Colors.deepOrange.shade900,
              iconPadding: const EdgeInsets.only(top: 1),
              title: const Text('Ooops!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; //Invalid
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await _firebase.signInWithEmailAndPassword(
            email: _authCredentials['email']!,
            password: _authCredentials['password']!);
      } else {
        await _firebase.createUserWithEmailAndPassword(
            email: _authCredentials['email']!,
            password: _authCredentials['password']!);
      }
      // var pref = await SharedPreferences.getInstance();
      // pref.setBool(SplashScreenState.KEYLOGIN, true);
      // await Provider.of<Auth>(context, listen: false).setCredentials();
      Navigator.pushReplacementNamed(context, ProductOverView.routeName);
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication Failed.';
      if (error.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'There is no existing corresponding user record.';
      } else if (error.code == 'invalid-email') {
        errorMessage =
            'There is no user record corresponding to this emai id. The user may have been deleted.';
      } else if (error.code == 'invalid-password') {
        errorMessage = 'The password is invalid.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'This password is too weak.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'The password is invalid for the given email.';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return PhysicalModel(
      color: Colors.white,
      shadowColor: Theme.of(context).colorScheme.primary,
      elevation: 20.0,
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 30),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 520 : 400,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 520 : 400),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Icon(Icons.account_circle,
                      size: 100, color: Theme.of(context).primaryColor),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.black)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authCredentials['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon:
                          const Icon(Icons.key_outlined, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _hidePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authCredentials['password'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  (_isLoading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {
                        _authMode = (_authMode == AuthMode.Login)
                            ? AuthMode.Signup
                            : AuthMode.Login;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
