// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_app/features/screens/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
enum ScreenState { Forgot, Congratulation, SetPassword, Verification }

class ForgotPage extends StatefulWidget {
  ForgotPage({super.key});
  SharedPreferences? prefs;

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  ScreenState _currentState = ScreenState.Forgot;
  final TextEditingController _emailController = TextEditingController();
  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentState == ScreenState.Forgot
            ? 'Forgot Password'
            : _currentState == ScreenState.Congratulation
                ? 'Congratulations'
                : _currentState == ScreenState.SetPassword
                    ? 'Set Password'
                    : 'Verification'),
      ),
      body: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (_currentState) {
      case ScreenState.Forgot:
        return _buildForgotPage();
      case ScreenState.Congratulation:
        return _buildCongratulationScreen();
      default:
        return Container();
    }
  }

  Widget _buildForgotPage() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Please enter your email address to request a password reset",
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: "Enter your email",
              labelText: "Email",
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              _forgotPassword(_emailController.text, context);
            },
            child: const Text("SEND"),
          ),
        ],
      ),
    );
  }

  Widget _buildCongratulationScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
              "An email has been sent to your email address, please check your inbox"),
          const SizedBox(height: 70),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(prefs: prefs)));
            },
            child: const Text("Go To Login"),
          ),
        ],
      ),
    );
  }

  void _forgotPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _currentState = ScreenState.Congratulation;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error sending password reset email: $e');
      }
      // Display error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Email Address. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _resetPassword(String newPassword, BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        setState(() {
          _currentState = ScreenState.Verification;
        });
      } else {
        if (kDebugMode) {
          print('User not logged in');
        }
        // Display error message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting password: $e');
      }
      // Display error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error resetting password [invalid email]'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
