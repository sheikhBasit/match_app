import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:match_app/features/models/team_standing.dart';
import 'package:match_app/features/screens/ads/interstitial_ad.dart';
import 'package:match_app/features/screens/home_screens/conference_standings.dart';
import 'package:match_app/features/controllers/standings_controller.dart';

class TournamentStandings extends StatefulWidget {

  TournamentStandings({super.key});

  @override
  State<TournamentStandings> createState() => _TournamentStandingsState();
}

class _TournamentStandingsState extends State<TournamentStandings> {
  final StandingsController standingsController = Get.find<StandingsController>();
 Timer? _adTimer;
@override
  void initState() {
    super.initState();

    // Load the interstitial ad when the page is initialized
    InterstitialAdManager.loadAd();

    // Set up a timer to show the ad after 10 seconds
    _adTimer = Timer(const Duration(seconds: 10), () {
      InterstitialAdManager.showAd();
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _adTimer?.cancel();

    // Ensure any active ads are disposed of
    InterstitialAdManager.disposeAd();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Obx(() {
            if (standingsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (standingsController.standings.isNotEmpty) {
                return _buildStandingsView(context);
              } else {
                // Check if there was an error fetching data
                final bool standingsError = GetStorage().read('standingsError') ?? false;
                if (standingsError) {
                  // Display last successful state
                  final List<dynamic>? lastStandings = GetStorage().read('lastStandings');
                  if (lastStandings != null) {
                    standingsController.standings.assignAll(
                      lastStandings.map((e) => TeamStanding.fromJson(e)).toList()
                    );
                    return _buildStandingsView(context);
                  } else {
                    return const Center(child: Text('No standings available.'));
                  }
                } else {
                  return const Center(child: Text('No standings available.'));
                }
              }
            }
          }),
        ),
      ),
    );
  }

  Widget _buildStandingsView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshStandings,
      child: Column(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'American League'),
                    Tab(text: 'National League'),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const TabBarView(
                    children: [
                      ConferenceStandings(conference: 'AL'),
                      ConferenceStandings(conference: 'NL'),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshStandings() async {
    // Check connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      // Fetch standings if there is an internet connection
      try {
        await standingsController.refreshStandings();
        // Store the successful state
        GetStorage().write('lastStandings', standingsController.standings.toList());
        GetStorage().remove('standingsError');
      } catch (error) {
        // Handle error fetching standings
        print('Error fetching standings from Firestore: $error');
        // Store the error state in Get Storage
        GetStorage().write('standingsError', true);
      }
    } else {
      // No internet connection, display last successful state if available
      final List<dynamic>? lastStandings = GetStorage().read('lastStandings');
      if (lastStandings != null) {
        standingsController.standings.assignAll(lastStandings as Iterable<TeamStanding>);
      }
      GetStorage().write('standingsError', true);
    }
  }
}
