import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:membership_management_system1/ApiService.dart';
import 'package:membership_management_system1/Models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:membership_management_system1/Pages/LoginPage.dart';

class UserPostPage extends StatefulWidget {
  @override
  _UserPostPageState createState() => _UserPostPageState();
}

class _UserPostPageState extends State<UserPostPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  UserService _userService = UserService();

  void _UserPostUser() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    User newUser = User(
      id: 0, // The ID will be assigned by the server
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );

    try {
      // Add user to the database
      await _userService.add(newUser);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Created'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 150.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _UserPostUser,
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 14.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getErrorMessage(dynamic error) {
  if (error is Exception) {
    return error.toString();
  } else if (error is http.Response) {
    if (error.statusCode == 409) {
      return 'Username already taken';
    } else {
      return 'An error occurred while adding the user. Please try again later.';
    }
  } else {
    return 'An unexpected error occurred.';
  }
}
