//   // import 'package:flutter/material.dart';
//   // import 'package:get/get.dart';
//   // import 'package:match_app/common_widgets/match_circles.dart';
//   // import 'package:match_app/features/controllers/stats_controller.dart';
//   // import 'package:match_app/features/models/team_standing.dart';

//   // class StatsPage extends StatelessWidget {
//   //   final TeamStanding teamStanding;
//   //   final StatsController _firestoreService = Get.put( StatsController());

//   //   StatsPage({required this.teamStanding});

//   //   Future<TeamStanding?> _fetchTeamStats() async {
//   //     final data = await _firestoreService.getTeamStats(teamStanding.teamId.toString());
//   //     if (data != null) {
//   //       return TeamStanding.fromJson(data);
//   //     }
//   //     return null;
//   //   }

//   //   @override
//   //   Widget build(BuildContext context) {
//   //     return FutureBuilder<TeamStanding?>(
//   //       future: _fetchTeamStats(),
//   //       builder: (context, snapshot) {
//   //         if (snapshot.connectionState == ConnectionState.waiting) {
//   //           return Center(child: CircularProgressIndicator());
//   //         } else if (snapshot.hasError) {
//   //           return Center(child: Text('Error: ${snapshot.error}'));
//   //         } else if (!snapshot.hasData || snapshot.data == null) {
//   //           return Center(child: Text('No data available'));
//   //         }

//   //         final teamStanding = snapshot.data!;

//   //         return SingleChildScrollView(
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(16.0),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 const Text(
//   //                   'Team Stats',
//   //                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//   //                 ),
//   //                 const SizedBox(height: 20),
//   //                 _buildTeamInfoCard(teamStanding),
//   //                 const SizedBox(height: 20),
//   //                 _buildLeagueInfoCard(teamStanding),
//   //                 const SizedBox(height: 20),
//   //                 _buildPerformanceStatsCard(teamStanding),
//   //                 const SizedBox(height: 20),
//   //                 _buildPointsStatsCard(teamStanding),
//   //                 const SizedBox(height: 20),
//   //                 _buildFormCard(teamStanding),
//   //               ],
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   }

//   //   Widget _buildTeamInfoCard(TeamStanding teamStanding) {
//   //     return Card(
//   //       elevation: 4,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Row(
//   //           children: [
//   //             Image.network(
//   //               teamStanding.teamLogo,
//   //               width: 50,
//   //               height: 50,
//   //             ),
//   //             const SizedBox(width: 16),
//   //             Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(
//   //                   teamStanding.teamName,
//   //                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //                 ),
//   //                 Text('Position: ${teamStanding.position}'),
//   //                 Text('Group: ${teamStanding.groupName}'),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Widget _buildLeagueInfoCard(TeamStanding teamStanding) {
//   //     return Card(
//   //       elevation: 4,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Row(
//   //           children: [
//   //             Image.network(
//   //               teamStanding.leagueLogo,
//   //               width: 50,
//   //               height: 50,
//   //             ),
//   //             const SizedBox(width: 16),
//   //             Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(
//   //                   teamStanding.leagueName,
//   //                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //                 ),
//   //                 Text('Season: ${teamStanding.leagueSeason}'),
//   //                 Text('Stage: ${teamStanding.stage}'),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Widget _buildPerformanceStatsCard(TeamStanding teamStanding) {
//   //     return Card(
//   //       elevation: 4,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             const Text(
//   //               'Performance Stats',
//   //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //             ),
//   //             const SizedBox(height: 10),
//   //             _buildStatRow('Games Played', teamStanding.gamesPlayed.toString()),
//   //             _buildStatRow('Wins', teamStanding.wins.toString()),
//   //             _buildStatRow('Win Percentage', teamStanding.winPercentage),
//   //             _buildStatRow('Losses', teamStanding.losses.toString()),
//   //             _buildStatRow('Lose Percentage', teamStanding.losePercentage),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Widget _buildPointsStatsCard(TeamStanding teamStanding) {
//   //     return Card(
//   //       elevation: 4,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             const Text(
//   //               'Points Stats',
//   //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //             ),
//   //             const SizedBox(height: 10),
//   //             _buildStatRow('Points For', teamStanding.pointsFor.toString()),
//   //             _buildStatRow('Points Against', teamStanding.pointsAgainst.toString()),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Widget _buildFormCard(TeamStanding teamStanding) {
//   //     return Card(
//   //       elevation: 4,
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16.0),
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             const Text(
//   //               'Recent Form',
//   //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//   //             ),
//   //             const SizedBox(height: 10),
//   //             Row(
//   //               children: teamStanding.form.split('').map((result) {
//   //                 return Padding(
                  
//   //                   padding: const EdgeInsets.symmetric(horizontal: 2.0),
//   //                   child: MatchResultCircle(result: result),
//   //                 );
//   //               }).toList(),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Widget _buildStatRow(String title, String value) {
//   //     return Padding(
//   //       padding: const EdgeInsets.symmetric(vertical: 4.0),
//   //       child: Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         children: [
//   //           Text(title, style: const TextStyle(fontSize: 16)),
//   //           Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//   //         ],
//   //       ),
//   //     );
//   //   }
//   // }




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:match_app/common_widgets/shimmer_effect.dart';
// import 'package:match_app/constants/constants.dart';
// import 'package:match_app/features/controllers/live_matches_controller.dart';
// import 'package:match_app/features/models/game_model.dart'; // Import Game model
// import 'package:match_app/features/screens/home_screens/headTohead.dart';
// import 'package:match_app/features/screens/home_screens/match_details_page.dart';

// import 'package:shimmer/shimmer.dart';
// import 'package:intl/intl.dart';
// import 'dart:async';

// class LiveMatches extends StatefulWidget {
//   const LiveMatches({super.key});

//   @override
//   _LiveMatchesState createState() => _LiveMatchesState();
// }

// class _LiveMatchesState extends State<LiveMatches> {
//   final MatchController matchController = Get.put(MatchController());
//   bool _showShimmer = true;

//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 1), () {
//       setState(() {
//         _showShimmer = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (matchController.isLoading.value) {
//         return _showShimmer ? _buildShimmerListView(context) : Container();
//       } else {
//         return RefreshIndicator(
//           onRefresh: matchController.fetchTodayMatches,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 matchController.todayMatches.isNotEmpty
//                     ? _buildMatchList(context, matchController.todayMatches)
//                     : const Center(
//                         child: Text(
//                           'No matches available.',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         );
//       }
//     });
//   }

//   Widget _buildShimmerListView(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.8,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[600]!,
//         highlightColor: Colors.grey[500]!,
//         child: ListView.builder(
//           itemCount: 3,
//           itemBuilder: (context, index) {
//             return const ShimmerEffect();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMatchList(BuildContext context, List<Game> matches) {
//     matches.sort((a, b) {
//       if (_isMatchLive(a) && !_isMatchLive(b)) {
//         return -1;
//       } else if (!_isMatchLive(a) && _isMatchLive(b)) {
//         return 1;
//       } else {
//         return 0;
//       }
//     });

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: matches.length,
//       itemBuilder: (context, index) {
//         final match = matches[index];
//         final bool isLive = _isMatchLive(match);

//         return GestureDetector(
//           onTap: () {
//             if (match.status.short == 'NS') {
//               Get.to(() => HeadToHeadPage(
//                     homeTeamId: match.homeTeam.id.toString(),
//                     awayTeamId: match.awayTeam.id.toString(),
//                   ));
//             } else {
//               Get.to(() => MatchDetailsPage(matchDetails: match));
//             }
//           },
//           child: Card(
//             color: isLive ? Colors.red.withOpacity(0.7) : backgroundColor,
//             elevation: isLive ? 8 : 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Text(
//                     _getMatchTitle(match),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildTeamInfo(match.homeTeam.name, match.homeTeam.id),
//                       const Text(
//                         'vs',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       _buildTeamInfo(match.awayTeam.name, match.awayTeam.id),
//                     ],
//                   ),
//                   if (_isMatchInProgress(match)) const SizedBox(height: 8),
//                   Text(
//                     _getMatchStatus(match),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   bool _isMatchInProgress(Game match) {
//     return match.status.short.startsWith('IN') || match.status.short == 'NS';
//   }

//   bool _isMatchLive(Game match) {
//     final now = DateTime.now();
//     return match.date.isBefore(now);
//   }

//   String _getMatchTitle(Game match) {
//     if (_isMatchInProgress(match)) {
//       return 'Live Now!';
//     } else if (match.status.short == 'POST') {
//       return 'Postponed';
//     } else if (match.status.short == 'CANC') {
//       return 'Cancelled';
//     } else if (match.status.short == 'INTR') {
//       return 'Interrupted';
//     } else if (match.status.short == 'ABD') {
//       return 'Abandoned';
//     } else {
//       return DateFormat('yyyy-MM-dd – HH:mm').format(match.date);
//     }
//   }

//   String _getMatchStatus(Game match) {
//     if (match.status.short.startsWith('IN')) {
//       final inningsNumber = match.status.short.substring(2);
//       return 'Total & Innings: $inningsNumber';
//     } else if (match.status.short == 'FT') {
//       return 'Game Time: ${DateFormat('HH:mm').format(match.date)}';
//     } else {
//       return 'VS';
//     }
//   }

//   Widget _buildTeamInfo(String teamName, int logoId) {
//     List<String> parts = teamName.split(' ');
//     String lastPart = parts.isNotEmpty ? parts.last : teamName;

//     return Column(
//       children: [
//         Image.asset(
//           'assets/team_logo/$logoId.png',
//           width: 50,
//           height: 50,
//           fit: BoxFit.cover,
//         ),
//         const SizedBox(height: 8),
//         Text(lastPart, style: const TextStyle(fontSize: 16)),
//       ],
//     );
//   }
// }
