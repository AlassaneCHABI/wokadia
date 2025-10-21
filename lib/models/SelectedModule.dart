class SelectedModule {
  int? id; // id local auto-incrémenté
  int moduleId; // id du module sélectionné
  int domaineId; // id du domaine
  String name;
  String domaine_name;
  String description;
  String domaine_code;
  String? localIconPath;
  int? score;
  int? isDone;
  int? totalTime;

  SelectedModule({
    this.id,
    required this.moduleId,
    required this.domaineId,
    required this.name,
    required this.domaine_name,
    required this.description,
    required this.domaine_code,
    this.localIconPath,
    this.score,
    this.isDone,
    this.totalTime,
  });

  factory SelectedModule.fromJson(Map<String, dynamic> json) {
    return SelectedModule(
      id: json['id'],
      moduleId: json['module_id'],
      domaineId: json['domaine_id'],
      name: json['name'],
      domaine_name: json['domaine_name'],
      description: json['description'],
      domaine_code: json['domaine_code'],
      localIconPath: json['localIconPath'],
      score: json['score'],
      isDone: json['isDone'],
      totalTime: json['totalTime'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'module_id': moduleId,
    'domaine_id': domaineId,
    'name': name,
    'domaine_name': domaine_name,
    'description': description,
    'domaine_code': domaine_code,
    'localIconPath': localIconPath,
    'score': score,
    'isDone': isDone,
    'totalTime': totalTime,
  };
}
