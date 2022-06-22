import 'package:flutter/material.dart';
import 'package:pagar_app_poc/view/login.dart';
import 'package:pagar_app_poc/view/home.dart';
import 'package:pagar_app_poc/view/addEmployee.dart';
class AppNavigator {
  static const defaultRoute = "/login";
  static const homeRoute = "/home";
  static const addEmpRoute = "/add";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case defaultRoute:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      default:
        return _errorRoute();
    }
  }
  static push({
    required BuildContext context,
    required String routeName,
    Object? argument,
  }) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: argument,
    );
  }

  static pop({
    required BuildContext context,
  }) async{
    final data= Navigator.pop(context);
    return data;
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
