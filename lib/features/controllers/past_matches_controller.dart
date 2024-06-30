import 'dart:async';
import 'package:get/get.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/service/firestore_services.dart';
import 'package:intl/intl.dart';

class PastMatchesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var pastMatches = <Game>[].obs;
  var isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
<<<<<<< Updated upstream
=======
    fetchPastMatches(showShimmer: true);
    _setupTimer();
>>>>>>> Stashed changes
    super.onInit();
    fetchPastMatches(showShimmer: true);
    _setupTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(minutes: 30), (Timer t) async {
      await fetchPastMatches(showShimmer: false);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(minutes: 30), (Timer t) async {
      await fetchPastMatches(showShimmer: false);
    });
  }

  Future<void> fetchPastMatches({required bool showShimmer}) async {
    if (showShimmer) {
      isLoading.value = true;
    }
    try {
      pastMatches.clear();
      DateTime today = DateTime.now();
      print(
          'Fetching matches starting from: ${DateFormat('yyyy-MM-dd').format(today)}');
      for (int i = 1; i <= 9; i++) {
<<<<<<< Updated upstream
        String dateStr =
            DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: i)));
        print('Fetching matches for date: $dateStr');
        Map<String, dynamic> dayGames =
            await _firestoreService.getGamesByDate(dateStr);
        print('Data for $dateStr: $dayGames');
        List<dynamic> matchesData = dayGames['response'] ?? [];
        List<Game> dayGamesList =
            matchesData.map((match) => Game.fromJson(match)).toList();
        print('Parsed games for $dateStr: $dayGamesList');
=======
        String dateStr = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: i)));
        Map<String, dynamic> dayGames = await _firestoreService.getGamesByDate(dateStr);
        List<dynamic> matchesData = dayGames['matches'] ?? [];
        List<Game> dayGamesList = matchesData.map((match) => Game.fromJson(match)).toList();
>>>>>>> Stashed changes
        pastMatches.addAll(dayGamesList);
      }
      print('All Past matches: $pastMatches');
    } catch (e) {
<<<<<<< Updated upstream
      print('Error fetching matches: $e');
=======
>>>>>>> Stashed changes
      Get.snackbar('Error', 'Failed to fetch Past matches: $e');
    } finally {
      if (showShimmer) {
        isLoading.value = false;
      }
    }
  }
}
