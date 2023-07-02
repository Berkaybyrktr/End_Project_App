import 'package:flutter/material.dart';
import 'package:membership_management_system1/Pages/LoginPage.dart';
import 'package:membership_management_system1/Pages/UserApplicationPostPage.dart';
import 'package:membership_management_system1/Pages/UserPostPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merkezi Kullancı Uyelik ve Yonetim_Sistemi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
