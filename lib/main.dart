import 'package:ecommerce_mobile_app/screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/register_page.dart';
import 'package:ecommerce_mobile_app/login_page.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        // Pass the required 'uri' parameter when navigating to HomeScreen
        '/HomeScreen': (context) => HomeScreen(uri: 'your_uri_here'),
      },
    );
  }
}
