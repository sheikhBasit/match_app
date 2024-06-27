import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/common_widgets/shimmer_effect.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/features/controllers/live_matches_controller.dart';
import 'package:match_app/features/models/game_model.dart'; // Import Game model
import 'package:match_app/features/screens/home_screens/headTohead.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';
import 'package:match_app/features/screens/home_screens/stream_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Define the notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LiveMatches extends StatefulWidget {
  @override
  _LiveMatchesState createState() => _LiveMatchesState();
}

class _LiveMatchesState extends State<LiveMatches> {
  final MatchController matchController = Get.find<MatchController>();

  @override
  void initState() {
    super.initState();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (matchController.isLoading.value) {
        return _buildShimmerListView(context);
      } else {
        return RefreshIndicator(
          onRefresh: matchController.fetchTodayMatches,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                matchController.todayMatches.isNotEmpty
                    ? _buildMatchList(context, matchController.todayMatches)
                    : Center(
                        child: Text(
                          'No matches found for today',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildMatchList(BuildContext context, List<Game> matchList) {
    // Separate live matches from other matches
    List<Game> liveMatches = [];
    List<Game> otherMatches = [];

    // Categorize matches
    for (Game match in matchList) {
      if (match.status.long == 'Not Started' ||
          match.status.long == 'Finished') {
        otherMatches.add(match);
      } else {
        liveMatches.add(match);
      }
    }

    // Sort other matches by status
    otherMatches.sort((a, b) {
      if (a.status.long == 'Not Started' && b.status.long == 'Finished') {
        return -1;
      } else if (a.status.long == 'Finished' &&
          b.status.long == 'Not Started') {
        return 1;
      } else {
        return 0;
      }
    });

    // Combine live matches and other matches
    List<Widget> children = [];

    // Add "No live match available" text if no live matches
    if (liveMatches.isEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              'No live match available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    // Add live matches
    children.addAll(
      liveMatches.map((match) => _buildGameItem(context, match)).toList(),
    );

    // Add other matches
    children.addAll(
      otherMatches.map((match) => _buildGameItem(context, match)).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildGameItem(BuildContext context, Game matchDetails) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (matchDetails.status.short == 'NS') {
            // Navigate to head-to-head page
            Get.to(() => HeadToHeadPage(
                  homeTeamId: matchDetails.homeTeam.id.toString(),
                  awayTeamId: matchDetails.awayTeam.id.toString(),
                ));
          } else {
            Get.to(() => MatchDetailsPage(matchDetails: matchDetails));
          }
        },
        child: Center(
          child: SizedBox(
            width: cardWidth(context),
            child: Stack(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              matchDetails.leagueName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTeamInfo(matchDetails.homeTeam.name,
                                matchDetails.homeTeam.id),
                            _buildStatusText(matchDetails),
                            _buildTeamInfo(matchDetails.awayTeam.name,
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
                                  fontSize: 16, color: secondaryColor),
                            ),
                            Text(
                              'Time: ${matchDetails.time}',
                              style: const TextStyle(
                                  fontSize: 16, color: secondaryColor),
                            ),
                          ],
                        ),
                        if (matchDetails.status.long != 'Finished' &&
                            matchDetails.status.long != 'Not Started')
                          Center(
                            child:
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => MatchDetailsPage(
                                      matchDetails: matchDetails));
                                },
                                child: const Text('Match Details'),
                              ),
                            
                          ),
                      ],
                    ),
                  ),
                ),
                if (matchDetails.status.long != 'Finished' &&
                    matchDetails.status.long != 'Not Started')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: selectionColor,
                      child: const Text(
                        'Live',
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(Game matchDetails) {
    if (matchDetails.status.long == 'Finished') {
      return Text(
        '${matchDetails.homeScore.total} - ${matchDetails.awayScore.total}',
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
      );
    } else if (matchDetails.status.long == 'Not Started') {
      return const Text(
        'vs',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
      );
    } else {
      // Extract the inning from the status
      String inning =
          matchDetails.status.long.replaceAll(RegExp(r'[^0-9]'), '');

      return Column(
        children: [
          Text(
      '${matchDetails.homeScore.total ?? 0} - ${matchDetails.awayScore.total ?? 0}',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5, ),
          Text(
            'Inning: ${matchDetails.status.long}',
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
        Text(lastPart,
            style: const TextStyle(fontSize: 16, color: secondaryColor)),
      ],
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

  Future<void> _showLiveMatchNotification(String leagueName,
      String homeTeamName, String awayTeamName) async {
    if (!mounted) {
      return;
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'live_match_notification',
      'Live Match Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Live Match',
      '$leagueName: $homeTeamName vs $awayTeamName is live now!',
      platformChannelSpecifics,
      payload: 'Live Match',
    );
  }

  // Check if the match is live
  bool _isLive(String statusShort) {
    final liveStatuses = ['NS', 'FT', 'POST', 'CANC', 'INTR', 'ABD'];
    return !liveStatuses.contains(statusShort);
  }

  Future<void> _showLiveStreamOptionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Live Stream Channel',
              style: TextStyle(color: primaryColor)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildChannelOption(context, 'Channel 1'),
                _buildChannelOption(context, 'Channel 2'),
                _buildChannelOption(context, 'Channel 3'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChannelOption(BuildContext context, String channelName) {
    return ListTile(
      title: Text(channelName, style: const TextStyle(color: primaryColor)),
      onTap: () {
        // Perform action when channel option is selected
        // For example, navigate to the selected channel page
        // Replace the below navigation logic with your actual implementation
        Navigator.of(context).pop(); // Close the dialog
        // Navigate to the selected channel page
        Get.to(() => StreamingPage(channelName: channelName));
      },
    );
  }
}
