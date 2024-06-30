import 'dart:async';
import 'package:get/get.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/service/firestore_services.dart';
import 'package:intl/intl.dart';

class UpcomingMatchesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var upcomingMatches = <Game>[].obs;
  var isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
<<<<<<< Updated upstream
=======
    fetchUpcomingMatches(showShimmer: true);
    _setupTimer();
>>>>>>> Stashed changes
    super.onInit();
    fetchUpcomingMatches(showShimmer: true);
    _setupTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(minutes: 30), (Timer t) async {
      await fetchUpcomingMatches(showShimmer: false);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(minutes: 30), (Timer t) async {
      await fetchUpcomingMatches(showShimmer: false);
    });
  }

  Future<void> fetchUpcomingMatches({required bool showShimmer}) async {
    if (showShimmer) {
      isLoading.value = true;
    }
    try {
      upcomingMatches.clear();
      DateTime today = DateTime.now();
      print(
          'Fetching matches starting from: ${DateFormat('yyyy-MM-dd').format(today)}');
      for (int i = 1; i <= 9; i++) {
<<<<<<< Updated upstream
        String dateStr =
            DateFormat('yyyy-MM-dd').format(today.add(Duration(days: i)));
        print('Fetching matches for date: $dateStr');
        Map<String, dynamic> dayGames =
            await _firestoreService.getGamesByDate(dateStr);
        print('Data for $dateStr: $dayGames');
        List<dynamic> matchesData = dayGames['response'] ?? [];
        List<Game> dayGamesList =
            matchesData.map((match) => Game.fromJson(match)).toList();
        print('Parsed games for $dateStr: $dayGamesList');
=======
        String dateStr = DateFormat('yyyy-MM-dd').format(today.add(Duration(days: i)));
        Map<String, dynamic> dayGames = await _firestoreService.getGamesByDate(dateStr);
        List<dynamic> matchesData = dayGames['matches'] ?? [];
        List<Game> dayGamesList = matchesData.map((match) => Game.fromJson(match)).toList();
>>>>>>> Stashed changes
        upcomingMatches.addAll(dayGamesList);
      }
      print('All upcoming matches: $upcomingMatches');
    } catch (e) {
      print('Error fetching matches: $e');
      Get.snackbar('Error', 'Failed to fetch Upcoming matches: $e');
    } finally {
      if (showShimmer) {
        isLoading.value = false;
      }
    }
  }
}
