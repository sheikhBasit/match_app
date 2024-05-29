// import 'package:flutter/material.dart';
// import 'package:livekick/controllers/app_open_ad.dart';
// import 'package:livekick/pages/splash_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   runApp(MyApp(prefs: prefs));
// }

// class MyApp extends StatefulWidget {
//   final SharedPreferences prefs;

//   const MyApp({super.key, required this.prefs});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   bool _adDisplayed = false; 
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && !_adDisplayed) {
//       // Show the ad only if it hasn't been displayed already
//       AppOpenAdManager.showAdIfAvailable();
//       _adDisplayed = true; // Mark the ad as displayed
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(prefs: widget.prefs),
//       // home: LoginPage(prefs: widget.prefs), // Moved to SplashScreen
//     );
//   }
// }
