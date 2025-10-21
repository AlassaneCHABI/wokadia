import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/jeux/felicitation_jeux.dart';
import 'package:wokadia/feature/jeux/index_jeu.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'package:wokadia/models/game.dart';
import 'package:wokadia/models/phrase.dart';
import 'package:wokadia/models/word.dart';
import 'package:wokadia/feature/utils/db_manager.dart';

class QuizPageJeux extends StatefulWidget {
  final Game game;
  const QuizPageJeux({super.key, required this.game});

  @override
  State<QuizPageJeux> createState() => _QuizPageJeuxState();
}

class _QuizPageJeuxState extends State<QuizPageJeux> {
  final DbManager dbManager = DbManager();

  List<Phrase> phrases = [];
  Phrase? currentPhrase;
  List<Word> words = [];
  Word? selectedWord;
  bool validated = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPhrases();
  }

  Future<void> loadPhrases() async {
    final loadedPhrases = await dbManager.getPhrasesByGame(widget.game.id!);
    if (loadedPhrases.isNotEmpty) {
      setState(() {
        phrases = loadedPhrases;
        currentPhrase = phrases[0];
      });
      await loadWords(currentPhrase!.id!);
    }
  }

  Future<void> loadWords(int phraseId) async {
    final loadedWords = await dbManager.getWordsByPhrase(phraseId);
    setState(() {
      words = loadedWords;
      selectedWord = null;
      validated = false;
    });
  }

  void validateOrContinue() async {
    if (selectedWord == null) return;

    if (validated) {
      // Passer à la phrase suivante
      if (currentIndex < phrases.length - 1) {
        setState(() {
          currentIndex++;
          currentPhrase = phrases[currentIndex];
        });
        await loadWords(currentPhrase!.id!);
      } else {
        // Fin du quiz
        await dbManager.updateGame(widget.game.onlineId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FelicitationJeux()),
        );
      }
    } else {
      setState(() {
        validated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (currentPhrase == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bool isCorrect = selectedWord != null &&
        selectedWord!.isCorrect == 1 &&
        validated;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                children: [
                 InkWell(child:Icon(Icons.close, size: 32, color: Colors.black),onTap: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (_) =>
                             IndexJeu()),
                   );
                 },) ,
                  Expanded(
                    child: SizedBox(
                    height: 18, // 👈 hauteur personnalisée
                    child: LinearProgressIndicator(
                        value: (currentIndex + 1) / phrases.length,
                        minHeight: 17,
                        backgroundColor: Vert.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        valueColor: const AlwaysStoppedAnimation<Color>(Vert),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Center(
              child: AnimatedSpeechBubble(
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Complète la phrase avec\n l'un des mots suivants :",
                      textStyle: const TextStyle(fontSize: 15),
                      speed: const Duration(milliseconds: 99),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/active_youth_connexion.png',
              width: width * 2,
              height: width * 0.50,
            ),

            const SizedBox(height: 20),
            // Carte de la phrase
            Container(
              width: width * 0.9,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Vert, width: 3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Vert,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentPhrase!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Liste des mots avec FutureBuilder
                  words.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: words.map((word) {
                      final isSelected = selectedWord == word;

                      Color borderColor = Vert;
                      if (validated && isSelected) {
                        borderColor =
                        word.isCorrect == 1 ? Vert : Colors.red;
                      } else if (isSelected) {
                        borderColor = Vert;
                      }

                      return GestureDetector(
                        onTap: validated
                            ? null
                            : () {
                          setState(() {
                            selectedWord = word;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green.shade50
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border:
                            Border.all(color: borderColor, width: 2),
                          ),
                          child: Text(
                            word.word,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Vert : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (validated)
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isCorrect ? "Super !" : "Du courage",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: selectedWord == null ? null : validateOrContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    disabledBackgroundColor: Vert.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    validated ? "Continuer" : "Valider",
                    style: TextStyle(
                      fontSize: 16,
                      color: validated
                          ? Colors.white
                          : (selectedWord == null? Vert:Colors.white),
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
