class Programme {
  final int? id;             // id local (SQLite)
  final int onlineId;        // id venant de l'API
  final String name;
  final String duration;
  final String? programmeIcon;
  String isDone;

  Programme({
    this.id,
    required this.onlineId,
    required this.name,
    required this.duration,
    this.programmeIcon,
    this.isDone = "0",
  });

  factory Programme.fromMap(Map<String, dynamic> map) {
    return Programme(
      id: map['id'],
      onlineId: map['online_id'],
      name: map['name'],
      duration: map['duration'],
      programmeIcon: map['programme_icon'],
      isDone: map['isDone'] ?? "0",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'online_id': onlineId,
      'name': name,
      'duration': duration,
      'programme_icon': programmeIcon,
      'isDone': isDone,
    };
  }
}
