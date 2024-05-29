import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<Map<String, dynamic>> getGamesByDate(String date) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> gamesSnapshot = await _firestore
        .collection('games')
        .doc(date)
        .get();
    if (!gamesSnapshot.exists) {
      // If the document does not exist, return an empty map
      return {};
    }

    // Extract the data from the document snapshot
    Map<String, dynamic> gamesData = gamesSnapshot.data()!;

    // Extract the "matches" map from the retrieved data
    Map<String, dynamic> matchesData = gamesData['matches'] ?? {};

    return matchesData;
  } catch (e) {
    print('Error fetching games for date $date: $e');
    return {};
  }
}

  // Future<List<Game>> getGamesByDate(String date) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> gamesSnapshot = await _firestore
  //         .collection('games')
  //         .where(FieldPath.documentId, isEqualTo: date)
  //         .get();
  //     // print('Number of documents retrieved: ${gamesSnapshot.docs.length}');

  //     List<Game> gamesList = [];

  //     for (var doc in gamesSnapshot.docs) {
  //       final Map<String, dynamic> rawData = doc.data();
  //       // print(rawData['response'].length);
  //       final results = rawData['results'];
  //       for (var i = 0; i < results; i++) {
  //         final data = rawData['response'][i];
  //         final game = Game(
  //           results: rawData['results'] as int,
  //           id: data['id'] as int,
  //           date: DateTime.parse(data['date'] as String),
  //           time: data['time'] as String,
  //           timestamp: data['timestamp'] as int,
  //           timezone: data['timezone'] as String,
  //           status: Status(
  //             long: data['status']['long'] as String,
  //             short: data['status']['short'] as String,
  //           ),
  //           leagueName: data['league']['name'] as String,
  //           homeTeam: Team(
  //             id: data['teams']['home']['id'] as int,
  //             name: data['teams']['home']['name'] as String,
  //             logo: data['teams']['home']['logo'] as String,
  //           ),
  //           awayTeam: Team(
  //             id: data['teams']['away']['id'] as int,
  //             name: data['teams']['away']['name'] as String,
  //             logo: data['teams']['away']['logo'] as String,
  //           ),
  //           homeScore: Score(
  //             total: data['scores']['home']['total'] as int?,
  //             hits: data['scores']['home']['hits'] as int?,
  //             errors: data['scores']['home']['errors'] as int?,
  //             innings: data['scores']['home']['innings'] != null
  //                 ? Map<String, dynamic>.from(data['scores']['home']['innings'] as Map<String, dynamic>)
  //                 : null,
  //           ),
  //           awayScore: Score(
  //             total: data['scores']['away']['total'] as int?,
  //             hits: data['scores']['away']['hits'] as int?,
  //             errors: data['scores']['away']['errors'] as int?,
  //             innings: data['scores']['away']['innings'] != null
  //                 ? Map<String, dynamic>.from(data['scores']['away']['innings'] as Map<String, dynamic>)
  //                 : null,
  //           ),
  //         );

  //         gamesList.add(game);
  //       }
  //     }

  //     return gamesList;
  //   } catch (e) {
  //     print('Error fetching games for date $date: $e');
  //     return [];
  //   }
  // }
}
