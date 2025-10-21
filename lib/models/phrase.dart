class Phrase {
  final int? id;
  final int onlineId;
  final int gameId;
  final String name;
  final String gameName;

  Phrase({
    this.id,
    required this.onlineId,
    required this.gameId,
    required this.name,
    required this.gameName,
  });

  factory Phrase.fromJson(Map<String, dynamic> json, int gameId) => Phrase(
    onlineId: json['online_id'],
    gameId: gameId,
    name: json['name'],
    gameName: json['game_name'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'online_id': onlineId,
    'game_id': gameId,
    'name': name,
    'game_name': gameName,
  };

  factory Phrase.fromMap(Map<String, dynamic> map) => Phrase(
    id: map['id'],
    onlineId: map['online_id'],
    gameId: map['game_id'],
    name: map['name'],
    gameName: map['game_name'],
  );

}