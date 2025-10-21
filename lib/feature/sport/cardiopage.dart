import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wokadia/feature/modules/cardio/exercices.dart';
import 'package:wokadia/feature/sport/exercices.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/models/programme.dart';
import 'package:wokadia/models/exercice.dart';
import 'package:wokadia/feature/utils/db_manager.dart';

class CardioPage extends StatefulWidget {
  final Programme programme;

  const CardioPage({super.key, required this.programme});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  final DbManager dbManager = DbManager();
  List<Exercice> exercises = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final loadedExercises = await dbManager.getExercisesByProgramme(widget.programme.id!);
    setState(() {
      exercises = loadedExercises;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalDuration = widget.programme.duration;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.09,
            vertical: height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // aligne en haut si multi-lignes
                children: [
                  widget.programme.programmeIcon != null
                      ? Image.file(
                    File(widget.programme.programmeIcon!),
                    fit: BoxFit.contain,
                    height: 80,
                    width: 80,
                  )
                      : const SizedBox(height: 80, width: 80),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.programme.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Vert,
                      ),
                      softWrap: true,        // permet d’aller à la ligne
                      maxLines: 2,           // autorise 2 lignes max
                      overflow: TextOverflow.visible, // pas de "..."
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 20),

              // Duration & Exercise count
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Vertcardio,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.black54, size: 40),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Durée",
                                  style: TextStyle(color: Colors.black54, fontSize: 12)),
                              Text(
                                "${totalDuration} sec",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Vertcardio,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.list_alt, color: Colors.black54, size: 40),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Exercice",
                                  style: TextStyle(color: Colors.black54, fontSize: 12)),
                              Text(
                                "${exercises.length}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Exercices title
              const Text(
                "Exercices",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // List exercices
              Expanded(
                child: ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final e = exercises[index];
                    return ExerciseItem(
                      title: e.name,
                      subtitle: e.durationSeconds !=0
                          ? "${e.durationSeconds} sec"
                          : "",
                      asset: e.exerciseIcon ?? "assets/images/run.png",
                    );
                  },
                ),
              ),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExercisePlayerPage(programme: widget.programme),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Commencer",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String asset;

  const ExerciseItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
           !asset.contains("assets")?Image.file(File(asset), fit: BoxFit.contain,height: 40,
              width: 40,):Image.asset(asset),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }
}
