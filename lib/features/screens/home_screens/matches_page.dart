import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/shimmer_effect.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/past_matches_controller.dart';
import 'package:match_app/features/controllers/upcoming_matches_controller.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/screens/home_screens/headTohead.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> with SingleTickerProviderStateMixin {
  final PastMatchesController pastMatchesController = Get.find<PastMatchesController>();
  final UpcomingMatchesController upcomingMatchesController = Get.find<UpcomingMatchesController>();

  late TabController _tabController;
  late Timer? _timer; // Make the Timer nullable

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    _fetchData(); // Initial fetch

    // Periodic silent refresh every 5 minutes
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel(); // Cancel the timer if it's not null
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _fetchData();
    }
  }

  void _fetchData() {
    if (_tabController.index == 0) {
      upcomingMatchesController.fetchUpcomingMatches(showShimmer: true);
    } else {
      pastMatchesController.fetchPastMatches(showShimmer: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Upcoming Matches"),
                    Tab(text: "Past Matches"),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUpcomingMatches(context),
                      _buildPastMatches(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMatches(BuildContext context) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          await upcomingMatchesController.fetchUpcomingMatches(showShimmer: true);
        },
        child: upcomingMatchesController.isLoading.value
            ? _buildShimmerListView(context)
            : ListView.builder(
                itemCount: upcomingMatchesController.upcomingMatches.length,
                itemBuilder: (context, index) {
                  final game = upcomingMatchesController.upcomingMatches[index];
                  return _buildGameItem(game, 'Upcoming');
                },
              ),
      );
    });
  }

  Widget _buildPastMatches(BuildContext context) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          await pastMatchesController.fetchPastMatches(showShimmer: true);
        },
        child: pastMatchesController.isLoading.value
            ? _buildShimmerListView(context)
            : ListView.builder(
                itemCount: pastMatchesController.pastMatches.length,
                itemBuilder: (context, index) {
                  final game = pastMatchesController.pastMatches[index];
                  return _buildGameItem(game, 'Past');
                },
              ),
      );
    });
  }

  Widget _buildGameItem(Game matchDetails, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (status == 'Upcoming') {
            Get.to(() => HeadToHeadPage(
                  homeTeamId: matchDetails.homeTeam.id.toString(),
                  awayTeamId: matchDetails.awayTeam.id.toString(),
                ));
          } else if (status == 'Past') {
            Get.to(() => MatchDetailsPage(matchDetails: matchDetails));
          }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          matchDetails.leagueName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (status == 'Upcoming')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTeamInfo(
                                  matchDetails.homeTeam.name,
                                  matchDetails.homeTeam.id),
                              const Text(
                                'vs',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                ),
                              ),
                              _buildTeamInfo(
                                  matchDetails.awayTeam.name,
                                  matchDetails.awayTeam.id),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(matchDetails.date)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: secondaryColor,
                                ),
                              ),
                              Text(
                                'Time: ${matchDetails.time}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (status == 'Past')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildTeamInfo(
                                  matchDetails.homeTeam.name,
                                  matchDetails.homeTeam.id),
                              _buildVersusText(
                                  matchDetails.homeScore.total ?? 0,
                                  matchDetails.awayScore.total ?? 0),
                              _buildTeamInfo(
                                  matchDetails.awayTeam.name,
                                  matchDetails.awayTeam.id),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
        Text(
          lastPart,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVersusText(int team1Score, int team2Score) {
    return Text(
      '$team1Score - $team2Score',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: secondaryColor,
      ),
    );
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
