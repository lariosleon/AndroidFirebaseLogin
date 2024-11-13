import 'package:flutter/material.dart';
import 'package:profile_app/pages/login.dart';
import 'package:profile_app/pages/signup.dart';

class ToggleLoginRegister extends StatefulWidget {
  const ToggleLoginRegister({super.key});

  @override
  State<ToggleLoginRegister> createState() => _ToggleLoginRegisterState();
}

class _ToggleLoginRegisterState extends State<ToggleLoginRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SignupPage(
        onTap: togglePages,
      );
    }
  }
}
