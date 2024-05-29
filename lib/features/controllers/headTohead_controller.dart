import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_app/features/models/game_model.dart';

class HeadToHeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Game> headToHeadMatches = <Game>[].obs;

  Future<void> fetchHeadToHeadMatches(String homeTeamId, String awayTeamId) async {
    try {
      // Try to get the document with homeTeamId-awayTeamId
      DocumentSnapshot snapshot = await _firestore
          .collection('headTohead')
          .doc('$homeTeamId-$awayTeamId')
          .get();

      if (!snapshot.exists) {
        // If not found, try with awayTeamId-homeTeamId
        snapshot = await _firestore
            .collection('headTohead')
            .doc('$awayTeamId-$homeTeamId')
            .get();
      }

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final matchesData = data['response'] as List<dynamic>;

        print('Total Matches: ${matchesData.length}');
        
        for (var match in matchesData) {
          print('Match Data: $match');
        }

        final List<Game> matches = matchesData
            .map((match) => Game.fromJson(_handleNullValues(match as Map<String, dynamic>)))
            .toList();

        headToHeadMatches.assignAll(matches);
      } else {
        // Handle case where no head-to-head matches are found
        headToHeadMatches.clear();
      }
    } catch (error) {
      // Handle error fetching data from Firestore
      print('Error fetching head-to-head matches: $error');
    }
  }

  // Handle null values by providing default values
  Map<String, dynamic> _handleNullValues(Map<String, dynamic> json) {
    return {
      'homeTeam': json['homeTeam'] ?? {'name': 'Unknown', 'logo': '', 'id': ''},
      'awayTeam': json['awayTeam'] ?? {'name': 'Unknown', 'logo': '', 'id': ''},
      'date': json['date'] ?? DateTime.now().toString(),
      'time': json['time'] ?? '00:00',
      'status': {
        'long': json['status']?['long'] ?? 'Unknown',
        'short': json['status']?['short'] ?? 'NS',
      },
      'homeScore': {
        'total': json['homeScore']?['total'] ?? 0,
      },
      'awayScore': {
        'total': json['awayScore']?['total'] ?? 0,
      },
    };
  }
}
