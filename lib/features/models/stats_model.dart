class TeamStats {
  final String countryName;
  final String countryFlag;
  final String leagueName;
  final String leagueLogo;
  final String teamName;
  final String teamLogo;
  final int gamesPlayedHome;
  final int gamesPlayedAway;
  final int gamesPlayedAll;
  final int winsHome;
  final String winPercentageHome;
  final int winsAway;
  final String winPercentageAway;
  final int winsAll;
  final String winPercentageAll;
  final int lossesHome;
  final String losePercentageHome;
  final int lossesAway;
  final String losePercentageAway;
  final int lossesAll;
  final String losePercentageAll;
  final int pointsForHome;
  final int pointsForAway;
  final int pointsForAll;
  final String pointsAverageHome;
  final String pointsAverageAway;
  final String pointsAverageAll;
  final int pointsAgainstHome;
  final int pointsAgainstAway;
  final int pointsAgainstAll;
  final String pointsAgainstAverageHome;
  final String pointsAgainstAverageAway;
  final String pointsAgainstAverageAll;

  TeamStats({
    required this.countryName,
    required this.countryFlag,
    required this.leagueName,
    required this.leagueLogo,
    required this.teamName,
    required this.teamLogo,
    required this.gamesPlayedHome,
    required this.gamesPlayedAway,
    required this.gamesPlayedAll,
    required this.winsHome,
    required this.winPercentageHome,
    required this.winsAway,
    required this.winPercentageAway,
    required this.winsAll,
    required this.winPercentageAll,
    required this.lossesHome,
    required this.losePercentageHome,
    required this.lossesAway,
    required this.losePercentageAway,
    required this.lossesAll,
    required this.losePercentageAll,
    required this.pointsForHome,
    required this.pointsForAway,
    required this.pointsForAll,
    required this.pointsAverageHome,
    required this.pointsAverageAway,
    required this.pointsAverageAll,
    required this.pointsAgainstHome,
    required this.pointsAgainstAway,
    required this.pointsAgainstAll,
    required this.pointsAgainstAverageHome,
    required this.pointsAgainstAverageAway,
    required this.pointsAgainstAverageAll,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      countryName: json['country']['name'] ?? '',
      countryFlag: json['country']['flag'] ?? '',
      leagueName: json['league']['name'] ?? '',
      leagueLogo: json['league']['logo'] ?? '',
      teamName: json['team']['name'] ?? '',
      teamLogo: json['team']['logo'] ?? '',
      gamesPlayedHome: json['games']['played']['home'] ?? 0,
      gamesPlayedAway: json['games']['played']['away'] ?? 0,
      gamesPlayedAll: json['games']['played']['all'] ?? 0,
      winsHome: json['games']['wins']['home']['total'] ?? 0,
      winPercentageHome: json['games']['wins']['home']['percentage'] ?? '',
      winsAway: json['games']['wins']['away']['total'] ?? 0,
      winPercentageAway: json['games']['wins']['away']['percentage'] ?? '',
      winsAll: json['games']['wins']['all']['total'] ?? 0,
      winPercentageAll: json['games']['wins']['all']['percentage'] ?? '',
      lossesHome: json['games']['loses']['home']['total'] ?? 0,
      losePercentageHome: json['games']['loses']['home']['percentage'] ?? '',
      lossesAway: json['games']['loses']['away']['total'] ?? 0,
      losePercentageAway: json['games']['loses']['away']['percentage'] ?? '',
      lossesAll: json['games']['loses']['all']['total'] ?? 0,
      losePercentageAll: json['games']['loses']['all']['percentage'] ?? '',
      pointsForHome: json['points']['for']['total']['home'] ?? 0,
      pointsForAway: json['points']['for']['total']['away'] ?? 0,
      pointsForAll: json['points']['for']['total']['all'] ?? 0,
      pointsAverageHome: json['points']['for']['average']['home'] ?? '',
      pointsAverageAway: json['points']['for']['average']['away'] ?? '',
      pointsAverageAll: json['points']['for']['average']['all'] ?? '',
      pointsAgainstHome: json['points']['against']['total']['home'] ?? 0,
      pointsAgainstAway: json['points']['against']['total']['away'] ?? 0,
      pointsAgainstAll: json['points']['against']['total']['all'] ?? 0,
      pointsAgainstAverageHome: json['points']['against']['average']['home'] ?? '',
      pointsAgainstAverageAway: json['points']['against']['average']['away'] ?? '',
      pointsAgainstAverageAll: json['points']['against']['average']['all'] ?? '',
    );
  }
}
