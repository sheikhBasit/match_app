import 'dart:async';

import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

@override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

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
            primaryColor: const Color.fromRGBO(183, 39, 81, 1),
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(183, 39, 81, 1),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(183, 39, 81, 1),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(183, 39, 81, 1),
            ),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: const Color.fromRGBO(183, 39, 81, 1),
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color.fromRGBO(183, 39, 81, 1),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(183, 39, 81, 1),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(183, 39, 81, 1),
            ),
          ),
          themeMode: themeProvider.currentTheme,
          home:  AnimatedSplashScreen(
                duration: 3000,
                splash: Image.asset(
                  'assets/logo/logo.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                ),
                nextScreen: const HomePage() ,
                splashTransition: SplashTransition.fadeTransition,
                backgroundColor: themeProvider.isDarkTheme ? backgroundColor : Colors.white,
              
          ),
        );
      },
    );
  }
}
