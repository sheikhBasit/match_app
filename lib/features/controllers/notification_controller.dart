import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final box = GetStorage();
  late RxSet<int> selectedMatches;

  @override
  void onInit() {
    super.onInit();
    final selectedMatchesList = box.read('selectedMatches');
    if (selectedMatchesList is List<int>) {
      selectedMatches = selectedMatchesList.toSet().obs;
    } else {
      selectedMatches = <int>{}.obs;
    }
  }

void toggleMatchNotification(int matchId) {
  if (selectedMatches.contains(matchId)) {
    print('Removing match $matchId from selectedMatches');
    selectedMatches.remove(matchId);
  } else {
    print('Adding match $matchId to selectedMatches');
    selectedMatches.add(matchId);
  }
  box.write('selectedMatches', selectedMatches.toList());
  // Manually trigger UI update
  update();
}

}
