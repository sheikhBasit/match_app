import 'package:flutter/material.dart';
import 'package:match_app/common_widgets/theme_provider.dart';
import 'package:match_app/features/screens/routes/bindings.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:match_app/common_widgets/connectivity_check.dart';
import 'package:match_app/common_widgets/no_connectivity.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/notification_controller.dart';
import 'package:match_app/features/screens/ads/app_open_ad.dart';
import 'package:match_app/features/screens/home_screens/home_page.dart';
import 'package:match_app/firebase_options.dart';

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
  await MobileAds.instance.initialize();
  AppOpenAdManager.loadAppOpenAd();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Baseball Live',
          initialBinding: MainBindings(), // Set the initial binding here
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Color.fromARGB(255, 8, 4, 66),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: const Color.fromRGBO(183, 39, 81, 1),
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.currentTheme,
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
                backgroundColor: themeProvider.isDarkTheme ? backgroundColor : Colors.white,
              );
            },
          ),
        );
      },
    );
  }
}
