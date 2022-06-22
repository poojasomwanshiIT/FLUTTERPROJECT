import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagar_app_poc/view/login.dart';

import '../ScreenHeader/Header.dart';
import 'home.dart';
class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        title: const Text("LogOut"),
        titleTextStyle:
        const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,fontSize: 20),
        actionsOverflowButtonSpacing: 20,
        actions: [
          ElevatedButton(onPressed: (){
            _signOut();
            print("User logout successful");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );

          }, child: const Text("Yes")),
          ElevatedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          }, child: const Text("No")),
        ],
        content: const Text("Do you want to logout?"),

    );
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
