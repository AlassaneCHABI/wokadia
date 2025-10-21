import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/modules/index1.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/programme.dart';
import '../../models/selectedProgramme.dart';

class ProgrammePage extends StatefulWidget {
  const ProgrammePage({super.key});

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {
  final DbManager dbManager = DbManager();

  List<Programme> programmes = [];
  List<SelectedProgramme> selectedProgrammes = [];

  @override
  void initState() {
    super.initState();
    _loadProgrammes();
    _loadSelectedProgrammes();
  }

  Future<void> _loadProgrammes() async {
    final allProgrammes = await dbManager.getAllProgrammes();
    setState(() {
      programmes = allProgrammes;
    });
  }

  Future<void> _loadSelectedProgrammes() async {
    final allSelected = await dbManager.getAllSelectedProgrammes();
    setState(() {
      selectedProgrammes = allSelected;
    });
  }

  /*Future<void> _saveSelectedProgrammes() async {
    await dbManager.removeAllSelectedProgrammes();

    for (var sp in selectedProgrammes) {
      await dbManager.insertSelectedProgramme(sp);
    }
  }*/

  Future<void> _saveSelectedProgrammes() async {
    for (var p in selectedProgrammes) {
      // Vérifier si ce programme existe déjà en DB
      final exists = await dbManager.programmeExists(p.programmeId);
      if (!exists) {
        await dbManager.insertSelectedProgramme(p);
      }
    }
  }



  void _toggleProgrammeSelection(Programme p) {
    setState(() {
      final exists = selectedProgrammes.any((sp) => sp.programmeId == p.onlineId);
      if (exists) {
        selectedProgrammes.removeWhere((sp) => sp.programmeId == p.onlineId);
      } else {
        selectedProgrammes.add(SelectedProgramme.fromProgramme(p));
      }
    });
  }

  void _next() async {
    await _saveSelectedProgrammes();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => index1(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double buttonMaxWidth = 400;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    if (programmes.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Programme sportif",
                  style: TextStyle(
                    color: Vert,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Vert,
                    decorationThickness: 1,
                    fontFamily: "Pally",
                  ),
                ),
                const SizedBox(height: 20),
                Center(child: CircularProgressIndicator(),)
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Programme sportif",
                style: TextStyle(
                  color: Vert,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Vert,
                  decorationThickness: 1,
                  fontFamily: "Pally",
                ),
              ),
              const SizedBox(height: 20),

              // Liste des programmes
              Expanded(
                child: ListView.separated(
                  itemCount: programmes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final p = programmes[index];
                    final isSelected = selectedProgrammes.any((sp) => sp.programmeId == p.onlineId);

                    return GestureDetector(
                      onTap: () => _toggleProgrammeSelection(p),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade100 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Vert : Colors.transparent,
                            width: 2,
                          ),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontFamily: "PilcrowRounded",
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Durée : ${p.duration}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            p.programmeIcon != null
                                ? Image.file(
                              File(p.programmeIcon!),
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

              // Bouton valider
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Vert,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Terminé',
                      style: TextStyle(
                        fontSize: width * 0.060,
                        color: Colors.white,
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
}
