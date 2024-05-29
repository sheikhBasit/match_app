import 'package:flutter/material.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:intl/intl.dart';

class MatchDetailsPage extends StatefulWidget {
  final Game matchDetails;

  const MatchDetailsPage({super.key, required this.matchDetails});

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tournament Name',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTeamInfo(widget.matchDetails.homeTeam.name,widget.matchDetails.homeTeam.logo),
                        _buildVersusText(widget.matchDetails.homeScore.total, widget.matchDetails.awayScore.total),
                        _buildTeamInfo(widget.matchDetails.awayTeam.name,widget.matchDetails.awayTeam.logo),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: widget.matchDetails.status.long == 'Not Started'
                          ? Text(
                              'Match Time: ${DateFormat('hh:mm a').format(widget.matchDetails.date)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : widget.matchDetails.status.long == 'Finished'
                              ? Text('Winner: ${widget.matchDetails.homeScore.total! > widget.matchDetails.awayScore.total! ? widget.matchDetails.homeTeam.name : widget.matchDetails.awayTeam.name}')
                              : Text('Status: ${widget.matchDetails.status.long}'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: widget.matchDetails.homeTeam.name),
                      Tab(text: widget.matchDetails.awayTeam.name),
                    ],
                  ),
                  SizedBox(
                    height: 300, // Adjust the height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTeamInnings(
                          widget.matchDetails.homeTeam.name,
                          widget.matchDetails.homeScore.hits.toString(),
                          widget.matchDetails.homeScore.errors.toString(),
                          widget.matchDetails.homeScore.innings,
                        ),
                        _buildTeamInnings(
                          widget.matchDetails.awayTeam.name,
                          widget.matchDetails.awayScore.hits.toString(),
                          widget.matchDetails.awayScore.errors.toString(),
                          widget.matchDetails.awayScore.innings,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(String teamName, String logoUrl) {
    // Split the team name by space and get the last part
    List<String> parts = teamName.split(' ');
    String lastPart = parts.isNotEmpty ? parts.last : teamName;

    return Column(
      children: [
        Image.network(
          logoUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(lastPart, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildVersusText(int? team1Score, int? team2Score) {
    return Text(
      '$team1Score - $team2Score',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTeamInnings(String teamName, String hits, String errors, Map<String, dynamic>? innings) {
    if (innings == null || innings.isEmpty) {
      return Text('$teamName Innings: No data available');
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hits: $hits', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text('Errors: $errors', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: innings.length,
            itemBuilder: (context, index) {
              String inningNumber = (index + 1).toString();
              String inningKey = inningNumber;
              if (inningNumber == '10') {
                inningKey = 'extra';
              }
              int runs = innings[inningKey] ?? 0;
              return ListTile(
                title: Text(inningKey == 'extra' ? 'Extra ' : 'Inning $inningNumber'),
                subtitle: Text('Runs: $runs'),
              );
            },
          ),
        ],
      ),
    );
  }
}
