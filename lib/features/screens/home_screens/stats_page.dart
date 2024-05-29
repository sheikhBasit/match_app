import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/match_circles.dart';
import 'package:match_app/features/controllers/standings_controller.dart';
import 'package:match_app/features/controllers/stats_controller.dart';
import 'package:match_app/features/models/team_standing.dart';
import 'package:match_app/features/screens/ads/banner_ad.dart';

class StatsPage extends StatelessWidget {
  final TeamStanding teamStanding;
  StatsPage({Key? key, required this.teamStanding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StandingsController>(
      builder: (standingsController) {
        if (standingsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (standingsController.standings.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final teamStats = standingsController.standings.firstWhere(
          (standing) => standing.teamId == teamStanding.teamId,
          orElse: () => TeamStanding(
            leagueId: teamStanding.leagueId,
            teamId: teamStanding.teamId,
            teamName: teamStanding.teamName,
            teamLogo: teamStanding.teamLogo,
            leagueName: teamStanding.leagueName,
            leagueLogo: teamStanding.leagueLogo,
            leagueSeason: teamStanding.leagueSeason,
            stage: teamStanding.stage,
            groupName: teamStanding.groupName,
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
                const BannerAdWidget(),
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
      teamStanding.leagueId+99,
      teamStanding.leagueName,
      [
        'Season: ${teamStanding.leagueSeason}',
        'Stage: ${teamStanding.stage}',
      ],
    );
  }

  Widget _buildInfoCard(int teamId, String title, List<String> details) {
    return Card(
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
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
