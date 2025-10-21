class Exercice {
  final int? id;
  final int onlineId;
  final String name;
  final int programmeId;
  final String programmeName;
  final int durationSeconds; // toujours un int
  final String exerciseIcon;
  final String instruction;

  Exercice({
    this.id,
    required this.onlineId,
    required this.name,
    required this.programmeId,
    required this.programmeName,
    required this.durationSeconds,
    required this.exerciseIcon,
    required this.instruction,
  });

  factory Exercice.fromMap(Map<String, dynamic> map) {
    return Exercice(
      id: map['id'],
      onlineId: map['online_id'],
      name: map['name'] ?? "",
      programmeId: map['programme_id'] ?? 0,
      programmeName: map['programme_name'] ?? "",
      durationSeconds: map['duration_seconds'] != null
          ? int.tryParse(map['duration_seconds'].toString()) ?? 0
          : 0,
      exerciseIcon: map['exercise_icon'] ?? "",
      instruction: map['instruction'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'online_id': onlineId,
      'name': name,
      'programme_id': programmeId,
      'programme_name': programmeName,
      'duration_seconds': durationSeconds,
      'exercise_icon': exerciseIcon,
      'instruction': instruction,
    };
  }
}
