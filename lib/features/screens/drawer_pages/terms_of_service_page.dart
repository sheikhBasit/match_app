import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  final String termsOfService = '''
  1. Acceptance of Terms
  By accessing and using this application, you accept and agree to be bound by the terms and provisions of this agreement.

  2. Description of Service
  Our application provides users with access to a variety of resources, including, but not limited to, news, match schedules, and streaming services.

  3. User Responsibilities
  Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account.

  4. Privacy Policy
  We value your privacy and are committed to protecting your personal information. Our privacy policy outlines our practices in detail.

  5. Modifications to Service
  We reserve the right to modify or discontinue, temporarily or permanently, the Service (or any part thereof) with or without notice.

  6. Termination
  We may terminate or suspend your access to our Service immediately, without prior notice or liability, for any reason whatsoever, including, without limitation, if you breach the Terms.

  7. Governing Law
  These Terms shall be governed and construed in accordance with the laws of the country, without regard to its conflict of law provisions.

  8. Contact Us
  If you have any questions about these Terms, please contact us.
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildTermsOfServiceSections(),
                ],
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

  List<Widget> _buildTermsOfServiceSections() {
    List<String> sections = termsOfService.split('\n\n');
    return sections.map((section) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          section.trim(),
          style: TextStyle(
            fontSize: section.startsWith(RegExp(r'[0-9]\.')) ? 18 : 16,
            fontWeight: section.startsWith(RegExp(r'[0-9]\.'))
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          textAlign: TextAlign.justify,
        ),
      );
    }).toList();
  }
}
