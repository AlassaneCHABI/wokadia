import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wokadia/feature/cours/indes.dart';
import 'package:wokadia/feature/modules/felicitation_module.dart';
import 'package:wokadia/feature/modules/liste_modules.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/models/chapitres.dart';


class Lesson {
  final String title;
  final List<String> imagePaths; // liste de chemins
  final String description;
  final String instruction;
  final int onlineId;
  final int moduleId;

  Lesson({
    required this.title,
    required this.imagePaths,
    required this.description,
    required this.instruction,
    required this.onlineId,
    required this.moduleId,
  });
}


class Chapitrewidget extends StatefulWidget {
  final List<Lesson> lessons;
  final DbManager dbManager;
  final Function(int index)? onLessonComplete;
  int moduleId;

   Chapitrewidget({
    super.key,
    required this.lessons,
    required this.dbManager,
    this.onLessonComplete,
    required this.moduleId,
  });

  @override
  State<Chapitrewidget> createState() => _ChapitrewidgetState();
}

class _ChapitrewidgetState extends State<Chapitrewidget> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  Future<void> markLessonDone(int index) async {
    final lesson = widget.lessons[index];
    // Récupérer le chapitre dans SQLite
    final chapters = await widget.dbManager.getChapitresById(lesson.onlineId);
    if (chapters.isNotEmpty) {
      Chapitre chap = chapters.first;
      if (chap.isDone == 0) {
        chap.isDone = 1;
        await widget.dbManager.updateChapitre(chap);
      }
    }
    // Callback parent
    if (widget.onLessonComplete != null) widget.onLessonComplete!(index);
  }

  void _next() async {
    await markLessonDone(currentIndex);

    if (currentIndex < widget.lessons.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
     await widget.dbManager.updateselected_modules(widget.moduleId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FelicitationModule(moduleId:widget.moduleId)),
      );
    }
  }

  void _previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: Vert.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lessons[currentIndex];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Vert,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ListeModules()),
              );

            },
          ),
        ),
        /*title: Text(
          "Chapitre ${currentIndex + 1}/${widget.lessons.length}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),*/
        centerTitle: true,
      ),*/

      // Contenu
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.09,
          vertical: height * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              SizedBox(height: 30,),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Vert,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              Indes()),
                    );
                  },
                ),
              ),
               SizedBox(height: 10,),
               _buildInfoBox("Chapitre ${currentIndex + 1}/${widget.lessons.length}"),
              SizedBox(height: 10,),
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Vert,
                  fontFamily: "PilcrowRoundeddbbold"
                ),
              ),
              const SizedBox(height: 20),

              // Image (local ou asset)
              // Images en carrousel
              if (lesson.imagePaths.isNotEmpty) ...[
                Container(
                  height: isTablet ? 300 : 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Vert, width: 5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: lesson.imagePaths.length,
                      itemBuilder: (context, index) {
                        final path = lesson.imagePaths[index];
                        return File(path).existsSync()
                            ? Image.file(
                          File(path),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          path,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: lesson.imagePaths.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Vert,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ] else
                Image.asset("assets/images/chapitre.png",
                    height: isTablet ? 300 : 200, fit: BoxFit.cover),
              const SizedBox(height: 20),

              // Description
              Text(
                lesson.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Instructions
              /*Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Instructions :\n",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: lesson.instruction,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),*/
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Navigation
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.09,
          vertical: height * 0.03,
        ),
        child: Row(
          children: [
            if (currentIndex > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _previous,
                  style:  ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Vert.withOpacity(0.2); // couleur quand désactivé
                        }
                        return Vert.withOpacity(0.2); // couleur quand activé
                      },
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    "Précédent",
                    style: TextStyle(fontSize: 18, color: Vert,fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
            if (currentIndex > 0) const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 55),
                  backgroundColor: Vert,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  currentIndex == widget.lessons.length - 1 ? "Terminer" : "Suivant",
                  style: const TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
