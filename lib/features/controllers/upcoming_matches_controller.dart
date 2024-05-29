import 'package:get/get.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/service/firestore_services.dart';
import 'package:intl/intl.dart';

class UpcomingMatchesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var upcomingMatches = <Game>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUpcomingMatches(showShimmer: true);
    super.onInit();
  }

  Future<void> fetchUpcomingMatches({required bool showShimmer}) async {
    if (showShimmer) {
      isLoading.value = true;
    }
    try {
      upcomingMatches.clear();
      DateTime today = DateTime.now();
      for (int i = 1; i <= 7; i++) {
        String dateStr = DateFormat('yyyy-MM-dd').format(today.add(Duration(days: i)));
        var dayGames = await _firestoreService.getGamesByDate(dateStr);
        upcomingMatches.addAll(dayGames);
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
