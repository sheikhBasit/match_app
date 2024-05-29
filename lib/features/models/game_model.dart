class Game {
  final int results;
  final int id;
  final DateTime date;
  final String time;
  final int timestamp;
  final String timezone;
  final Status status;
  final String leagueName;
  final Team homeTeam;
  final Team awayTeam;
  final Score homeScore;
  final Score awayScore;

  Game({
     required this.results, 
    required this.leagueName,
    required this.id,
    required this.date,
    required this.time,
    required this.timestamp,
    required this.timezone,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
  return Game(
    results: json['results'] as int? ?? 0,
    id: json['id'] as int,
    date: DateTime.parse(json['date'] as String),
    time: json['time'] as String,
    timestamp: json['timestamp'] as int,
    timezone: json['timezone'] as String,
    status: Status.fromJson(json['status'] as Map<String, dynamic>),
    leagueName: json['league']['name'] as String,
    homeTeam: Team.fromJson(json['teams']['home'] as Map<String, dynamic>),
    awayTeam: Team.fromJson(json['teams']['away'] as Map<String, dynamic>),
    homeScore: Score.fromJson(json['scores']['home'] as Map<String, dynamic>),
    awayScore: Score.fromJson(json['scores']['away'] as Map<String, dynamic>),
  );
}


}

class Status {
  final String long;
  final String short;

  Status({
    required this.long,
    required this.short,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      long: json['long'] as String,
      short: json['short'] as String,
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
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
