import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EncryptionPage extends StatefulWidget {
  const EncryptionPage({super.key});

  @override
  EncryptionPageState createState() => EncryptionPageState();
}

class EncryptionPageState extends State<EncryptionPage> {
  final TextEditingController plaintextController = TextEditingController();
  final TextEditingController keystreamController = TextEditingController();
  String plaintext = '';
  String result = '';
  String selectedMethod = 'Atbash';
  String operation = 'Encrypt'; // New variable to track operation
  int shift = Random().nextInt(3) + 1;
  final String vigenereKey = "IT312";

  final methods = ["Atbash", "Caesar", "Vigenère"];

  String caesarCipher(String text, int shift, {bool encrypt = true}) {
    return text.split('').map((char) {
      if (char.contains(RegExp(r'[a-zA-Z]'))) {
        final base = char == char.toUpperCase() ? 65 : 97;
        final actualShift =
            encrypt ? shift : -shift; // Use the shift accordingly
        return String.fromCharCode(
            (char.codeUnitAt(0) - base + actualShift + 26) % 26 + base);
      }
      return char;
    }).join('');
  }

  String atbashCipher(String text) {
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    final reversedAlphabet = alphabet.split('').reversed.join();
    final Map<String, String> translationTable = {};

    for (var i = 0; i < alphabet.length; i++) {
      translationTable[alphabet[i]] = reversedAlphabet[i];
      translationTable[alphabet[i].toUpperCase()] =
          reversedAlphabet[i].toUpperCase();
    }

    return text
        .split('')
        .map((char) => translationTable[char] ?? char)
        .join('');
  }

  String vigenereCipher(String text, String key, {bool encrypt = true}) {
    key = key.toUpperCase();
    int keyIndex = 0;

    return text.split('').map((char) {
      if (char.contains(RegExp(r'[a-zA-Z]'))) {
        final base = char == char.toUpperCase() ? 65 : 97;
        final shift =
            (key.codeUnitAt(keyIndex % key.length) - 65) * (encrypt ? 1 : -1);
        keyIndex++;
        return String.fromCharCode(
            (char.codeUnitAt(0) - base + shift + 26) % 26 + base);
      }
      return char;
    }).join('');
  }

  void processText() {
    setState(() {
      plaintext = plaintextController.text;
      bool isEncrypting = operation == 'Encrypt'; // Check the operation

      switch (selectedMethod) {
        case 'Caesar':
          result = caesarCipher(
              plaintext, int.tryParse(keystreamController.text) ?? shift,
              encrypt: isEncrypting);
          break;
        case 'Atbash':
          result = isEncrypting
              ? atbashCipher(plaintext)
              : atbashCipher(plaintext); // Atbash is symmetric
          break;
        case 'Vigenère':
          result = vigenereCipher(
              plaintext,
              keystreamController.text.isEmpty
                  ? vigenereKey
                  : keystreamController.text,
              encrypt: isEncrypting);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
            child: Text('Encryption Generator',
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w700))),
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Select Operation',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Encrypt',
                        style: GoogleFonts.poppins(
                            fontSize: 15.5, fontWeight: FontWeight.w600),
                      ),
                      value: 'Encrypt',
                      groupValue: operation,
                      onChanged: (value) {
                        setState(() {
                          operation = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        'Decrypt',
                        style: GoogleFonts.poppins(
                            fontSize: 15.5, fontWeight: FontWeight.w600),
                      ),
                      value: 'Decrypt',
                      groupValue: operation,
                      onChanged: (value) {
                        setState(() {
                          operation = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Encryption Methods',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: Row(
                  children: [
                    Text(
                      'Atbash Cipher',
                      style: GoogleFonts.poppins(
                          fontSize: 15.5, fontWeight: FontWeight.w600),
                    ),
                    Card(
                      color: const Color.fromARGB(
                          115, 243, 240, 240), // Background color of the card
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 4, 8, 4), // Padding inside the card
                        child: Text(
                          'Default',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w600), // Text color
                        ),
                      ),
                    ),
                  ],
                ),
                value: 'Atbash',
                groupValue: selectedMethod,
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Caesar Cipher',
                    style: GoogleFonts.poppins(
                        fontSize: 15.5, fontWeight: FontWeight.w600)),
                value: 'Caesar',
                groupValue: selectedMethod,
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Vigenère Cipher',
                    style: GoogleFonts.poppins(
                        fontSize: 15.5, fontWeight: FontWeight.w600)),
                value: 'Vigenère',
                groupValue: selectedMethod,
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Plaintext:',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: plaintextController,
                decoration: InputDecoration(
                  hintText: operation == 'Encrypt'
                      ? 'Enter plaintext to be encrypted'
                      : 'Enter plaintext to be decrypted',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedMethod == 'Caesar' ||
                  selectedMethod == 'Vigenère') ...[
                Text("Keystream:",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: keystreamController,
                  decoration: InputDecoration(
                    hintText: selectedMethod == 'Caesar'
                        ? 'Enter shift value (default: 3)'
                        : 'Enter keystream (default: IT312)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ],
              const SizedBox(height: 16),
              Container(
                height: 60,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    processText();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.elliptical(
                          10, 10)), // No radius for button shape
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        operation,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5),
                      operation == 'Encrypt'
                          ? Icon(
                              Icons.lock,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.lock_open,
                              color: Colors.white,
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Result:',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                result,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
