class MatchDetails {
  final int matchId;
  final String team1Name;
  final String team2Name;
  final int team1Score;
  final int team2Score;
  final String? winner;
  final bool isLive; 
  final DateTime date;
  final String matchNumber;
  final String tournamentName;

  MatchDetails( {
    required this.matchId,
    required this.tournamentName,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
    this.winner,
    required this.isLive,
    required this.date,
    required this.matchNumber,
  });
}
