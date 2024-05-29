import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/features/controllers/headTohead_controller.dart';

class HeadToHeadPage extends StatelessWidget {
  final String homeTeamId;
  final String awayTeamId;

  HeadToHeadPage({
    super.key,
    required this.homeTeamId,
    required this.awayTeamId,
  });

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
            if (controller.headToHeadMatches.isEmpty) {
              return const Text('No head-to-head matches found.');
            } else {
              return ListView.builder(
                itemCount: controller.headToHeadMatches.length,
                itemBuilder: (context, index) {
                  final match = controller.headToHeadMatches[index];
                  return ListTile(
                    leading: Image.asset('assets/team_logo/${match.homeTeam.id}', width: 50, height: 50),
                    title: Text('${match.homeTeam.name} vs ${match.awayTeam.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${match.date.toLocal()}'),
                        Text('Time: ${match.time}'),
                        Text('Status: ${match.status.long} (${match.status.short})'),
                        Text('Score: ${match.homeTeam.name} ${match.homeScore.total} - ${match.awayScore.total} ${match.awayTeam.name}'),
                      ],
                    ),
                    onTap: () {
                      // Handle tapping on a match item
                      // You can navigate to a detailed view of the match if needed
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
