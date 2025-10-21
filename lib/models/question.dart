class Question {
  final int? id;
  final int onlineId;
  final int moduleId;
  final String titre;
  final String type;
  final int active;
  final String slug;


  Question({
    this.id,
    required this.onlineId,
    required this.moduleId,
    required this.titre,
    required this.type,
    required this.active,
    required this.slug,

  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      onlineId: json['online_id'],
      moduleId: json['module_id'],
      titre: json['titre'] ?? '',
      type: json['type'] ?? '',
      active: json['active'] ?? 0,
      slug: json['slug'] ?? '',

    );
  }

  factory Question.fromDb(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      onlineId: map['online_id'],
      moduleId: map['module_id'],
      titre: map['titre'],
      type: map['type'],
      active: map['active'],
      slug: map['slug'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'online_id': onlineId,
      'module_id': moduleId,
      'titre': titre,
      'type': type,
      'active': active,
      'slug': slug,
    };
  }
}
