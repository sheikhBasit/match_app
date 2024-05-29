import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:match_app/features/controllers/headTohead_controller.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';

class HeadToHeadPage extends StatelessWidget {
  final String homeTeamId;
  final String awayTeamId;

  HeadToHeadPage({
    super.key,
    required this.homeTeamId,
    required this.awayTeamId,
  });

  final HeadToHeadController headToHeadController =
      Get.put(HeadToHeadController());

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
            if (controller.headToHeadMatches.isEmpty) {
              return const Text('No head-to-head matches found.');
            } else {
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

  Widget _buildGameItem(Game matchDetails, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => MatchDetailsPage(matchDetails: matchDetails));
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          matchDetails.leagueName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTeamInfo(matchDetails.homeTeam.name,
                                matchDetails.homeTeam.id),
                            _buildVersusText(matchDetails.homeScore.total ?? 0,
                                matchDetails.awayScore.total ?? 0),
                            _buildTeamInfo(matchDetails.awayTeam.name,
                                matchDetails.awayTeam.id),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(matchDetails.date)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => MatchDetailsPage(
                                    matchDetails: matchDetails));
                              },
                              child: const Text('Match Details'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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

  Widget _buildVersusText(int team1Score, int team2Score) {
    return Text(
      '$team1Score - $team2Score',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  double cardWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9;
  }
}
