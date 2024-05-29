import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_app/features/models/h2h_model.dart'; // Updated import

class HeadToHeadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<HeadToHeadMatch> headToHeadMatches =
      <HeadToHeadMatch>[].obs; // Updated type

  // Define a boolean variable to track loading state
  var isLoading = true.obs;

  Future<void> fetchHeadToHeadMatches(String homeTeamId, String awayTeamId) async {
    try {
      // Set loading state to true
      isLoading(true);

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

        // Clear existing matches
        headToHeadMatches.clear();

        // Loop through each match in matchesData
        for (var matchData in matchesData) {
          // Convert matchData to HeadToHeadMatch object
          final HeadToHeadMatch match = HeadToHeadMatch.fromJson(matchData);
          // Add match to the list
          headToHeadMatches.add(match);
        }

        // Set loading state to false
        isLoading(false);

        // Trigger UI update
        update();
      } else {
        // Set loading state to false
        isLoading(false);

        // Handle case where no head-to-head matches are found
        headToHeadMatches.clear();
      }
    } catch (error) {
      // Set loading state to false
      isLoading(false);

      // Handle error fetching data from Firestore
      print('Error fetching head-to-head matches: $error');
    }
  }
}
