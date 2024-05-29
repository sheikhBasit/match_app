import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:match_app/features/models/team_standing.dart';

class StatsController extends GetxController {
  var isLoading = true.obs;
  var teamStats = Rxn<TeamStanding>();
  final GetStorage _storage = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchTeamStatsById(String teamId) async {
    try {
      isLoading(true);
      DocumentSnapshot docSnapshot = await _firestore.collection('statistics').doc(teamId).get();
      if (docSnapshot.exists) {
        TeamStanding stats = TeamStanding.fromJson(docSnapshot.data() as Map<String, dynamic>);
        teamStats.value = stats;
        // Cache the fetched stats data
        _storage.write('team_stats_$teamId', docSnapshot.data());
      } else {
        // If no document exists, check if cached data is available
        final cachedData = _storage.read('team_stats_$teamId');
        if (cachedData != null) {
          teamStats.value = TeamStanding.fromJson(cachedData);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
