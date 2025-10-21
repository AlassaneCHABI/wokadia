class Pays {
  int id, online_id;
  String pays_name,code;

  Pays(
      this.id,
      this.online_id,
      this.pays_name,
      this.code,
      );

  Pays.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        pays_name = json['pays_name'],
        code = json['code'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'pays_name': pays_name,
    'code': code,
  };
}
