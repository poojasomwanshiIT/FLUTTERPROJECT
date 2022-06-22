import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagar_app_poc/view/login.dart';

import '../navigation/app_navigation.dart';
import '../view/home.dart';
import '../view/logout.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  bool BackButton = true;
  Color backgroundColor = Colors.blueAccent;
  bool iconButton = false;
  dynamic users = FirebaseAuth.instance.currentUser;

  Header(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == "Login") {
      BackButton = false;
    }
    if (title == "Home") {
      BackButton = false;
      iconButton = true;
    }
    return AppBar(
      title: Text(title!),
      backgroundColor: backgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: BackButton,
      actions: [
        Visibility(
          visible: iconButton,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                print("tap");
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("LogOut"),
                          titleTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                          actionsOverflowButtonSpacing: 20,
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  _signOut();
                                  print("User logout successful");
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                },
                                child: const Text("No")),
                          ],
                          content: const Text("Do you want to logout?"),
                        ));

                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => const Logout()));
              },
              child: const Icon(Icons.logout),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// import 'package:flutter/material.dart';
//
// class Header extends StatelessWidget implements PreferredSizeWidget {
//
//   String?  title;
//   Color backgroundColor = Colors.blueAccent;
//
//
//
//   Header(this.title,{Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if(title=="Home"){
//
//     }
//     if(title=="Add Employees"){
//
//     }
//     return AppBar(
//       title: Text(title!),
//       backgroundColor: backgroundColor,
//       centerTitle: true,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios),
//         iconSize: 20.0,
//         onPressed: () {
//           _goBack(context);
//         },
//       ),
//
//     );
//   }
//   _goBack(BuildContext context) {
//     Navigator.pop(context);
//   }
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
