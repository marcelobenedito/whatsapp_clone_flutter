import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/Home.dart';
import 'package:whatsapp_clone/screens/Login.dart';
import 'package:whatsapp_clone/screens/SettingsScreen.dart';
import 'package:whatsapp_clone/screens/Signup.dart';

class RouteGenerator {

  static const String ROOT_ROUTE = "/";
  static const String HOME_ROUTE = "/home";
  static const String LOGIN_ROUTE = "/login";
  static const String SIGNUP_ROUTE = "/signup";
  static const String SETTINGS_ROUTE = "/settings";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case LOGIN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case SIGNUP_ROUTE:
        return MaterialPageRoute(
          builder: (_) => Signup()
        );
      case HOME_ROUTE:
        return MaterialPageRoute(
          builder: (_) => Home()
        );
      case SETTINGS_ROUTE:
        return MaterialPageRoute(
          builder: (_) => SettingsScreen()
        );
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Not found Screen!"),
          ),
          body: Center(
            child: Text("Not found Screen"),
          ),
        );
      }
    );
  }

}