import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null && _userId != null) {
      return _token;
    }
    return null;
  }

  Future<void> setCredentials() async {
    _token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    _userId = FirebaseAuth.instance.currentUser!.uid;
    debugPrint('did updated credentials');
    notifyListeners();
  }

  // Future<void> _authenticate(
  //     String emailId, String password, String authMode) async {
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$authMode?key=AIzaSyAz62Hsn-CbfvnU2DtdJB2mrKM-eRVa7bI');
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'email': emailId,
  //           'password': password,
  //           'returnSecureToken': true
  //         }));
  //     final responseData = json.decode(response.body);
  //     if (responseData['error'] != null) {
  //       throw HttpException(responseData['error']['message']);
  //     }
  //     _token = responseData['idToken'];
  //     _userId = responseData['localId'];
  //     _expiryDate = DateTime.now()
  //         .add(Duration(seconds: int.parse(responseData['expiresIn'])));
  //     notifyListeners();
  //     debugPrint(responseData);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<void> signUp(String emailId, String password) async {
  //   return _authenticate(emailId, password, 'signUp');
  // }

  // Future<void> logIn(String emailId, String password) async {
  //   debugPrint('Reached in login');
  //   return _authenticate(emailId, password, 'signInWithPassword');
  // }
  
  // Future<void> signUp(String emailId, String password) async {
  //   UserCredential user = await irebase.instance.createUserWithEmailAndPassword(
  //       email: emailId, password: password);
  // }

  // Future<void> logIn(String emailId, String password) async {
  //   await _firebase.signInWithEmailAndPassword(
  //       email: emailId, password: password);
  //   // await setCredentials();
  // }
  }
