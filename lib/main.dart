import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagar_app_poc/view/home.dart';
import 'package:pagar_app_poc/view/login.dart';
import 'firebase_options.dart';
import 'navigation/app_navigation.dart';
import 'view/login.dart';
import 'package:pagar_app_poc/bloc/employee_bloc.dart';
import 'package:splashscreen/splashscreen.dart';
import 'di_container.dart' as di;


void main() async{
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
 // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }
  dynamic users=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmpBloc>(create: (context) =>  EmpBloc())    ],
      child:MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppNavigator.generateRoute,

         home: SplashScreen(
                   seconds: 5,
                   navigateAfterSeconds:  users!=null ? Home() : LoginScreen(),

                   title: const Text(
                     'Pagar Application',
                     style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20.0,
                         color: Colors.white),
                   ),
                   image: Image.asset('assets/images/user.png'),
                   photoSize: 100.0,
                   backgroundColor: Colors.blue,


                 ),
      ),);
  }

}
