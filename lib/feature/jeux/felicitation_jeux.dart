import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ajouter dans pubspec.yaml
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/jeux/index_jeu.dart';
import 'package:wokadia/feature/modules/liste_modules.dart';
import 'package:wokadia/feature/quiz/QuizPage.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'dart:io';

import '../utils/constant.dart';


class FelicitationJeux extends StatefulWidget {
  const FelicitationJeux({super.key});

  @override
  State<FelicitationJeux> createState() => _FelicitationJeuxState();
}

class _FelicitationJeuxState extends State<FelicitationJeux> {


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // largeur max pour centrer le contenu sur tablette/desktop
    final double contentMaxWidth = 600;
    // largeur max des boutons
    final double buttonMaxWidth = 400;

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),*/
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: AnimatedSpeechBubble(
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Bravo ! tu as terminé\n",
                      textStyle: const TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.w600,
                      ),
                      speed: const Duration(milliseconds: 99),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Image.asset(
              'assets/images/active_youth_félicitation.png',
              width: width * 2,
              height: width * 0.90,
            ),

            const SizedBox(height: 20),

           /* Center(child:Text("Score",style:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),),),
            Center(child:Text("80/100",style:TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Vert
            ),),)*/
          ],
        ),
      ),

      // ✅ Boutons fixés en bas, centrés et responsives
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: height * 0.05,
          left: width * 0.09,
          right: width * 0.09,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: buttonMaxWidth),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => IndexJeu()),
                    );
                  },
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
    );
  }
}
