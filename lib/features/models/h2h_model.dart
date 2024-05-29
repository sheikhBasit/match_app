class HeadToHeadMatch {
  final String id;
  final String leagueId;
  final String leagueName;
  final String season;
  final String statusLong;
  final String statusShort;
  final String date;
  final String time;
  final String timezone;
  final String week;
  final Team homeTeam;
  final Team awayTeam;
  final Score homeScore;
  final Score awayScore;

  HeadToHeadMatch({
    required this.id,
    required this.leagueId,
    required this.leagueName,
    required this.season,
    required this.statusLong,
    required this.statusShort,
    required this.date,
    required this.time,
    required this.timezone,
    required this.week,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
  });

  factory HeadToHeadMatch.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('The provided JSON cannot be null.');
    }

    return HeadToHeadMatch(
      id: json['id'].toString(),
      leagueId: json['league']?['id'].toString() ?? '',
      leagueName: json['league']?['name'] as String? ?? '',
      season: json['league']?['season']?.toString() ?? '',
      statusLong: json['status']?['long'] as String? ?? '',
      statusShort: json['status']?['short'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      week: json['week'] as String? ?? 'Unknown',
      homeTeam: Team.fromJson(json['teams']!['home'] as Map<String, dynamic>),
      awayTeam: Team.fromJson(json['teams']?['away'] as Map<String, dynamic>),
      homeScore:
          Score.fromJson(json['scores']?['home'] as Map<String, dynamic>),
      awayScore:
          Score.fromJson(json['scores']?['away'] as Map<String, dynamic>),
    );
  }
}

class Team {
  final String id;
  final String name;
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'].toString(),
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }
}

class Score {
  final int? total;
  final int? hits;
  final int? errors;
  final Map<String, dynamic>? innings;

  Score({
    this.total,
    this.hits,
    this.errors,
    this.innings,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      total: json['total'] as int?,
      hits: json['hits'] as int?,
      errors: json['errors'] as int?,
      innings: json['innings'] != null
          ? Map<String, dynamic>.from(json['innings'] as Map<String, dynamic>)
          : null,
    );
  }
}
