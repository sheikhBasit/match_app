import 'package:get/get.dart';
import 'package:match_app/features/controllers/headTohead_controller.dart';
import 'package:match_app/features/controllers/live_matches_controller.dart';
import 'package:match_app/features/controllers/past_matches_controller.dart';
import 'package:match_app/features/controllers/upcoming_matches_controller.dart';
import 'package:match_app/features/controllers/standings_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MatchController());
    Get.put(HeadToHeadController());
    Get.put(PastMatchesController());
    Get.put(UpcomingMatchesController());
    Get.put(StandingsController());
  }
}
