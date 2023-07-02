import 'package:flutter/material.dart';

class CurrentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Page'),
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
