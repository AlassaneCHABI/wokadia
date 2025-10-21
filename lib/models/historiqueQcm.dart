class HistoriqueQcm {
  int id, online_id;
  String user_id, question_id, question_name, date, score, temps_total, created_at, slug;

  HistoriqueQcm(
      this.id,
      this.online_id,
      this.user_id,
      this.question_id,
      this.question_name,
      this.date,
      this.score,
      this.temps_total,
      this.created_at,
      this.slug,
      );

  HistoriqueQcm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        user_id = json['user_id'],
        question_id = json['question_id'],
        question_name = json['question_name'],
        date = json['date'],
        score = json['score'],
        temps_total = json['temps_total'],
        created_at = json['created_at'],
        slug = json['slug'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'user_id': user_id,
    'question_id': question_id,
    'question_name': question_name,
    'date': date,
    'score': score,
    'temps_total': temps_total,
    'created_at': created_at,
    'slug': slug,
  };
}
