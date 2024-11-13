import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isObscured = true;


  @override
  void dispose() {
    super.dispose();
  }
  
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

  void signupUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context);
        showErrorMessage('Passwords do not match.');
      }
    } on FirebaseAuthException catch (e) {
      // Specific error handling
      if (mounted) {
        Navigator.pop(context);
      }
      if (e.code == 'channel-error') {
        showErrorMessage("Please don't leave the fields blank.");
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage('Email is already in use.');
      } else if (e.code == 'weak-password') {
        showErrorMessage('Password should atleast have 6 characters.');
      } else {
        showErrorMessage('An error occurred. Please try again later.');
      }
    }
  }

  signUpWithGoogle() async {
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

  Future<void> signUpWithFacebook() async {
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
                const SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      'Create an account',
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
                    Text("Let's create your account."),
                  ],
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 16.5),

                Row(
                  children: [
                    Text(
                      'Confirm Password',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                      hintText: 'Confirm password',
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
                const SizedBox(height: 16),

                Row(
                  children: [
                    Text(
                      'By signing up you agree to our ',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Terms, ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.3),
                    ),
                    Text(
                      'Privacy Policy, ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.3),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('and ',
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    Text(
                      'Cookie Use, ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.3),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: signupUser,
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
                        "Create an Account",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text("Or", style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(child: Divider()),
                ]),

                const SizedBox(height: 20),

                Container(
                  height: 65,
                  margin: const EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {
                      signUpWithGoogle();
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
                          'Sign Up with Google',
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
                      signUpWithFacebook();
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
                          'Sign Up with Facebook',
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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account?",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        widget.onTap!();
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
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
