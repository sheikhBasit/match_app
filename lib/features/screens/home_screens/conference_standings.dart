import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/features/controllers/standings_controller.dart';
import 'package:match_app/features/models/team_standing.dart';
import 'package:match_app/features/screens/home_screens/stats_page.dart';

class ConferenceStandings extends StatefulWidget {
  final String conference;

  ConferenceStandings({required this.conference});

  @override
  _ConferenceStandingsState createState() => _ConferenceStandingsState();
}

class _ConferenceStandingsState extends State<ConferenceStandings> {
  late String selectedGroup;
  late StandingsController standingsController;
  late List<TeamStanding> filteredStandings;

  @override
  void initState() {
    super.initState();
    selectedGroup = 'All'; // Set default selection
    standingsController = Get.find();
    updateFilteredStandings(); // Call to update filtered standings initially
  }

  // Method to update filtered standings based on selected group
  void updateFilteredStandings() {
    filteredStandings = standingsController.standings
        .where((standing) =>
            standing.groupName.startsWith(widget.conference) &&
            (selectedGroup == 'All' || standing.groupName.contains(selectedGroup)))
        .toList();
    // Sort the standings based on the selected group
    if (selectedGroup == 'All') {
      filteredStandings.sort((a, b) => b.winPercentage.compareTo(a.winPercentage));
    } else {
      filteredStandings.sort((a, b) => a.position.compareTo(b.position));
    }
  }

  String getLastPartOfTeamName(String teamName) {
    List<String> parts = teamName.split(' ');
    return parts.isNotEmpty ? parts.last : teamName;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      updateFilteredStandings(); // Ensure the UI updates when standings change
      return SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedGroup,
              onChanged: (value) {
                setState(() {
                  selectedGroup = value!;
                  updateFilteredStandings(); // Update filtered standings when dropdown value changes
                });
              },
              items: <String>['All', 'Central', 'East', 'West'].map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      if (selectedGroup != 'All') // Only show position column if not 'All'
                        const DataColumn(
                          label: Text(
                            'Pos',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      const DataColumn(
                        label: Text(
                          'Team',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'M',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'W',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'L',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'PCT',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      
                    ],
                    rows: filteredStandings.map((standing) {
                      return DataRow(
                        cells: [
                          if (selectedGroup != 'All') // Only show position if not 'All'
                            DataCell(
                              Text(standing.position.toString()),
                            ),
                          DataCell(
                            Row(
                              children: [
                                Image.network(
                                  standing.teamLogo,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 3),
                                GestureDetector(
                                  onTap: () => Get.to(() => StatsPage(teamStanding: standing)),
                                  child: Text(getLastPartOfTeamName(standing.teamName)),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => Get.to(() => StatsPage(teamStanding: standing)),
                              child: Text(standing.gamesPlayed.toString()),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => Get.to(() => StatsPage(teamStanding: standing)),
                              child: Text(standing.wins.toString()),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => Get.to(() => StatsPage(teamStanding: standing)),
                              child: Text(standing.losses.toString()),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => Get.to(() => StatsPage(teamStanding: standing)),
                              child: Text(standing.winPercentage.toString()),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
