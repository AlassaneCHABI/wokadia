import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/modules/felicitation_module.dart';
import 'package:wokadia/feature/modules/index1.dart';
import 'package:wokadia/feature/modules/module2.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/SelectedModule.dart';
import 'package:wokadia/models/domaines.dart';
import 'package:wokadia/models/modules.dart';
import 'package:wokadia/models/programme.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  final DbManager dbManager = DbManager();

  List<Domaines> domaines = [];
  int currentDomaineIndex = 0;
  Map<int, List<Modules>> modulesByDomaine = {}; // Stocker les modules par domaine
  List<Modules> selectedModules = [];
  List<Programme> programmes = [];

  @override
  void initState() {
    super.initState();
    _loadDomaines().then((_) {
      _loadSelectedModules();
    });
    _loadProgrammes();
  }


  Future<void> _loadProgrammes() async {
    final allProgrammes = await dbManager.getAllProgrammes();
    setState(() {
      programmes = allProgrammes;
    });
  }

  Future<void> _loadDomaines() async {
    final allDomaines = await dbManager.getAllDbDomaines();
    setState(() {
      domaines = allDomaines;
    });
    if (allDomaines.isNotEmpty) {
      await _loadModulesForDomaine(allDomaines[0].id);
    }
  }

  Future<void> _loadModulesForDomaine(int domaineId) async {
    if (!modulesByDomaine.containsKey(domaineId)) {
      final mods = await dbManager.getModulesByDomaineId(domaineId);
      modulesByDomaine[domaineId] = mods;
    }
    setState(() {});
  }


  Future<void> _loadSelectedModules() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('selected_modules');

    setState(() {
      selectedModules = maps.map((map) => Modules(
        map['module_id'],            // ✅ on stocke dans id (même valeur que online_id)
        map['module_id'],            // ✅ online_id
        map['domaine_id'],
        map['name'],
        map['domaine_name'],
        map['description'] ?? '',
        '',
        '',
        '',
        map['domaine_code'] ?? '',
        map['localIconPath'],
      )).toList();
    });
  }




  /*_saveSelectedModules() async {
    // 1️⃣ Supprimer l'ancien contenu
   // await dbManager.removeAllSelectedModules();

    // 2️⃣ Insérer chaque module sélectionné
    for (var module in selectedModules) {
      await dbManager.insertSelectedModule(
        SelectedModule(
          moduleId: module.id,
          domaineId: module.domaine_id,
          name: module.name,
          domaine_name: module.domaine_name,
          description: module.description,
          domaine_code: module.domaine_code,
          localIconPath: module.localIconPath,
        ),
      );
    }
  }*/

  Future<void> _saveSelectedModules() async {
    final db = await DbManager.db();

    for (var module in selectedModules) {
      // Vérifier si déjà en DB
      final existing = await db.query(
        'selected_modules',
        where: 'module_id = ?',
        whereArgs: [module.online_id],
      );

      if (existing.isEmpty) {
        await db.insert(
          'selected_modules',
          {
            'module_id': module.online_id,
            'domaine_id': module.domaine_id,
            'name': module.name,
            'domaine_name': module.domaine_name,
            'description': module.description,
            'domaine_code': module.domaine_code,
            'localIconPath': module.localIconPath,
          },
        );
      }
    }
  }



  void _nextDomaine() async {
    if (currentDomaineIndex < domaines.length - 1) {
      setState(() {
        currentDomaineIndex++;
      });
      await _loadModulesForDomaine(domaines[currentDomaineIndex].id);
    } else {
      // Sauvegarder avant d'aller sur la page finale
      await _saveSelectedModules();

      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => index1(),
        ),
      );*/
      if(programmes.isEmpty){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => index1(),
          ),
        );

      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProgrammePage(),
          ),
        );
      }

    }
  }


  void _previousDomaine() {
    if (currentDomaineIndex > 0) {
      setState(() {
        currentDomaineIndex--;
      });
    }
  }

  /*void _toggleModuleSelection(Modules module) {
    setState(() {
      if (selectedModules.contains(module)) {
        selectedModules.remove(module);
      } else {
        selectedModules.add(module);
      }
    });
  }*/

  void _toggleModuleSelection(Modules module) {
    setState(() {
      final exists = selectedModules.any((m) => m.online_id == module.online_id);
      if (exists) {
        selectedModules.removeWhere((m) => m.online_id == module.online_id);
      } else {
        selectedModules.add(module);
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    if (domaines.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentDomaine = domaines[currentDomaineIndex];
    final currentModules = modulesByDomaine[currentDomaine.id] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre dynamique
              Text(
                currentDomaine.name,
                style: TextStyle(
                  color: Vert,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Vert,
                  decorationThickness: 1,
                  fontFamily: "Pally"
                ),
              ),
              const SizedBox(height: 20),

              // Modules dynamiques
              Expanded(
                child: ListView.separated(
                  itemCount: currentModules.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final module = currentModules[index];
                    //final isSelected = selectedModules.contains(module);
                    final isSelected = selectedModules.any((m) => m.online_id == module.online_id);
                    return GestureDetector(
                      onTap: () => _toggleModuleSelection(module),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade100 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Vert : Colors.transparent, // ✅ bordure verte si sélectionné
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                module.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                    fontFamily: "PilcrowRounded"
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            module.localIconPath != null
                                ? Image.file(
                              File(module.localIconPath!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            )
                                : const Icon(Icons.image, size: 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Boutons navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Vert.withOpacity(0.2); // couleur quand désactivé
                          }
                          return Vert.withOpacity(0.2); // couleur quand activé
                        },
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: currentDomaineIndex > 0 ? _previousDomaine : null,
                    child: const Text(
                      "Retour",
                      style: TextStyle(
                        color: Vert,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Vert,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _nextDomaine,
                    child: Text(
                      currentDomaineIndex < domaines.length - 1
                          ? "Suivant"
                          : "Suivant",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page qui affiche les modules choisis
class SelectedModulesPage extends StatelessWidget {
  final List<Modules> selectedModules;

  const SelectedModulesPage({super.key, required this.selectedModules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modules choisis")),
      body: ListView.builder(
        itemCount: selectedModules.length,
        itemBuilder: (context, index) {
          final module = selectedModules[index];
          return ListTile(
            leading: module.localIconPath != null
                ? Image.file(
              File(module.localIconPath!),
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            )
                : const Icon(Icons.image),
            title: Text(module.name),
            subtitle: Text(module.description),
          );
        },
      ),
    );
  }
}
