import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/match_circles.dart';
import 'package:match_app/features/controllers/stats_controller.dart';
import 'package:match_app/features/models/team_standing.dart';

class StatsPage extends StatelessWidget {
  final TeamStanding teamStanding;
  final StatsController _statsController = Get.put(StatsController());

  StatsPage({required this.teamStanding});

  Future<TeamStanding?> _fetchTeamStats() async {
    await _statsController.fetchTeamStatsById(teamStanding.teamId.toString());
    return _statsController.teamStats.value;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeamStanding?>(
      future: _fetchTeamStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final teamStats = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Team Stats',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
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
      teamStanding.teamLogo,
      teamStanding.teamName,
      [
        'Position: ${teamStanding.position}',
        'Group: ${teamStanding.groupName}',
      ],
    );
  }

  Widget _buildLeagueInfoCard(TeamStanding teamStanding) {
    return _buildInfoCard(
      teamStanding.leagueLogo,
      teamStanding.leagueName,
      [
        'Season: ${teamStanding.leagueSeason}',
        'Stage: ${teamStanding.stage}',
      ],
    );
  }

  Widget _buildInfoCard(String logoUrl, String title, List<String> details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(logoUrl, width: 50, height: 50),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...details.map((detail) => Text(detail)).toList(),
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
