class Modules {
  int id, online_id, domaine_id;
  String name, domaine_name,description, module_icon, slug, statut,domaine_code;

  // Nouveau champ pour le chemin local de l'icône
  String? localIconPath;

  Modules(
      this.id,
      this.online_id,
      this.domaine_id,
      this.name,
      this.domaine_name,
      this.description,
      this.module_icon,
      this.slug,
      this.statut,
      this.domaine_code,
      this.localIconPath);

  factory Modules.fromJson(Map<String, dynamic> json, int domaineId) {
    return Modules(
      json['id'],
      json['online_id'],
      domaineId,
      json['name'] ?? '',
      json['domaine_name'] ?? '',
      json['description'] ?? '',
      json['module_icon'] ?? '',
      json['slug'] ?? '',
      json['statut'] ?? '',
      json['domaine_code'] ?? '',
      json['localIconPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'domaine_id': domaine_id,
    'name': name,
    'domaine_name': domaine_name,
    'description': description,
    'module_icon': module_icon,
    'slug': slug,
    'statut': statut,
    'domaine_code': domaine_code,
    'localIconPath': localIconPath, // On sauvegarde le chemin local
  };
}
