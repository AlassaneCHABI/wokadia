class User {
  int id, online_id, role_id, organisation_id;
  String role_name, organisation_name, pays, commune;
  String name,sexe,contact,status, email, password,path_photo, slug,created_at;

  User(
      this.id,
      this.online_id,
      this.role_id,
      this.organisation_id,
      this.role_name,
      this.organisation_name,
      this.pays,
      this.commune,
      this.name,
      this.email,
      this.contact,
      this.sexe,
      this.status,
      this.password,
      this.path_photo,
      this.created_at,
      this.slug);

  User.fromJson(Map<String, dynamic> json) :
        id= json['id'],
        online_id= json['id'],
        role_id= json['role_id'],
        organisation_id= json['organisation_id'],
        role_name= json['role_name']??"",
        organisation_name= json['organisation_name']??"",
        pays= json['pays']??"",
        commune= json['commune']??"",
        name= json['name'],
        email= json['email'],
        contact= json['contact'],
        status= json['status']??"",
        sexe= json['sexe']??"",
        password= json['password']??"",
        path_photo= json['path_photo']?? "vide",
        created_at= json['created_at']??"",
        slug= json['slug'];
}
