import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagar_app_poc/view/login.dart';
import 'package:splashscreen/splashscreen.dart';

import '../view/home.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}
//flutter run --no-sound-null-safety
class _SplashscreenState extends State<Splashscreen> {
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
  dynamic users=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return  SplashScreen(
        seconds: 5,
        navigateAfterSeconds:  users==null ? LoginScreen() : Home(),

        title: const Text(
          'SplashScreen Example',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white),
        ),
        image: Image.asset('assets/images/user.png'),
        photoSize: 100.0,
        backgroundColor: Colors.blue,
        styleTextUnderTheLoader: new TextStyle(),
        loaderColor: Colors.white,

    );
  }
}
