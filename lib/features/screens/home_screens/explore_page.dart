import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:match_app/common_widgets/shimmer_effect.dart';
import 'package:match_app/constants/constants.dart';
import 'package:match_app/constants/notifications/notification_controller.dart';
import 'package:match_app/features/controllers/live_matches_controller.dart';
import 'package:match_app/features/models/game_model.dart';
import 'package:match_app/features/screens/home_screens/headTohead.dart';
import 'package:match_app/features/screens/home_screens/match_details_page.dart';
import 'package:match_app/features/screens/home_screens/stream_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get_storage/get_storage.dart';

class LiveMatches extends StatefulWidget {
  final bool notificationsEnabled;

  const LiveMatches({Key? key, required this.notificationsEnabled}) : super(key: key);

  @override
  _LiveMatchesState createState() => _LiveMatchesState();
}

class _LiveMatchesState extends State<LiveMatches> {
  final MatchController matchController = Get.find<MatchController>();
  final NotificationController notificationController = Get.find<NotificationController>();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    notificationController.initializeNotification();
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
    List<Game> liveMatches = [];
    List<Game> otherMatches = [];

    for (Game match in matchList) {
      if (match.status.long == 'Not Started' || match.status.long == 'Finished') {
        otherMatches.add(match);
      } else {
        liveMatches.add(match);
        // Check if notification already shown for this match
        bool notificationShown = box.read('shownMatches')?.contains(match.id) ?? false;
        if (!notificationShown && widget.notificationsEnabled) {
          notificationController.showNotification(
            "Live Match",
            match.homeTeam.name,
            match.awayTeam.name,
          );
          // Store match ID to prevent showing notification again
          List<int> shownMatches = box.read('shownMatches')?.cast<int>() ?? [];
          shownMatches.add(match.id);
          box.write('shownMatches', shownMatches);
        }
      }
    }

    otherMatches.sort((a, b) {
      if (a.status.long == 'Not Started' && b.status.long == 'Finished') {
        return -1;
      } else if (a.status.long == 'Finished' && b.status.long == 'Not Started') {
        return 1;
      } else {
        return 0;
      }
    });

    List<Widget> children = [];

    if (liveMatches.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              'No live match right now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    children.addAll(liveMatches.map((match) => _buildGameItem(context, match)).toList());
    children.addAll(otherMatches.map((match) => _buildGameItem(context, match)).toList());

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
                            child: ElevatedButton(
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
}
