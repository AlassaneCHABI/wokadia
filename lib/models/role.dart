class Role {
  int id, online_id;
  String name, description, created_at, slug;

  Role(
      this.id,
      this.online_id,
      this.name,
      this.description,
      this.created_at,
      this.slug,
      );

  Role.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        online_id = json['online_id'],
        name = json['name'],
        description = json['description'],
        created_at = json['created_at'],
        slug = json['slug'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'online_id': online_id,
    'name': name,
    'description': description,
    'created_at': created_at,
    'slug': slug,
  };
}
