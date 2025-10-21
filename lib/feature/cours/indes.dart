import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/auth/profil.dart';
import 'package:wokadia/feature/historique/index.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/jeux/QuizPageJeu.dart';
import 'package:wokadia/feature/jeux/index_jeu.dart';
import 'package:wokadia/feature/modules/cardio/cardiopage.dart';
import 'package:wokadia/feature/modules/chapitres.dart';
import 'package:wokadia/feature/sport/cardiopage.dart';
import 'package:wokadia/feature/sport/index_sport.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/models/SelectedModule.dart';
import 'package:wokadia/models/chapitres.dart';
import '../../models/selectedProgramme.dart' show SelectedProgramme;
import '../add_profil/IdentityPage.dart';
import '../utils/constant.dart';
import '../widget/custombottomnavigation.dart';

class Indes extends StatefulWidget {
  const Indes({super.key});

  @override
  State<Indes> createState() => _IndesState();
}

class _IndesState extends State<Indes> {
  int _selectedIndex = 0;
  PreferenceManager pref_manager = PreferenceManager();
  String? name;
  final DbManager dbManager = DbManager();
  //List<SelectedModule> selectedModules = [];

  String getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "";

    List<String> parts = fullName.trim().split(" ");
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }


  Future<void> _loadName() async {
    String? savedName = await pref_manager.getPrefItem("name");
    setState(() {
      name = savedName;
    });
  }

  Future<void> loadProgrammes() async {
    final loaded = await dbManager.getAllSelectedProgrammes();
    setState(() {
      allProgrammes = loaded;
    });
  }

  List<String> domaines = [];
  String activeDomaine = "";
  List<SelectedModule> allModules = [];
  List<SelectedProgramme> allProgrammes = [];


  // Charger les domaines depuis la DB
  Future<void> loadDomaines() async {
    print("Liste des domaines");
    final loadedDomaines = await dbManager.getAllDbDomaines();
    setState(() {
      domaines = loadedDomaines.map((d) => d.domaine_code).toList();
      if (domaines.isNotEmpty) {
        print(domaines[0]);
        activeDomaine = domaines[0]; // Domaine par défaut
      }
      // ✅ Ajout manuel de l’onglet Programme sportif
      domaines.add("Programme sportif");
    });
  }

  // Charger tous les modules sélectionnés
  Future<void> loadModules() async {
    final loadedModules = await dbManager.getAllSelectedModules();
    setState(() {
      allModules = loadedModules;
    });
  }


  Future<void> checkAndActivateNextDomain() async {
    // Charger les modules si ce n’est pas encore fait
    final modules = await dbManager.getAllSelectedModules();

    // Liste des domaines actuels
    if (domaines.isEmpty) return;

    for (int i = 0; i < domaines.length; i++) {
      final domaine = domaines[i];

      // Modules du domaine courant
      final domaineModules = modules.where((m) => m.domaine_code == domaine).toList();

      if (domaineModules.isEmpty) continue;

      // Vérifie si tous les chapitres de tous les modules du domaine sont terminés
      bool allModulesDone = true;
      for (final module in domaineModules) {
        final chapitres = await dbManager.getChapitresByModule(module.moduleId);
        if (chapitres.any((c) => c.isDone == 0)) {
          allModulesDone = false;
          break;
        }
      }

      // Si tous les modules de ce domaine sont finis, on passe au suivant
      if (allModulesDone && i < domaines.length - 1) {
        setState(() {
          activeDomaine = domaines[i + 1];
        });
        break; // on active le premier domaine suivant non fini
      }
    }
  }



  Widget buildModuleList() {
    return allModules.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: allModules
          .where((m) => m.domaine_code == activeDomaine)
          .map((module) {
        return FutureBuilder(
          future: dbManager.getChapitresByModule(module.moduleId),
          builder: (context, chapSnapshot) {
            if (!chapSnapshot.hasData) {
              return const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()));
            }
            final chapitres = chapSnapshot.data as List<Chapitre>;
            final total = chapitres.length;
            final done =
                chapitres.where((c) => c.isDone == 1).length;
            final progress = total > 0 ? done / total : 0.0;

            return InkWell(
              onTap: () {
                if (total != 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          Chapitres(moduleId: module.moduleId),
                    ),
                  );
                } else {
                  displayDialog(
                    context,
                    "Erreur",
                    "Le module ne contient aucun chapitre",
                    "warning",
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            module.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        module.localIconPath != null &&
                            File(module.localIconPath!)
                                .existsSync()
                            ? Image.file(File(module.localIconPath!),
                            width: 50, height: 50)
                            : const Icon(Icons.play_arrow,
                            size: 40, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Chapitres : $done sur $total",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Vert.withOpacity(0.2),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                            Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildProgrammeList() {
    return allProgrammes.isEmpty
        ? const Center(child: Text("Aucun programme sélectionné"))
        : ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: allProgrammes.map((p) {
        final isCompleted = p.isDone == "1"; // ✅ programme terminé
        return InkWell(
          onTap: () async {
            final programme = await dbManager.getProgrammeById(p.programmeId);

            if (programme != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardioPage(programme: programme),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("Programme introuvable ${p.programmeId}")),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (isCompleted)
                        const Text(
                          "Terminé ✅",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                p.programmeIcon != null && File(p.programmeIcon!).existsSync()
                    ? Image.file(
                  File(p.programmeIcon!),
                  width: 50,
                  height: 50,
                )
                    : const Icon(Icons.play_arrow, size: 40, color: Colors.green),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadName();
    loadDomaines();
    loadModules();
    loadProgrammes();
    //checkAndActivateNextDomain();
    _selectedIndex = 1;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:

        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IndexJeu()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Historique()),
        );
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: VertClaire,
      body:Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.09,
              vertical: height * 0.03,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.4,
                height: height * 0.12,
                child: Image.asset(
                  "assets/images/active_youth.png",
                  fit: BoxFit.contain,
                ),
              ),
              InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ComptePage()),
                    );
                  },
                  child:  CircleAvatar(
                    radius: 20,
                    backgroundColor: Vert,
                    child: Text(
                      getInitials(name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              )
            ],
          ),
          SizedBox(height: height * 0.03),

          const Text(
            "Listes des modules",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Onglets domaines
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: domaines.map((domaine) {
                bool isActive = domaine == activeDomaine;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeDomaine = domaine;
                      });
                    },
                    child: buildTab(domaine, isActive: isActive),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: activeDomaine == "Programme sportif"
                ? buildProgrammeList()   // ✅ affiche les programmes choisis
                : buildModuleList(),     // ✅ affiche les modules normaux
          ),

          // Liste des modules filtrés par domaine actif
          /*Expanded(
            child: allModules.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: allModules
                  .where((m) => m.domaine_code == activeDomaine)
                  .map((module) {
                return FutureBuilder(
                  future: dbManager.getChapitresByModule(module.moduleId),
                  builder: (context, chapSnapshot) {
                    if (!chapSnapshot.hasData) {
                      return const SizedBox(
                          height: 50,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    final chapitres = chapSnapshot.data as List<Chapitre>;
                    final total = chapitres.length;
                    final done =
                        chapitres.where((c) => c.isDone == 1).length;
                    final progress = total > 0 ? done / total : 0.0;

                    return InkWell(
                      onTap: () {
                        if(total!=0){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Chapitres(moduleId: module.moduleId),
                            ),
                          );
                        }else{
                        displayDialog(context,
                        "Erreur",
                        "Le module ne contient aucun chapitre",
                        "warning");
                        }

                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    module.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                module.localIconPath != null && File(module.localIconPath!).existsSync()
                                    ? Image.file(File(module.localIconPath!), width: 50, height: 50)
                                    : const Icon(Icons.play_arrow, size: 40, color: Colors.green),

                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Chapitres : $done sur $total",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade300,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),*/
        ],
      ),
     ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 30,
            child: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }



  Widget buildHistoryCard({
    required String name,
    required String school,
    required String location,
    required String time,
    required String score,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$school\n$location",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Heure",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        // color: Colors.orange,
                      ),
                    ),
                    Text(
                      "Score",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        // color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$time",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "$score",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  // === Widget Carte de jeu ===
  Widget buildGameCard({
    required String title,
    required String image,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // === Widget pour les modules (cartes)
  Widget buildModuleCard({
    required Color color,
    required String title,
    required String image,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}


// === Widget pour les tabs (EE, Sport, etc.)
Widget buildTab(String text, {bool isActive = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: isActive ? Colors.white :  Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: isActive ? Border.all(color: Vert, width: 2) : null,
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 14,
      ),
    ),
  );

}
