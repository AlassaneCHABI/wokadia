import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/modules/cardio/cardiopage.dart';
import 'package:wokadia/feature/modules/chapitres.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/SelectedModule.dart';

class ListeModules extends StatefulWidget {
  const ListeModules({super.key});

  @override
  State<ListeModules> createState() => _ListeModulesState();
}

class _ListeModulesState extends State<ListeModules> {
  final DbManager dbManager = DbManager();
  List<SelectedModule> selectedModules = [];
  Map<int, int> totalChapitres = {}; // moduleId -> nombre total de chapitres
  Map<int, int> chapitresTermines = {}; // moduleId -> nombre de chapitres terminés

  @override
  void initState() {
    super.initState();
    _loadSelectedModules();
  }

  Future<void> _loadSelectedModules() async {
    final modules = await dbManager.getAllSelectedModules();

    Map<int, int> total = {};
    Map<int, int> termines = {};

    for (var module in modules) {
      final chapitres = await dbManager.getChapitresByModule(module.moduleId);
      total[module.id!] = chapitres.length;
      termines[module.id!] = chapitres.where((chap) => chap.isDone == 1).length;
    }

    setState(() {
      selectedModules = modules;
      totalChapitres = total;
      chapitresTermines = termines;
    });
  }

  // Callback pour actualiser le nombre de chapitres terminés d’un module
  void _updateModuleProgress(int moduleId) async {
    final chapitres = await dbManager.getChapitresByModule(moduleId);
    setState(() {
      chapitresTermines[moduleId] =
          chapitres.where((chap) => chap.isDone == 1).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Vert),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      HomePage()),
            );

          },
        ),
      ),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "Liste des\n modules choisis",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Vert,
                    decoration: TextDecoration.underline,
                    decorationColor: Vert,
                    decorationThickness: 1,
                    fontFamily: "Pally"
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(30),
                  itemCount: selectedModules.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final module = selectedModules[index];
                    final nbrTotal = totalChapitres[module.id!] ?? 0;
                    final nbrTermine = chapitresTermines[module.id!] ?? 0;

                    return InkWell(
                      onTap: () {
                        if(nbrTotal!=0){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Chapitres(
                                moduleId: module.moduleId,
                              ),
                            ),
                          ).then((_) {
                            // 🔹 Met à jour la progression après retour
                            _updateModuleProgress(module.moduleId);
                          });
                        }else{
                          displayDialog(context,
                              "Erreur",
                              "Le module ne contient aucun chapitre",
                              "warning");
                        }

                              /*if (module.domaine_code.toLowerCase().contains("Programme sportif")) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CardioPage()),
                          );
                        } else {
                          if(nbrTotal!=0){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Chapitres(
                                  moduleId: module.moduleId,
                                ),
                              ),
                            ).then((_) {
                              // 🔹 Met à jour la progression après retour
                              _updateModuleProgress(module.moduleId);
                            });
                          }else{
                            displayDialog(context,
                                "Erreur",
                                "Le module ne contient aucun chapitre",
                                "warning");
                          }

                        }*/
                      },
                      child: buildModuleCard(
                        color: Colors.green.shade50,
                        title: module.name,
                        icon: module.localIconPath != null &&
                            File(module.localIconPath!).existsSync()
                            ? Icons.play_arrow
                            : Icons.lock,
                        chap_termine: nbrTermine.toString(),
                        nbr_total_chap: nbrTotal.toString(),
                        localIconPath: module.localIconPath,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Vert,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Suivant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModuleCard({
    required Color color,
    required String title,
    required IconData icon,
    required String chap_termine,
    required String nbr_total_chap,
    String? localIconPath,
  }) {
    double progress = 0;
    if (int.tryParse(nbr_total_chap) != null &&
        int.tryParse(nbr_total_chap)! > 0) {
      progress = int.parse(chap_termine) / int.parse(nbr_total_chap);
    }

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: "PilcrowRounded"
                  ),
                ),
              ),
              const SizedBox(width: 10),
              localIconPath != null && File(localIconPath).existsSync()
                  ? Image.file(File(localIconPath), width: 60, height: 60)
                  : Icon(icon, size: 40, color: Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Chapitres : $chap_termine sur $nbr_total_chap",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Vert,
              valueColor: AlwaysStoppedAnimation<Color>(Vert),
            ),
          ),
        ],
      ),
    );
  }
}
