import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with Name and Title
            Container(
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Christian Plasabas',
                    style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 56),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'backend programmer',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white70,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Profile Image
            Image.asset('assets/images/profile.png'),

            // Introduction and Skills Section
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 50),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    'INTRODUCTION',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et ex ut nibh hendrerit pellentesque ipsum dolor sit amet, consectetur adipiscing elit. Donec et ex ut nibh hendrerit pellentesque. ',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    'WHAT I DO',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SkillSection(
                    icon: Icons.web,
                    title: 'Web Development',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  const SizedBox(height: 20),
                  SkillSection(
                    icon: Icons.storage,
                    title: 'Database',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  const SizedBox(height: 20),
                  SkillSection(
                    icon: Icons.code,
                    title: 'Scripting',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Project Section Example
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    'Point of Sale System',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/pos.png', // Replace with your asset path
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: ContactForm(), // Display the Contact Form here
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for each skill section
class SkillSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SkillSection(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final formKey = GlobalKey<FormState>();
  String initialCountry = 'PH';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PH');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Text(
              'Contact Me',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Cody Fisher',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Email Address',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'cody.fisher45@example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Phone Number',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // print(number.phoneNumber);
              },
              initialValue: phoneNumber,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              inputDecoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Comment',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Your comment...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 44),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form submitted')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 16),
                  backgroundColor: Colors.black,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
