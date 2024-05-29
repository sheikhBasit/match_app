import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:match_app/features/controllers/headTohead_controller.dart';
import 'package:match_app/features/models/h2h_model.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';

class HeadToHeadPage extends StatelessWidget {
  final String homeTeamId;
  final String awayTeamId;

  HeadToHeadPage( {
    Key? key,
    required this.homeTeamId,
    required this.awayTeamId,
  }) : super(key: key);

  final HeadToHeadController headToHeadController = Get.put(HeadToHeadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Head-to-Head Matches'),
      ),
      body: Center(
        child: GetBuilder<HeadToHeadController>(
          init: headToHeadController,
          initState: (_) {
            // Fetch head-to-head matches when the view initializes
            headToHeadController.fetchHeadToHeadMatches(homeTeamId, awayTeamId);
          },
          builder: (controller) {
            if (controller.isLoading.value) {
              // Show circular loading indicator while data is being fetched
              return CircularProgressIndicator();
            } else if (controller.headToHeadMatches.isEmpty) {
              return const Text('No head-to-head matches found.');
            } else {
              // Sort matches based on status.short
              controller.headToHeadMatches.sort((a, b) {
                // Treat "NS" (Not Started) status as higher priority
                if (a.statusShort == 'NS' && b.statusShort != 'NS') {
                  return -1; // a should come before b
                } else if (a.statusShort != 'NS' && b.statusShort == 'NS') {
                  return 1; // b should come before a
                } else {
                  // For other statuses, maintain the original order
                  return 0;
                }
              });

              return ListView.builder(
                itemCount: controller.headToHeadMatches.length,
                itemBuilder: (context, index) {
                  final match = controller.headToHeadMatches[index];
                  return _buildGameItem(match, context);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildGameItem(HeadToHeadMatch matchDetails, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to match details page
          Get.to(() => MatchDetailsPage(headToHeadDetails: matchDetails));
        },
        child: Center(
          child: SizedBox(
            width: cardWidth(context),
            child: Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display league name
                    Text(
                      matchDetails.leagueName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Display teams and scores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeamInfo(matchDetails.homeTeam.name, int.parse(matchDetails.homeTeam.id)),
                        _buildVersusText(matchDetails.statusShort ,matchDetails.homeScore.total, matchDetails.awayScore.total),
                        _buildTeamInfo(matchDetails.awayTeam.name, int.parse(matchDetails.awayTeam.id)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Display match date and button to view details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(matchDetails.date))}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to match details page
                            Get.to(() => MatchDetailsPage(headToHeadDetails: matchDetails));
                          },
                          child: const Text('Match Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(String teamName, int logoId) {
    List<String> parts = teamName.split(' ');
    String lastPart = parts.isNotEmpty ? parts.last : teamName;

    return Column(
      children: [
        Image.asset(
          'assets/team_logo/$logoId.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(lastPart, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildVersusText(String statusShort, int? team1Score, int? team2Score) {
  if (statusShort == 'NS') {
    return Text(
      'vs',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  } else {
    // Check if team1Score and team2Score are not null before rendering scores
    if (team1Score != null && team2Score != null) {
      return Text(
        '$team1Score - $team2Score',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    } else {
      // Handle null scores
      return Text(
        '0 - 0', // Or any default value you prefer
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    }
  }
}


  double cardWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9;
  }
}
