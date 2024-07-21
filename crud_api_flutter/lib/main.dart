import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'recovery.dart';
import 'resetpassword.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CheckAuth(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/recovery': (context) => RecoveryPage(),
        '/resetpassword': (context) => ResetPasswordPage(),
        '/home': (context) => Home(),
      },
    );
  }
}

class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return Home();
        } else {
          return LoginPage();
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return token.isNotEmpty;
  }
}