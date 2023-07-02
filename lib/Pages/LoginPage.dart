import 'package:flutter/material.dart';
import 'package:membership_management_system1/ApiService.dart';
import 'package:membership_management_system1/Models.dart';
import 'package:membership_management_system1/Pages/CurrentPage.dart';
import 'package:membership_management_system1/Pages/WowPage.dart';
import 'package:membership_management_system1/Pages/MembershipPage.dart';
import 'package:membership_management_system1/Pages/UserApplicationPostPage.dart';
import 'package:membership_management_system1/Pages/UserPostPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<Application> applications = [];
  Application? selectedApplication;
  String? appKey;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  UserApplicationService _userApplicationService = UserApplicationService();
  UserService _userService = UserService();
  ApplicationService _applicationService = ApplicationService();

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

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserPostPage()),
    );
  }

  void _registerToApplication() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserApplicationPostPage()),
    );
  }

  void _login() async {
    String username = _username.text;
    String password = _password.text;
    try {
      int userId = await _userService.getIdByUsername(username);
      int applicationId = await _applicationService.getIdByAppKey(appKey!);
      int userApplicationId = await _userApplicationService
          .getUserApplicationId(userId, applicationId);
      String storedPassword =
          await _userApplicationService.getPassword(userApplicationId);

      if (password == storedPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Successful'),
              content: Text('You have successfully logged in.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (selectedApplication != null &&
                        selectedApplication?.applicationName == 'Membership') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembershipPage()),
                      );
                    } else if (selectedApplication != null &&
                        selectedApplication?.applicationName == 'Wow') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WowPage()),
                      );
                    } else if (selectedApplication != null &&
                        selectedApplication?.applicationName == 'Current') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CurrentPage()),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password.'),
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
    } catch (e) {
      if (e.toString().contains('Username not found')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Username not found'),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Username and app doesnt match Please Register to a app'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Membership Management'),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/membership-management-logo.jpeg',
              ),
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20.0),
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
                onPressed: _login,
                child: Text(
                  'Login',
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
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
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
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerToApplication,
                child: Text(
                  'Sign Up to Application',
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
