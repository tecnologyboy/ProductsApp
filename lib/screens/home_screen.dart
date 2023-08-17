import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'Login';
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Login'),
      ),
    );
  }
}
