class ProgrammeData {
  int userId;
  String userName;
  int programmeId;
  String programmeName;
  String? centre;
  int nombreTotalEleve;
  String? temps_total;
  String? date;

  ProgrammeData(
      this.userId,
      this.userName,
      this.programmeId,
      this.programmeName,
      this.centre,
      this.nombreTotalEleve,
      this.temps_total,
      this.date,
      );

  ProgrammeData.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'] ?? 0,
        userName = json['user_name'],
        programmeId = json['programme_id'] ?? 0,
        programmeName = json['programme_name'],
        centre = json['centre']??"",
        nombreTotalEleve = json['nombre_total_eleve'] ?? 0,
        temps_total = json['temps_total']??"",
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'programme_id': programmeId,
    'programme_name': programmeName,
    'centre': centre,
    'nombre_total_eleve': nombreTotalEleve,
    'temps_total': temps_total,
    'date': date,
  };
}
