import 'package:flutter/material.dart';
import 'package:pagar_app_poc/view/employeeDetails.dart';
import 'package:pagar_app_poc/view/login.dart';
import 'package:pagar_app_poc/view/home.dart';
import 'package:pagar_app_poc/view/addEmployee.dart';
class AppNavigator {
  static const defaultRoute = "/login";
  static const homeRoute = "/home";
  static const addEmpRoute = "/add";
  static const updateEmpRoute="/update";
  static const updateEmpsRoute="/updateemp";

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
      case addEmpRoute:
        return MaterialPageRoute(
          builder: (_) => AddEmp(isEditon: args),
        );
      case updateEmpRoute:
        return MaterialPageRoute(
          builder: (_) => EmployeeDetails(args),
        );
      case updateEmpsRoute:
        return MaterialPageRoute(
          builder: (_) => AddEmp(isEditon: args['flag'],emp: args['data'],),
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
