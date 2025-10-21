class Commune {
  int id, online_id,pays_id;
  String commune_name,pays_name,code;

  Commune(
      this.id,
      this.online_id,
      this.pays_id,
      this.pays_name,
      this.commune_name,
      this.code,
      );

  Commune.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        pays_id = json['pays_id'],
        pays_name = json['pays_name'],
        commune_name = json['commune_name'],
        code = json['commune_name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'pays_id': pays_id,
    'pays_name': pays_name,
    'commune_name': commune_name,
    'code': commune_name,
  };
}
