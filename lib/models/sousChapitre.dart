class SousChapitre {
  int id, online_id, chapitre_id, chapitre_name, titre;
  String description, ordre, image, created_at, slug;

  SousChapitre(
      this.id,
      this.online_id,
      this.chapitre_id,
      this.chapitre_name,
      this.titre,
      this.description,
      this.ordre,
      this.image,
      this.created_at,
      this.slug,
      );

  SousChapitre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        chapitre_id = json['chapitre_id'],
        chapitre_name = json['chapitre_name'],
        titre = json['titre'],
        description = json['description'],
        ordre = json['ordre'],
        image = json['image'],
        created_at = json['created_at'],
        slug = json['slug'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'chapitre_id': chapitre_id,
    'chapitre_name': chapitre_name,
    'titre': titre,
    'description': description,
    'ordre': ordre,
    'image': image,
    'created_at': created_at,
    'slug': slug,
  };
}
