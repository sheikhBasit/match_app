// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'privacy_policy_page.dart';
// import 'terms_of_service_page.dart';

// class SettingsPage extends StatefulWidget {
//   final SharedPreferences prefs;

//   const SettingsPage({Key? key, required this.prefs}) : super(key: key);

//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _isDarkMode = widget.prefs.getBool('darkMode') ?? false;
//   }

//   void _toggleDarkMode(bool value) {
//     setState(() {
//       _isDarkMode = value;
//       widget.prefs.setBool('darkMode', value);
//     });
//   }

//   void _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LoginPage(
//           prefs: widget.prefs,
//         ),
//       ),
//       (Route<dynamic> route) => false, // Prevent going back to home
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//         actions: [
//           IconButton(
//             icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () => _toggleDarkMode(!_isDarkMode),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           ListTile(
//             title: const Text('Account'),
//             leading: const Icon(Icons.account_circle),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const AccountSettingsPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Notification Preferences'),
//             leading: const Icon(Icons.notifications),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const NotificationPreferencesPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Streaming Settings'),
//             leading: const Icon(Icons.videocam),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const StreamingSettingsPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('News Preferences'),
//             leading: const Icon(Icons.article),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const NewsPreferencesPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Privacy Policy'),
//             leading: const Icon(Icons.privacy_tip),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Terms of Service'),
//             leading: const Icon(Icons.description),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => TermsOfServicePage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Logout'),
//             leading: const Icon(Icons.exit_to_app),
//             onTap: () => _logout(context), // Pass context here
//           ),
//         ],
//       ),
//     );
//   }
// }
