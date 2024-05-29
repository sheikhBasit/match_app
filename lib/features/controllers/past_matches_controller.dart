import 'package:get/get.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/service/firestore_services.dart';
import 'package:intl/intl.dart';

class PastMatchesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var pastMatches = <Game>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPastMatches(showShimmer: true);
    super.onInit();
  }

  Future<void> fetchPastMatches({required bool showShimmer}) async {
    if (showShimmer) {
      isLoading.value = true;
    }
    try {
      pastMatches.clear();
      DateTime today = DateTime.now();
      for (int i = 1; i <= 9; i++) {
        String dateStr = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: i)));
        // Change the return type of getGamesByDate to List<dynamic>
        Map<String, dynamic> dayGames = await _firestoreService.getGamesByDate(dateStr);
        // Extract the matches data from dayGames
        List<dynamic> matchesData = dayGames['matches'] ?? [];
        // Convert matches data to Game objects
        List<Game> dayGamesList = matchesData.map((match) => Game.fromJson(match)).toList();
        // Add the Game objects to upcomingMatches
        pastMatches.addAll(dayGamesList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch Upcoming matches: $e');
    } finally {
      if (showShimmer) {
        isLoading.value = false;
      }
    }
  }
}
