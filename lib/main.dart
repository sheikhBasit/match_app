import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/notification_controller.dart';
import 'package:match_app/features/controllers/standings_controller.dart';
import 'package:match_app/features/screens/ads/app_open_ad.dart';
import 'package:match_app/features/screens/home_screens/home_page.dart';
import 'package:match_app/firebase_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await GetStorage.init();
  Get.put(NotificationController());
  Get.put(StandingsController());
  await MobileAds.instance.initialize();
  AppOpenAdManager.loadAppOpenAd();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MLB Stream',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: ConnectivityBuilder(
        builder: (BuildContext context, ConnectivityStatus status) {
          if (status == ConnectivityStatus.offline) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No internet connection.'),
                ),
              );
            });
          }
          final bool isConnected = status == ConnectivityStatus.online;
          return AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset(
              'assets/logo/logo.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
            ),
            nextScreen: isConnected ? const HomePage() : const NoInternetScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: backgroundColor,
          );
        },
      ),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'No internet connection.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

enum ConnectivityStatus { online, offline }

class ConnectivityBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ConnectivityStatus status) builder;

  const ConnectivityBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          final status = snapshot.data == ConnectivityResult.none
              ? ConnectivityStatus.offline
              : ConnectivityStatus.online;
          return builder(context, status);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
