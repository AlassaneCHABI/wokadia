class HistoriqueFormation {
  int id, online_id;
  String user_id, module_id, module_name, date_debut, date_fin, score, temps_total, created_at, slug;

  HistoriqueFormation(
      this.id,
      this.online_id,
      this.user_id,
      this.module_id,
      this.module_name,
      this.date_debut,
      this.date_fin,
      this.score,
      this.temps_total,
      this.created_at,
      this.slug,
      );

  HistoriqueFormation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        user_id = json['user_id'],
        module_id = json['module_id'],
        module_name = json['module_name'],
        date_debut = json['date_debut'],
        date_fin = json['date_fin'],
        score = json['score'],
        temps_total = json['temps_total'],
        created_at = json['created_at'],
        slug = json['slug'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'user_id': user_id,
    'module_id': module_id,
    'module_name': module_name,
    'date_debut': date_debut,
    'date_fin': date_fin,
    'score': score,
    'temps_total': temps_total,
    'created_at': created_at,
    'slug': slug,
  };
}
