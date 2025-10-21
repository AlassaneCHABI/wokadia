import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/quiz/felicitation_qcm.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/models/Question.dart';
import 'package:wokadia/models/QuestionWithReponses.dart';
import 'package:wokadia/models/Reponse.dart';
import 'package:wokadia/feature/utils/db_manager.dart';

class QuizPage extends StatefulWidget {
  final int moduleId; // ✅ Id du module passé dynamiquement

  const QuizPage({super.key, required this.moduleId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;

  int? selectedIndex;
  bool answered = false;
  bool isCorrectAnswer = false;

  List<QuestionWithReponses> quizQuestions = [];

  // ✅ Chronomètre
  int elapsedSeconds = 0;
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }


  @override
  void initState() {
    super.initState();
    loadQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  Future<void> loadQuestions() async {
    print("Id du modul");
    print(widget.moduleId);
    final questions = await DbManager().getQuestionsByModule(widget.moduleId);
    print("Le nombre de questions trouvé");
    print(questions.length);
    setState(() {
      quizQuestions = questions;
    });
  }

  void selectAnswer(int index) {
    if (answered) return; // éviter double clic
    setState(() {
      selectedIndex = index;
      answered = true;
      isCorrectAnswer = quizQuestions[currentQuestion].reponses[index].correct == 1;
      if (isCorrectAnswer) {
        score += (100 / quizQuestions.length).round();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < quizQuestions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedIndex = null;
        answered = false;
        isCorrectAnswer = false;
      });
    } else {
      // fin du quiz
      _timer?.cancel(); // ⏹️ Stop chrono à la fin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FelicitationQcm(score: score, totalQuestions: quizQuestions.length,moduleId:widget.moduleId,totalTime: elapsedSeconds,),
        ),
      );
    }
  }

  void restartQuestion() {
    setState(() {
      selectedIndex = null;
      answered = false;
      isCorrectAnswer = false;
    });
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color:Vert.withOpacity(0.2),
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
    if (quizQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final questionData = quizQuestions[currentQuestion];
    final question = questionData.question;
    final options = questionData.reponses.map((r) => r.texte).toList();
    double progress = (currentQuestion + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Progression
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 32, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                 // const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 18, // 👈 hauteur personnalisée
                      child: LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(30),
                        backgroundColor:Vert.withOpacity(0.2),
                        color: Vert,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Score et compteur
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBox("${score}/100 points"),
                  _buildInfoBox("⏱ ${formatTime(elapsedSeconds)}"),
                  _buildInfoBox("${currentQuestion + 1}/${quizQuestions.length}"),
                ],
              ),
              const SizedBox(height: 30),

              // ✅ Contenu scrollable (question + options)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        question.titre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Vert,
                          fontFamily: "PilcrowRoundeddbbold"
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choisis la bonne réponse",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Options
                      ...List.generate(options.length, (index) {
                        bool isSelected = selectedIndex == index;

                        Color borderColor = Vert;
                        Color bgColor = Colors.white;
                        Color textColor = Colors.black87;

                        if (answered) {
                          if (isSelected && isCorrectAnswer) {
                            borderColor = Vert;
                            bgColor = Colors.green.shade50;
                            textColor = Colors.black;
                          } else if (isSelected && !isCorrectAnswer) {
                            borderColor = Colors.red;
                            bgColor = Colors.red.shade50;
                            textColor = Colors.red.shade700;
                          }
                        } else if (isSelected) {
                          borderColor = Vert;
                          bgColor = Colors.green.shade50;
                          textColor = Colors.black;
                        }

                        return GestureDetector(
                          onTap: () => selectAnswer(index),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: bgColor,
                              border: Border.all(color: borderColor, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              options[index],
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // ✅ Feedback
              if (answered)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isCorrectAnswer ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                        color: isCorrectAnswer ? Vert : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isCorrectAnswer
                            ? "Super !"
                            : "Du courage",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isCorrectAnswer ? Vert : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 15),

              // ✅ Bouton dynamique
              ElevatedButton(
                onPressed: nextQuestion,
                    /*answered
                    ? (isCorrectAnswer ? nextQuestion : restartQuestion)
                    : null,*/
                style: ElevatedButton.styleFrom(
                  backgroundColor: Vert ,
                  //backgroundColor: isCorrectAnswer ? Vert : Colors.red,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text("Continuer",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                /*Text(
                  isCorrectAnswer ? "Continuer" : "Recommencer",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
