class Organisations {
  int id, online_id, abonnement_id,nb_utilisateurs_max;
  String abonnement_name, name, type_organise, ifu;
  String contact,email,adresse,responsable, description,created_at, slug;

  Organisations(
      this.id,
      this.online_id,
      this.abonnement_id,
      this.abonnement_name,
      this.name,
      this.type_organise,
      this.ifu,
      this.contact,
      this.email,
      this.adresse,
      this.responsable,
      this.nb_utilisateurs_max,
      this.description,
      this.created_at,
      this.slug);

  Organisations.fromJson(Map<String, dynamic> json) :
        id= json['id'],
        online_id= json['online_id'],
        abonnement_id= json['abonnement_id'],
        abonnement_name= json['abonnement_name'],
        name= json['name'],
        type_organise= json['type_organise'],
        ifu= json['ifu'],
        contact= json['contact'],
        email= json['email'],
        adresse= json['adresse'],
        responsable= json['responsable'],
        nb_utilisateurs_max= json['nb_utilisateurs_max'],
        description= json['description'],
        created_at= json['created_at'],
        slug= json['slug'];


      Map<String, dynamic> toJson() => {
        'id': id,
        'online_id': online_id,
        'abonnement_id': abonnement_id,
        'abonnement_name': abonnement_name,
        'name': name,
        'type_organise': type_organise,
        'ifu': ifu,
        'contact': contact,
        'email': email,
        'adresse': adresse,
        'responsable': responsable,
        'nb_utilisateurs_max': nb_utilisateurs_max,
        'description': description,
        'created_at': created_at,
        'slug': slug,
      };

}
