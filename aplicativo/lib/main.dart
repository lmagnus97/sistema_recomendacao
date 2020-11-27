import 'package:app_system_recommender/ui/HomeUI.dart';
import 'package:app_system_recommender/ui/LoginUI.dart';
import 'package:app_system_recommender/ui/RegisterUI.dart';
import 'package:app_system_recommender/ui/SplashUI.dart';
import 'package:app_system_recommender/util/AppTheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppTheme.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomeUI(),
        '/register': (context) => RegisterUI(),
        '/login': (context) => LoginUI()
      },
      home: SplashUI(),
    );
  }
}
