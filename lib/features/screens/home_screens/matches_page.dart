import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/shimmer_effect.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/upcoming_matches_controller.dart'; // Import UpcomingMatchesController
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';
import 'package:match_app/features/screens/home_screens/stream_page.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingMatches extends StatefulWidget {
  const UpcomingMatches({Key? key});

  @override
  _UpcomingMatchesState createState() => _UpcomingMatchesState();
}

class _UpcomingMatchesState extends State<UpcomingMatches> with SingleTickerProviderStateMixin {
  final UpcomingMatchesController matchController = Get.put(UpcomingMatchesController()); // Use UpcomingMatchesController
  late ScrollController _scrollController;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // Initialize Animation
    _animation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Dispose AnimationController
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (matchController.isLoading.value) {
        // Loading state
        return SizedBox(
          height: cardHeight(context),
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey[600]!,
            child: Column(
              children: List.generate(
                2,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: ShimmerEffect(),
                ),
              ),
            ),
          ),
        );
      } else {
        // Data loaded
        if (matchController.upcomingMatches.isNotEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMatchList(matchController.upcomingMatches),
              ],
            ),
          );
        } else {
          // No matches found
          return SizedBox(
            height: cardHeight(context),
            child: const Center(
              child: const Text('No upcoming matches found'),
            ),
          );
        }
      }
    });
  }

  Widget _buildMatchList(List<Game> matchList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(matchList.length, (index) {
        return _buildMatchCard(matchList[index]);
      }),
    );
  }

  Widget _buildMatchCard(Game matchDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.to(MatchDetailsPage(matchDetails: matchDetails));
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
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Animated bar for the "Live" text
                        Column(
                          children: [
                            const Text('Live', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Container(
                                  width: _animation.value,
                                  height: 4,
                                  color: Colors.red, // Customize color as needed
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTeamInfo(matchDetails.homeTeam.name),
                        _buildVersusText(matchDetails.homeScore.total!, matchDetails.awayScore.total!),
                        _buildTeamInfo(matchDetails.awayTeam.name),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(MatchDetailsPage(matchDetails: matchDetails));
                          },
                          child: const Text('Match Details'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(const StreamingPage());
                          },
                          child: const Text('Live Stream'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(String teamName) {
    return Column(
      children: [
        const Icon(Icons.sports_basketball, size: 50, color: Colors.blue),
        const SizedBox(height: 8),
        Text(teamName, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildVersusText(int team1Score, int team2Score) {
    return Text(
      '$team1Score - $team2Score',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
