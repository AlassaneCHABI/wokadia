import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ajouter dans pubspec.yaml
import 'package:wokadia/feature/widget/animation.dart';
import 'dart:io';

import '../utils/constant.dart';
import 'module1.dart';

class index extends StatefulWidget {
  const index({super.key});

  @override
  State<index> createState() => _indexState();
}

class _indexState extends State<index> {


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
                      "Salut Frank, choisis les\n"
                          " modules que tu aimérais\n"
                          " suivre \n",
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

            Image.asset(
              'assets/images/active_youth_félicitation.png',
              width: width * 2,
              height: width * 0.90,
            ),

            const SizedBox(height: 20),
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
                      MaterialPageRoute(builder: (_) => ModulePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Choisir',
                    style: TextStyle(
                      fontSize: width * 0.060,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
