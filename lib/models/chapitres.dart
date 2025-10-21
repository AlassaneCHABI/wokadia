import 'dart:convert';

class Chapitre {
  int? id; // id local (SQLite) => optionnel car SQLite gère l'AUTO INCREMENT
  int onlineId; // id en ligne (API)
  int moduleId;
  String titre;
  String description;
  List<String> images; // ✅ chemins locaux des images
  String slug;
  int isDone; // ✅ 0 = pas terminé, 1 = terminé

  Chapitre({
    this.id,
    required this.onlineId,
    required this.moduleId,
    required this.titre,
    required this.description,
    required this.images,
    required this.slug,
    this.isDone = 0, // par défaut non terminé
  });

  /// ✅ Depuis API JSON (images = URL à télécharger après coup)
  factory Chapitre.fromJson(Map<String, dynamic> json) {
    return Chapitre(
      id: json['id'],
      onlineId: json['online_id'],
      moduleId: json['module_id'],
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      slug: json['slug'] ?? '',
      isDone: json['is_done'] ?? 0,
    );
  }

  /// ✅ Pour sauvegarde en DB (images encodées en JSON string)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'online_id': onlineId,
      'module_id': moduleId,
      'titre': titre,
      'description': description,
      'images': jsonEncode(images), // ✅ encodage JSON
      'slug': slug,
      'is_done': isDone,
    };
  }

  /// ✅ Depuis DB SQLite (images stockées en JSON string)
  factory Chapitre.fromMap(Map<String, dynamic> map) {
    return Chapitre(
      id: map['id'],
      onlineId: map['online_id'],
      moduleId: map['module_id'],
      titre: map['titre'],
      description: map['description'],
      images: List<String>.from(jsonDecode(map['images'] ?? '[]')),
      slug: map['slug'],
      isDone: map['is_done'] ?? 0,
    );
  }
}
