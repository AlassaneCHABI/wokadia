import 'package:flutter/material.dart';
import 'package:wokadia/feature/widget/chapitreWidget.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/chapitres.dart';


class Chapitres extends StatefulWidget {
  final int moduleId; // ✅ recevoir l'id du module

  const Chapitres({super.key, required this.moduleId});

  @override
  State<Chapitres> createState() => _ChapitresState();
}

class _ChapitresState extends State<Chapitres> {
  final DbManager dbManager = DbManager();
  List<Lesson> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChapitres();
  }

  Future<void> _loadChapitres() async {
    final List<Chapitre> chapitres =
    await dbManager.getChapitresByModule(widget.moduleId);

    // Convertir les chapitres en Lessons pour le widget
    List<Lesson> loadedLessons = chapitres.map((chap) {
      return Lesson(
        title: chap.titre,
        imagePaths: chap.images.isNotEmpty ? chap.images : ["assets/images/chapitre.png"],
        description: chap.description,
        instruction: "Suivez les instructions pour ce chapitre.",
        onlineId: chap.onlineId,
        moduleId: widget.moduleId,
      );
    }).toList();


    setState(() {
      lessons = loadedLessons;
      isLoading = false;
    });
  }

  // Callback pour mettre à jour la progression ou autre dans la page parent
  void _onLessonComplete(int index) {
    setState(() {
      // Ici tu pourrais rafraîchir la barre de progression
      // ou marquer visuellement les chapitres terminés
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Chapitrewidget(
      lessons: lessons,
      dbManager: dbManager,
      onLessonComplete: _onLessonComplete,
      moduleId:widget.moduleId
    );
  }
}
