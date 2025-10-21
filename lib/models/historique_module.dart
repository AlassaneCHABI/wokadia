class ModuleData {
  int userId;
  String? userName;
  int moduleId;
  String? moduleName;
  String? centre;
  int nombreTotalEleve;
  String? temps_total;
  String? date;
  int? score;

  ModuleData(
      this.userId,
      this.userName,
      this.moduleId,
      this.moduleName,
      this.centre,
      this.nombreTotalEleve,
      this.temps_total,
      this.date,
      this.score,
      );

  ModuleData.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'] ?? 0,
        userName = json['user_name'],
        moduleId = json['module_id'] ?? 0,
        moduleName = json['module_name'],
        centre = json['centre']??"",
        nombreTotalEleve = json['nombre_total_eleve'] ?? 0,
        temps_total = json['temps_total']??"",
        date = json['date']??"",
        score = json['score'] ?? 0;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'module_id': moduleId,
    'module_name': moduleName,
    'centre': centre,
    'nombre_total_eleve': nombreTotalEleve,
    'temps_total': temps_total,
    'date': date,
    'score': score,
  };
}
