// import 'package:flutter/material.dart';
// import 'package:match_app/features/models/team_standing.dart';
// import 'package:match_app/features/screens/home_screens/headTohead.dart';
// import 'package:match_app/features/screens/home_screens/stats_page.dart';

// class TeamDetailsPage extends StatelessWidget {
//   final TeamStanding teamStanding;

//   TeamDetailsPage({required this.teamStanding});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs (squad and stats)
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Team Details'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Squad'),
//               Tab(text: 'Stats'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             SquadPage(teamStanding: teamStanding),
//             StatsPage(teamStanding: teamStanding),
//           ],
//         ),
//       ),
//     );
//   }
// }
