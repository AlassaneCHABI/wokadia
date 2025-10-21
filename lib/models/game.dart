class Game {
  final int? id;
  final int onlineId;
  final String name;
  final String? gameIcon;
  final String? localIconPath;
  final bool isDone; // ✅ bool au lieu de int?

  Game({
    this.id,
    required this.onlineId,
    required this.name,
    this.gameIcon,
    this.localIconPath,
    this.isDone = false, // ✅ par défaut false
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    onlineId: json['online_id'],
    name: json['name'],
    gameIcon: json['game_icon'],
    localIconPath: json['localIconPath'],
    isDone: (json['isDone'] ?? 0) == 1, // ✅ conversion int → bool
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'online_id': onlineId,
    'name': name,
    'game_icon': gameIcon,
    'local_icon_path': localIconPath,
    'isDone': isDone ? 1 : 0, // ✅ conversion bool → int pour la BDD
  };

  factory Game.fromMap(Map<String, dynamic> map) => Game(
    id: map['id'],
    onlineId: map['online_id'],
    name: map['name'],
    gameIcon: map['game_icon'],
    localIconPath: map['local_icon_path'],
    isDone: (map['isDone'] ?? 0) == 1, // ✅ conversion sécurisée
  );
}
