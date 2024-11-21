import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: Colors.black,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to BMS CE Canteens. These terms and conditions outline the rules and regulations for the use of our application. By accessing this app, we assume you accept these terms and conditions in full. Do not continue to use BMS CE Canteens if you do not accept all of the terms and conditions stated on this page.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                '2. User Responsibilities',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'By using this app, you agree to comply with all applicable laws and regulations. You are responsible for ensuring that your use of the app does not violate any applicable law, regulation, or terms of service.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                '3. Privacy Policy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your privacy is important to us. Please review our Privacy Policy, which explains how we collect, use, and protect your personal information.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                '4. Changes to Terms',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We may update these terms and conditions from time to time. Any changes will be posted on this page, and your continued use of the app constitutes acceptance of the updated terms and conditions.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                '5. Contact Us',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or concerns about these terms and conditions, please contact us at support@bmscecanteens.com.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
