import "package:flutter/material.dart";
import 'package:wokadia/feature/auth/login.dart';
import 'package:wokadia/feature/auth/register.dart';
import 'package:wokadia/feature/utils/constant.dart';

import 'choix_type.dart';

class Bienvenue extends StatefulWidget {
  Bienvenue({Key? key}) : super(key: key);

  @override
  _BienvenueUIState createState() => new _BienvenueUIState();
}

class _BienvenueUIState extends State<Bienvenue> {
  final TextEditingController bailleurcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // largeur max pour centrer le contenu sur tablette/desktop
    final double contentMaxWidth = 600;
    // largeur max des boutons
    final double buttonMaxWidth = 400;

    return PopScope(
        canPop: false,
        child:  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.09,
                      vertical: height * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // tout centré
                      children: [
                        SizedBox(height: height * 0.03),
                        /*Image.asset(
                          'assets/images/bienvenu.png',
                          width: width * 0.70,
                          height: width * 0.50,
                        ),*/
                        Image.asset(
                          'assets/images/active_youth_accueil.png',
                          width: width * 2,
                          height: width * 0.90,
                        ),
                        /*SizedBox(
                          width: width * 0.9,
                          height: height * 0.4, // 40% de l’écran
                          child: Image.asset(
                            'assets/images/bienvenu.png',
                            fit: BoxFit.contain,
                          ),
                        ),*/
                        Text(
                          "Active\n Youth",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            height: 1,
                            color: Vert,
                            decoration: TextDecoration.underline,
                            decorationColor: Vert,
                            decorationThickness: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "La méthode fun et efficace pour\n développer "
                              "tes compétences en \néducation environnementale "
                              "et \nacquérir des compétences de\n vie par le sport",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            //fontFamily: 'PilcrowRounded'
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => Login()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Vert,
                                textStyle: const TextStyle(fontSize: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0, // ✅ Supprime l'ombre
                                shadowColor: Colors.transparent, // ✅ Assure qu’il n’y a pas de résidu d’ombre
                              ),
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: width * 0.060,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => Register()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide( // ✅ Bordure verte
                                    color: Vert,
                                    width: 1, // épaisseur de la bordure
                                  ),
                                ),
                                elevation: 0, // ✅ Supprime l'ombre
                                shadowColor: Colors.transparent, // ✅ Assure qu’il n’y a pas de résidu d’ombre
                              ),
                              child: Text(
                                'Créer un compte',
                                style: TextStyle(
                                  fontSize: width * 0.060,
                                  color: Vert,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // ✅ Boutons fixés en bas, centrés et responsives
      /*bottomNavigationBar: Padding(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChoixType()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0, // ✅ Supprime l'ombre
                    shadowColor: Colors.transparent, // ✅ Assure qu’il n’y a pas de résidu d’ombre
                  ),
                  child: Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: width * 0.060,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: buttonMaxWidth),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ChoixType()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide( // ✅ Bordure verte
                        color: Vert,
                        width: 1, // épaisseur de la bordure
                      ),
                    ),
                    elevation: 0, // ✅ Supprime l'ombre
                    shadowColor: Colors.transparent, // ✅ Assure qu’il n’y a pas de résidu d’ombre
                  ),
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: width * 0.060,
                      color: Vert,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )*/
    ),
      onPopInvoked: (didPop) {
      // Bloquer retour
    },
    );
  }
}
