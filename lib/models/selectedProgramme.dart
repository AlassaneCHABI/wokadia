import 'package:wokadia/models/programme.dart';

class SelectedProgramme {
  final int? id;
  final int programmeId;         // correspond à Programme.onlineId
  final String name;
  final String duration;
  final String? programmeIcon;
  String isDone; // ✅ 0 = pas terminé, 1 = terminé

  SelectedProgramme({
    this.id,
    required this.programmeId,
    required this.name,
    required this.duration,
    this.programmeIcon,
    this.isDone = "0", // par défaut non terminé
  });

  factory SelectedProgramme.fromProgramme(Programme p) {
    return SelectedProgramme(
      programmeId: p.onlineId,   // ⚡ on prend l'ID en ligne
      name: p.name,
      duration: p.duration,
      programmeIcon: p.programmeIcon,
      isDone: p.isDone,
    );
  }

  factory SelectedProgramme.fromMap(Map<String, dynamic> map) {
    return SelectedProgramme(
      id: map['id'],
      programmeId: map['programme_id'],
      name: map['name'],
      duration: map['duration'],
      programmeIcon: map['programme_icon'],
      isDone: map['isDone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'programme_id': programmeId,
      'name': name,
      'duration': duration,
      'programme_icon': programmeIcon,
      'isDone': isDone,
    };
  }
}
