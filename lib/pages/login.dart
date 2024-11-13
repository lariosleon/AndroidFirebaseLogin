import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isObscured = true;

  @override
  void dispose() {
    super.dispose();
  }

  // error message
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.deepPurple,
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ));
        });
  }

  // sign user in method
  void loginUser() async {
    // Show the loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Attempt to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication exceptions
      if (mounted) {
        Navigator.pop(context);
      }

      if (e.code == 'invalid-credential') {
        showErrorMessage("Incorrect email or password.");
      } else if (e.code == 'channel-error') {
        showErrorMessage("Please don't leave the fields blank.");
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      print('Google sign-in aborted or failed.');
      return; // Exit if googleUser is null
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName ?? 'No display name available');
  }

  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;

      if (accessToken != null) {
        // Use accessToken.token to get the actual token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase with the Facebook credential
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          print('Successfully signed in with Facebook!');
        } catch (e) {
          print('Firebase sign-in error: $e');
        }
      }
    } else {
      print('Facebook login failed: ${result.message}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(20.0), // Padding around the whole column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                Row(
                  children: [
                    Text(
                      'Login to your account',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -1),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("It's great to see you again."),
                  ],
                ),

                const SizedBox(height: 26),

                Row(
                  children: [
                    Text(
                      'Email',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.3),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Password TextField
                Row(
                  children: [
                    Text(
                      'Password',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                TextField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.3),
                      ),
                      suffixIcon: IconButton(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          icon: _isObscured
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          })),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Text('Forgot your password?'),
                    const SizedBox(width: 5),
                    Text(
                      'Reset your password',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.3),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: loginUser,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text("Or", style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(child: Divider()),
                ]),

                const SizedBox(height: 30),

                Container(
                  height: 65,
                  margin: const EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            10, 10)), // No radius for button shape
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 32,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Login with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  height: 65,
                  margin: const EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      signInWithFacebook();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.elliptical(
                            10, 10)), // No radius for button shape
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/facebook.png',
                          height: 32,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Login with Facebook',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        widget.onTap!();
                      },
                      child: Text(
                        'Join',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
