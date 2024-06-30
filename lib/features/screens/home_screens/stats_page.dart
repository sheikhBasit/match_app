import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/match_circles.dart';
import 'package:match_app/common_widgets/user_subscription.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/standings_controller.dart';
import 'package:match_app/features/models/team_standing.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart';
import 'package:match_app/features/screens/ads/interstitial_ad.dart';

class StatsPage extends StatefulWidget {
  final TeamStanding teamStanding;
  StatsPage({Key? key, required this.teamStanding}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Stats'),
      ),
      body: SafeArea(
        child: GetBuilder<StandingsController>(
          builder: (standingsController) {
            if (standingsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (standingsController.standings.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final teamStats = standingsController.standings.firstWhere(
              (standing) => standing.teamId == widget.teamStanding.teamId,
              orElse: () => TeamStanding(
                leagueId: widget.teamStanding.leagueId,
                teamId: widget.teamStanding.teamId,
                teamName: widget.teamStanding.teamName,
                teamLogo: widget.teamStanding.teamLogo,
                leagueName: widget.teamStanding.leagueName,
                leagueLogo: widget.teamStanding.leagueLogo,
                leagueSeason: widget.teamStanding.leagueSeason,
                stage: widget.teamStanding.stage,
                groupName: widget.teamStanding.groupName,
                position: 0,
                gamesPlayed: 0,
                wins: 0,
                winPercentage: '0%',
                losses: 0,
                losePercentage: '0%',
                pointsFor: 0,
                pointsAgainst: 0,
                form: '-----',
              ), // Return empty TeamStanding if not found
            );

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!UserSubscription.isSubscribed) const Center(child: BannerAdWidget()),
                    const SizedBox(height: 20),
                    _buildTeamInfoCard(teamStats),
                    const SizedBox(height: 20),
                    _buildLeagueInfoCard(teamStats),
                    const SizedBox(height: 20),
                    _buildPerformanceStatsCard(teamStats),
                    const SizedBox(height: 20),
                    _buildPointsStatsCard(teamStats),
                    const SizedBox(height: 20),
                    _buildFormCard(teamStats),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeamInfoCard(TeamStanding teamStanding) {
    return _buildInfoCard(
      teamStanding.teamId,
      teamStanding.teamName,
      [
        'Position: ${teamStanding.position}',
        'Group: ${teamStanding.groupName}',
      ],
    );
  }

  Widget _buildLeagueInfoCard(TeamStanding teamStanding) {
    return _buildInfoCard(
      teamStanding.leagueId + 99,
      teamStanding.leagueName,
      [
        'Season: ${teamStanding.leagueSeason}',
        'Stage: ${teamStanding.stage}',
      ],
    );
  }

  Widget _buildInfoCard(int teamId, String title, List<String> details) {
    return Card(
      color: cardBackgroundColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset('assets/team_logo/$teamId.png', width: 50, height: 50),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                ...details.map((detail) => Text(detail)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStatsCard(TeamStanding teamStanding) {
    return _buildStatsCard(
      'Performance Stats',
      [
        _buildStatRow('Games Played', teamStanding.gamesPlayed.toString()),
        _buildStatRow('Wins', teamStanding.wins.toString()),
        _buildStatRow('Win Percentage', teamStanding.winPercentage),
        _buildStatRow('Losses', teamStanding.losses.toString()),
        _buildStatRow('Lose Percentage', teamStanding.losePercentage),
      ],
    );
  }

  Widget _buildPointsStatsCard(TeamStanding teamStanding) {
    return _buildStatsCard(
      'Points Stats',
      [
        _buildStatRow('Points For', teamStanding.pointsFor.toString()),
        _buildStatRow('Points Against', teamStanding.pointsAgainst.toString()),
      ],
    );
  }

  Widget _buildFormCard(TeamStanding teamStanding) {
    return Card(
      color: cardBackgroundColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: teamStanding.form.split('').map((result) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: MatchResultCircle(result: result),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, List<Widget> rows) {
    return Card(
      color: cardBackgroundColor(context),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
