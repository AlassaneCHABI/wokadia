class Domaines {
  int id, online_id;
  String name, detail, domaine_icon,domaine_code;

  Domaines(
      this.id,
      this.online_id,
      this.name,
      this.detail,
      this.domaine_code,
      this.domaine_icon);

  factory Domaines.fromJson(Map<String, dynamic> json) {
    return Domaines(
      json['id'],
      json['online_id'],
      json['name'] ?? '',
      json['detail'] ?? '',
      json['domaine_code'] ?? '',
      json['domaine_icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'name': name,
    'detail': detail,
    'domaine_code': domaine_code,
    'domaine_icon': domaine_icon,
  };
}
