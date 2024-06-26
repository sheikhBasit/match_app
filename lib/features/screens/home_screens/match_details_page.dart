import 'dart:async';

import 'package:flutter/material.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/models/h2h_model.dart'; // Ensure this import for HeadToHeadMatch
import 'package:intl/intl.dart';

import '../ads/interstitial_ad.dart';

class MatchDetailsPage extends StatefulWidget {
  final Game? matchDetails;
  final HeadToHeadMatch? headToHeadDetails;

  const MatchDetailsPage({
    Key? key,
    this.matchDetails,
    this.headToHeadDetails,
  }) : super(key: key);

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _adTimer;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load the interstitial ad when the page is initialized
    InterstitialAdManager.loadAd();

    // Set up a timer to show the ad after 10 seconds
    _adTimer = Timer(const Duration(seconds: 10), () {
      InterstitialAdManager.showAd();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

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
        title: const Text('Match Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: cardBackgroundColor(context),
              elevation: 5,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.matchDetails != null
                          ? widget.matchDetails!.leagueName
                          : widget.headToHeadDetails!.leagueName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTeamInfo(
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeTeam.name
                              : widget.headToHeadDetails!.homeTeam.name,
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeTeam.id.toString()
                              : widget.headToHeadDetails!.homeTeam.id.toString(),
                        ),
                        _buildVersusText(
                          widget.matchDetails
                          ),
                        _buildTeamInfo(
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayTeam.name
                              : widget.headToHeadDetails!.awayTeam.name,
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayTeam.id.toString()
                              : widget.headToHeadDetails!.awayTeam.id.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        widget.matchDetails != null
                            ? 'Match Time: ${DateFormat('hh:mm a').format(widget.matchDetails!.date)}'
                            : 'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.headToHeadDetails!.date))}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      Tab(
                        text: widget.matchDetails != null
                            ? widget.matchDetails!.homeTeam.name
                            : widget.headToHeadDetails!.homeTeam.name,
                      ),
                      Tab(
                        text: widget.matchDetails != null
                            ? widget.matchDetails!.awayTeam.name
                            : widget.headToHeadDetails!.awayTeam.name,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 300, // Adjust the height as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTeamInnings(
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeTeam.name
                              : widget.headToHeadDetails!.homeTeam.name,
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeScore.hits.toString()
                              : widget.headToHeadDetails!.homeScore.hits
                                  .toString(),
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeScore.errors.toString()
                              : widget.headToHeadDetails!.homeScore.errors
                                  .toString(),
                          widget.matchDetails != null
                              ? widget.matchDetails!.homeScore.innings
                              : widget.headToHeadDetails!.homeScore.innings,
                        ),
                        _buildTeamInnings(
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayTeam.name
                              : widget.headToHeadDetails!.awayTeam.name,
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayScore.hits.toString()
                              : widget.headToHeadDetails!.awayScore.hits
                                  .toString(),
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayScore.errors.toString()
                              : widget.headToHeadDetails!.awayScore.errors
                                  .toString(),
                          widget.matchDetails != null
                              ? widget.matchDetails!.awayScore.innings
                              : widget.headToHeadDetails!.awayScore.innings,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(String teamName, String logoId) {
    List<String> parts = teamName.split(' ');
    String lastPart = parts.isNotEmpty ? parts.last : teamName;

    return GestureDetector(
      onTap: () {
        // Navigate to team details page
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildVersusText(Game? matchDetails) {
    String inning =
          matchDetails!.status.long.replaceAll(RegExp(r'[^0-9]'), '');

      return Column(
        children: [
          Text(
            '${matchDetails.homeScore.total ?? 0} - ${matchDetails.awayScore.total ?? 0}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${matchDetails.status.long}',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: secondaryColor),
          ),
          if (inning.isNotEmpty &&
              matchDetails.homeScore.innings != null &&
              matchDetails.awayScore.innings != null &&
              matchDetails.homeScore.innings!.containsKey(inning) &&
              matchDetails.awayScore.innings!.containsKey(inning))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${matchDetails.homeScore.innings![inning] ?? '-'} - ${matchDetails.awayScore.innings![inning] ?? '-'}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor),
                    ),
                  ],
                ),
              ],
            ),
        ],
      );
  }


  Widget _buildTeamInnings(String teamName, String hits, String errors,
      Map<String, dynamic>? innings) {
    if (innings == null || innings.isEmpty) {
      return Text('$teamName Innings: No data available');
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16,left: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hits: $hits',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Errors: $errors',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                  title: Text(
                      inningKey == 'extra' ? 'Extra ' : 'Inning $inningNumber'),
                  subtitle: Text('Runs: $runs'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
