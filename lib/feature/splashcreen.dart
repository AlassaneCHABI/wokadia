import 'package:flutter/material.dart';
import 'package:wokadia/feature/jeux/QuizPageJeu.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'choix_auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bienvenue()),
      );

     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bienvenue()), // À adapter
        //MaterialPageRoute(builder: (_) => QuizPageJeux()), // À adapter
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40), // Espace top

              // Logo principal centré
              Center(
                child: Image.asset(
                  'assets/images/active_youth_Logo.png',
                  height: 200,
                ),
              ),

              // Texte et logo ONG en bas
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    /*const Text(
                      "Une application de l’ONG POTAL MEN",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),*/
                    //const SizedBox(height: 12),
                    Image.asset(
                      'assets/images/footer.png',
                      width: size.width * 0.60,
                     // height: size.height*0.30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
