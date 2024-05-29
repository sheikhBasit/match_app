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
      for (int i = 1; i <= 7; i++) {
        String dateStr = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: i)));
        var dayGames = await _firestoreService.getGamesByDate(dateStr);
        pastMatches.addAll(dayGames);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch past matches: $e');
    } finally {
      if (showShimmer) {
        isLoading.value = false;
      }
    }
  }
}
