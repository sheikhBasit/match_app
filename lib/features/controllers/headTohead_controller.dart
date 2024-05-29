import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_app/features/models/h2h_model.dart'; // Updated import

class HeadToHeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<HeadToHeadMatch> headToHeadMatches =
      <HeadToHeadMatch>[].obs; // Updated type

  Future<void> fetchHeadToHeadMatches(
      String homeTeamId, String awayTeamId) async {
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
        final matchesData = data['response']; // Updated
        print("MatchesData: $matchesData"); // Print matchesData here
        // Check if matchesData exists and is a List
        if (matchesData != null && matchesData is List) {
          final List<HeadToHeadMatch> matches = matchesData
              .map((match) => HeadToHeadMatch.fromJson(
                  (match as Map<String, dynamic>))) // Updated type
              .toList();
          print("MatchesData: $matches"); // Print matchesData here

          headToHeadMatches.assignAll(matches);
        } else {
          // If matchesData is null or not a List, clear the matches list
          headToHeadMatches.clear();
        }
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
}
