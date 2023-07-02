import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:membership_management_system1/ApiService.dart';
import 'package:membership_management_system1/Models.dart';
import 'package:http/http.dart' as http;
import 'package:membership_management_system1/Pages/LoginPage.dart';
import 'dart:convert';

import 'package:membership_management_system1/Pages/UserPostPage.dart';

class UserApplicationPostPage extends StatefulWidget {
  @override
  _UserApplicationPostPageState createState() =>
      _UserApplicationPostPageState();
}

class _UserApplicationPostPageState extends State<UserApplicationPostPage> {
  List<Application> applications = [];
  Application? selectedApplication;
  String? appKey;
  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      List<Application> fetchedApplications =
          await _applicationService.getAll();
      setState(() {
        applications = fetchedApplications;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  UserApplicationService _userApplicationService = UserApplicationService();
  UserService _userService = UserService();
  ApplicationService _applicationService = ApplicationService();

  void _UserApplicationPost() async {
    String username = _username.text;
    int roleId = 1;
    String password = _password.text;
    if (appKey == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select an application.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fetching user ID...'),
          content: Text('Please wait while we retrieve the user ID.'),
        );
      },
    );

    try {
      int userId = await _userService.getIdByUsername(username);
      int applicationId = await _applicationService.getIdByAppKey(appKey!);

      Navigator.of(context, rootNavigator: true).pop();

      UserApplication newUserApplication = UserApplication(
        id: 0,
        userId: userId,
        applicationId: applicationId,
        roleId: roleId,
        password: password,
      );

      await _userApplicationService.add(newUserApplication);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User application added successfully.'),
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
      if (e.toString().contains('Already exist')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('You are already registered'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Username not found . Please create user first.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPostPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign Up To Application'),
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
              controller: _username,
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
            SizedBox(height: 20.0),
            DropdownButton<Application>(
              value: selectedApplication,
              onChanged: (Application? newValue) {
                setState(() {
                  selectedApplication = newValue;
                  appKey = null;
                });
                if (newValue != null) {
                  getAppKey(newValue.id);
                }
              },
              items: applications.map<DropdownMenuItem<Application>>(
                (Application value) {
                  return DropdownMenuItem<Application>(
                    value: value,
                    child: Text(
                      value.applicationName ?? '',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _UserApplicationPost,
                child: Text(
                  'Sign Up',
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

  Future<void> getAllApplications() async {
    try {
      List<Application> appList = await _applicationService.getAll();
      setState(() {
        applications = appList;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load applications. $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getAppKey(int id) async {
    try {
      String key = await _applicationService.getAppKeyById(id);
      setState(() {
        appKey = key;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to retrieve appKey. $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
