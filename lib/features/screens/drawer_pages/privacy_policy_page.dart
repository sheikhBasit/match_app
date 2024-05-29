import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String privacyPolicy = '''
  We value the privacy of our users and are committed to protecting it. This Privacy Policy explains how we collect, use, and disclose information about you when you use our application.

  Information Collection and Use
  We collect information you provide directly to us, such as when you create or modify your account, submit content, or contact us for support. This information may include your name, email address, and any other information you choose to provide.

  Log Data
  We may also collect log information when you use our application. This may include your device's Internet Protocol (IP) address, browser type, browser version, and other statistics.

  Cookies
  We use cookies and similar tracking technologies to track activity on our application and hold certain information.

  Security
  The security of your personal information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage, is 100% secure. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.

  Changes to This Privacy Policy
  We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

  Contact Us
  If you have any questions about this Privacy Policy, please contact us.
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  privacyPolicy.trim(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
