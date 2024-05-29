class TeamStanding {
  final int position;
  final String stage;
  final String groupName;
  final int teamId;
  final String teamName;
  final String teamLogo;
  final int leagueId;
  final String leagueName;
  final String leagueLogo;
  final int leagueSeason;
  final int gamesPlayed;
  final int wins;
  final String winPercentage;
  final int losses;
  final String losePercentage;
  final int pointsFor;
  final int pointsAgainst;
  final String form;

  TeamStanding({
    required this.position,
    required this.stage,
    required this.groupName,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.leagueId,
    required this.leagueName,
    required this.leagueLogo,
    required this.leagueSeason,
    required this.gamesPlayed,
    required this.wins,
    required this.winPercentage,
    required this.losses,
    required this.losePercentage,
    required this.pointsFor,
    required this.pointsAgainst,
    required this.form,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      position: json['position'] ?? 0,
      stage: json['stage'] ?? '',
      groupName: json['group']['name'] ?? '',
      teamId: json['team']['id'] ?? 0,
      teamName: json['team']['name'] ?? '',
      teamLogo: json['team']['logo'] ?? '',
      leagueId: json['league']['id'] ?? 0,
      leagueName: json['league']['name'] ?? '',
      leagueLogo: json['league']['logo'] ?? '',
      leagueSeason: json['league']['season'] ?? 0,
      gamesPlayed: json['games']['played'] ?? 0,
      wins: json['games']['win']['total'] ?? 0,
      winPercentage: (json['games']['win']['percentage'] ?? 0.0).toString(),
      losses: json['games']['lose']['total'] ?? 0,
      losePercentage: (json['games']['lose']['percentage'] ?? 0.0).toString(),
      pointsFor: json['points']['for'] ?? 0,
      pointsAgainst: json['points']['against'] ?? 0,
      form: json['form'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'stage': stage,
      'groupName': groupName,
      'teamId': teamId,
      'teamName': teamName,
      'teamLogo': teamLogo,
      'leagueId': leagueId,
      'leagueName': leagueName,
      'leagueLogo': leagueLogo,
      'leagueSeason': leagueSeason,
      'gamesPlayed': gamesPlayed,
      'wins': wins,
      'winPercentage': winPercentage,
      'losses': losses,
      'losePercentage': losePercentage,
      'pointsFor': pointsFor,
      'pointsAgainst': pointsAgainst,
      'form': form,
    };
  }
}
