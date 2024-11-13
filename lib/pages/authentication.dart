import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profile_app/pages/home.dart';
import 'package:profile_app/pages/toggle_login_regiser.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return ToggleLoginRegister();
        }
      },
    );
  }
}
