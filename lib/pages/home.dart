import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_app/pages/encryption.dart';
import 'package:profile_app/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _showAppBar = true;
  int _selectedIndex = 0;
  int previousIndex = 0; // To keep track of the previous index

  @override
  void initState() {
    super.initState();
    // Set a timer to hide the AppBar after 8 seconds
    Timer(Duration(seconds: 8), () {
      setState(() {
        _showAppBar = false;
      });
    });
  }

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Store the current index before changing it
      previousIndex = _selectedIndex;

      // Set the selected index to Logout and show the logout dialog
      setState(() {
        _selectedIndex = index;
      });

      final shouldLogout = await _showLogoutDialog(context);

      if (shouldLogout == true) {
        // User confirmed logout, so perform the logout action
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).popUntil((route) =>
            route.isFirst); // Go back to the initial screen or login page
      } else {
        // User canceled logout, so revert to the previous index
        setState(() {
          _selectedIndex = previousIndex;
        });
      }
    } else {
      // For other icons, update the selected index as usual and store the previous index
      setState(() {
        previousIndex = _selectedIndex;
        _selectedIndex = index;
      });
    }
  }

  Future<bool?> _showLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('Logout?'),
          ],
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No, Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes, Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static final List<Widget> _pages = <Widget>[
    ProfilePage(),
    EncryptionPage(),
    Center(), // Placeholder widget for logout page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300), // Animation duration
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1.0,
              child: child,
            );
          },
          child: _showAppBar
              ? AppBar(
                  key: ValueKey("AppBar"),
                  backgroundColor: const Color.fromRGBO(103, 58, 183, 1),
                  title: Center(
                    child: Text(
                      "Logged in as ${user.email!}",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(key: ValueKey("NoAppBar")),
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Encryption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
