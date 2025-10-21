class Eleve {
  int? id;
  int userId;
  String nom;
  String ville;
  String ecole;
  String classe;
  String photo;
  String centre;
  String sexe;

  Eleve({
    this.id,
    required this.userId,
    required this.nom,
    required this.ville,
    required this.ecole,
    required this.classe,
    required this.photo,
    required this.centre,
    required this.sexe,
  });

  factory Eleve.fromJson(Map<String, dynamic> json) {
    return Eleve(
      id: json['id'],
      userId: json['user_id'],
      nom: json['nom'],
      ville: json['ville'],
      ecole: json['ecole'],
      classe: json['classe'],
      photo: json['photo'],
      centre: json['centre'],
      sexe: json['sexe'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nom': nom,
      'ville': ville,
      'ecole': ecole,
      'classe': classe,
      'photo': photo,
      'centre': centre,
      'sexe': sexe,
    };
  }
}
