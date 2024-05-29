import 'dart:async';
import 'package:get/get.dart';
import 'package:match_app/features/models/team_standing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class StandingsController extends GetxController {
  var isLoading = true.obs;
  var standings = <TeamStanding>[].obs;
  Timer? _timer;
  Timer? _autoRefreshTimer; // New timer for 30-second auto-refresh
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchStandingsFromFirestore();
    _setupTimers();
  }

  void _setupTimers() {
    // Cancel any existing timers if they are not null
    _timer?.cancel();
    _autoRefreshTimer?.cancel();

    // Setup a timer to refresh every 6 hours
    _timer = Timer.periodic(const Duration(hours: 6), (Timer t) async {
      await fetchStandingsFromFirestore();
    });

    // Setup a timer to refresh every 30 seconds
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      await fetchStandingsFromFirestore();
    });

    // Save the timer state in GetStorage
    _storage.write('timerStart', DateTime.now().toIso8601String());
  }

  Future<void> fetchStandingsFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> standingsSnapshot =
          await FirebaseFirestore.instance.collection('standings').get();

      List<TeamStanding> standingsList = [];
      for (var doc in standingsSnapshot.docs) {
        final Map<String, dynamic> jsonData = doc.data();
        final results = jsonData['standings'].length;
        // print('$results standings found');

        for (var i = 0; i < results; i++) {
          final data = jsonData['standings'][i];

          final teamStanding = TeamStanding(
            position: data['position'] ?? 0,
            stage: data['stage'] ?? '',
            groupName: data['group']['name'] ?? '',
            teamId: data['team']['id'] ?? 0,
            teamName: data['team']['name'] ?? '',
            teamLogo: data['team']['logo'] ?? '',
            leagueId: data['league']['id'] ?? 0,
            leagueName: data['league']['name'] ?? '',
            leagueLogo: data['league']['logo'] ?? '',
            leagueSeason: data['league']['season'] ?? 0,
            gamesPlayed: data['games']['played'] ?? 0,
            wins: data['games']['win']['total'] ?? 0,
            winPercentage: (data['games']['win']['percentage'] ?? 0.0).toString(),
            losses: data['games']['lose']['total'] ?? 0,
            losePercentage: (data['games']['lose']['percentage'] ?? 0.0).toString(),
            pointsFor: data['points']['for'] ?? 0,
            pointsAgainst: data['points']['against'] ?? 0,
            form: data['form'] ?? '',
          );

          standingsList.add(teamStanding);
        }
      }

      standings.value = standingsList;
      isLoading.value = false;
      // Convert TeamStanding objects to JSON-compatible maps
      List<Map<String, dynamic>> standingsMapList = standingsList.map((standing) => standing.toMap()).toList();
      // Save the successful state
      _storage.write('lastStandings', standingsMapList);
      _storage.remove('standingsError'); // Clear error flag
    } on FirebaseException catch (error) {
      print('Firebase Error fetching standings from Firestore: $error');
      // Handle error fetching standings
      _handleFetchError();
    } catch (error) {
      print('Error fetching standings from Firestore: $error');
      // Handle error fetching standings
      _handleFetchError();
    }
  }

  void _handleFetchError() {
    // Check if there was an error fetching data
    final bool standingsError = _storage.read('standingsError') ?? false;
    if (standingsError) {
      // Display last successful state
      final List<dynamic>? lastStandings = _storage.read('lastStandings');
      if (lastStandings != null) {
        standings.value = lastStandings.cast<TeamStanding>();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> refreshStandings() async {
    isLoading.value = true;
    await fetchStandingsFromFirestore();
  }

  @override
  void onClose() {
    _timer?.cancel(); // Ensure _timer is not null before cancelling
    _autoRefreshTimer?.cancel(); // Ensure _autoRefreshTimer is not null before cancelling
    super.onClose();
  }
}
