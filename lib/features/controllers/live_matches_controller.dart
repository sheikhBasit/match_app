import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:intl/intl.dart';
import 'package:match_app/features/service/firestore_services.dart';
import 'dart:async';

class MatchController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  RxList<Game> todayMatches = <Game>[].obs;
  RxBool isLoading = true.obs;
  RxBool isAutoRefreshing = false.obs;
  final storage = GetStorage();
  Timer? _timer; // Nullable timer for periodic refresh

  @override
  void onInit() {
    super.onInit();
    loadSavedMatches();
    fetchTodayMatches();
    _setupTimer();
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel timer when controller is closed
    super.onClose();
  }

  void _setupTimer() {
    // Cancel any existing timer if it is not null
    _timer?.cancel();

    // Setup a timer to refresh every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      isAutoRefreshing.value = true; // Indicate auto-refreshing
      await fetchTodayMatches();
      isAutoRefreshing.value = false; // Reset auto-refresh indicator
    });
  }

Future<void> fetchTodayMatches() async {
  if (!isAutoRefreshing.value) {
    isLoading.value = true;
  }
  try {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Map<String, dynamic> todayMatchesData = await _firestoreService.getGamesByDate(currentDate);
    final List<dynamic> matches = todayMatchesData['response']?? [];
    
    todayMatches.assignAll(matches.map((match) => Game.fromJson(match)).toList());
    saveMatchesToStorage(todayMatches);

    // Debug print statement to check the value
    print('Matches fetched at: ${DateTime.now()}');
    print('Number of matches: ${matches.length}');
  } catch (e) {
    print('Error fetching matches: $e');
    loadSavedMatches();
  } finally {
    if (!isAutoRefreshing.value) {
      isLoading.value = false;
    }
  }
}

  // Future<void> fetchTodayMatches() async {
  //   if (!isAutoRefreshing.value) {
  //     isLoading.value = true;
  //   }
  //   try {
  //     final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     final todayGames = await _firestoreService.getGamesByDate(currentDate);
  //     print('Today Games: ${todayGames}');
  //     todayMatches.assignAll(todayGames);
  //     saveMatchesToStorage(todayMatches);

  //     // Debug print statement to check the value
  //     print('Matches fetched at: ${DateTime.now()}');
  //     print('Number of matches: ${todayMatches.length}');
  //   } catch (e) {
  //     print('Error fetching matches: $e');
  //     loadSavedMatches();
  //   } finally {
  //     if (!isAutoRefreshing.value) {
  //       isLoading.value = false;
  //     }
  //   }
  // }

  void loadSavedMatches() {
    final dynamic savedData = storage.read("todayMatches");
    if (savedData != null && savedData is List) {
      final List<Map<String, dynamic>> savedMatches = List<Map<String, dynamic>>.from(savedData);
      todayMatches.assignAll(savedMatches.map((json) => Game.fromJson(json)).toList());
    }
  }

  void saveMatchesToStorage(List<Game> matches) {
    final List<Map<String, dynamic>> matchesJson = matches.map((game) => gameToMap(game)).toList();
    storage.write("todayMatches", matchesJson);
  }

  Map<String, dynamic> gameToMap(Game game) {
    return {
      'results': game.results,
      'id': game.id,
      'date': game.date.toIso8601String(),
      'time': game.time,
      'timestamp': game.timestamp,
      'timezone': game.timezone,
      'status': {'long': game.status.long, 'short': game.status.short},
      'league': {'name': game.leagueName},
      'teams': {
        'home': {'id': game.homeTeam.id, 'name': game.homeTeam.name, 'logo': game.homeTeam.logo},
        'away': {'id': game.awayTeam.id, 'name': game.awayTeam.name, 'logo': game.awayTeam.logo},
      },
      'scores': {
        'home': {
          'total': game.homeScore.total,
          'hits': game.homeScore.hits,
          'errors': game.homeScore.errors,
          'innings': game.homeScore.innings,
        },
        'away': {
          'total': game.awayScore.total,
          'hits': game.awayScore.hits,
          'errors': game.awayScore.errors,
          'innings': game.awayScore.innings,
        },
      },
    };
  }
}
