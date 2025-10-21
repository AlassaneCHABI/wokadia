class Reponse {
  final int? id;
  final int onlineId;
  final int questionId;
  final String texte;
  final int correct;
  final String slug;

  Reponse({
    this.id,
    required this.onlineId,
    required this.questionId,
    required this.texte,
    required this.correct,
    required this.slug,
  });

  factory Reponse.fromJson(Map<String, dynamic> json) {
    return Reponse(
      id: json['id'],
      onlineId: json['online_id'],
      questionId: json['question_id'],
      texte: json['texte'] ?? '',
      correct: json['correct'] ?? 0,
      slug: json['slug'] ?? '',
    );
  }

  factory Reponse.fromDb(Map<String, dynamic> map) {
    return Reponse(
      id: map['id'],
      onlineId: map['online_id'],
      questionId: map['question_id'],
      texte: map['texte'],
      correct: map['correct'],
      slug: map['slug'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'online_id': onlineId,
      'question_id': questionId,
      'texte': texte,
      'correct': correct,
      'slug': slug,
    };
  }
}
