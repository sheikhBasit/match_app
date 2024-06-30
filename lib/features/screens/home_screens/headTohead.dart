import 'dart:async'; // Import the dart:async package for Timer

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:match_app/common_widgets/shimmer_effect.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/headTohead_controller.dart';
import 'package:match_app/features/models/h2h_model.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';
import 'package:shimmer/shimmer.dart';
import '../ads/interstitial_ad.dart'; // Import your InterstitialAdManager

class HeadToHeadPage extends StatefulWidget {
  final String homeTeamId;
  final String awayTeamId;

  const HeadToHeadPage({
    Key? key,
    required this.homeTeamId,
    required this.awayTeamId,
  }) : super(key: key);

  @override
  _HeadToHeadPageState createState() => _HeadToHeadPageState();
}

class _HeadToHeadPageState extends State<HeadToHeadPage> {
  final HeadToHeadController headToHeadController = Get.find<HeadToHeadController>();
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();

    // Load the interstitial ad when the page is initialized
    InterstitialAdManager.loadAd();

    // Set up a timer to show the ad after 10 seconds
    _adTimer = Timer(const Duration(seconds: 10), () {
      InterstitialAdManager.showAd();
    });

    // Fetch head-to-head matches when the view initializes
    headToHeadController.fetchHeadToHeadMatches(widget.homeTeamId, widget.awayTeamId);
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _adTimer?.cancel();

    // Ensure any active ads are disposed of
    InterstitialAdManager.disposeAd();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encounters'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<HeadToHeadController>(
            init: headToHeadController,
            builder: (controller) {
              if (controller.isLoading.value) {
                // Show circular loading indicator while data is being fetched
                return _buildShimmerListView(context);
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
              color: cardBackgroundColor(context),
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
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
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
                          style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to match details page
                          Get.to(() => MatchDetailsPage(headToHeadDetails: matchDetails));
                        },
                        child: const Text('Match Details'),
                      ),
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
        Text(lastPart, style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
        ),
      ],
    );
  }

  Widget _buildVersusText(String statusShort, int? team1Score, int? team2Score) {
    if (statusShort == 'NS') {
      return const Text(
        'vs',
        style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
      );
    } else {
      // Check if team1Score and team2Score are not null before rendering scores
      if (team1Score != null && team2Score != null) {
        return Text(
          '$team1Score - $team2Score',
          style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
        );
      } else {
        // Handle null scores
        return Text(
          '0 - 0', // Or any default value you prefer
          style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
        );
      }
    }
  }

  double cardWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9;
  }
  Widget _buildShimmerListView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[600]!,
        highlightColor: Colors.grey[500]!,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return const ShimmerEffect();
          },
        ),
      ),
    );
  }

}
