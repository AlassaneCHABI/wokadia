import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wokadia/feature/utils/api_service.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'package:wokadia/feature/widget/dropdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wokadia/feature/widget/speechbubble.dart';
import 'package:wokadia/models/role.dart';

import 'auth/login.dart';

class ChoixType extends StatefulWidget {
  ChoixType({Key? key}) : super(key: key);

  @override
  _ChoixTypeUIState createState() => new _ChoixTypeUIState();
}

class _ChoixTypeUIState extends State<ChoixType> {
  final _formKey = GlobalKey<FormState>();
  String type ="";

  PreferenceManager pref_manager = PreferenceManager();
  DbManager db_manager = DbManager();
  List<Role> liste_role = [];
  ApiService api_service = ApiService();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;


    // largeur max pour centrer le contenu sur tablette/desktop
    final double contentMaxWidth = 600;
    // largeur max des boutons
    final double buttonMaxWidth = 400;
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
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
                        SizedBox(height: 10,),
                        Center(
                          child: AnimatedSpeechBubble(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  "Salut moi c'est Alex !",
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.w600,
                                  ),
                                  speed: const Duration(milliseconds: 99),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Image.asset(
                          'assets/images/active_youth_accueil.png',
                          width: width * 2,
                          height: width * 0.90,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Dis moi tu es élève ou\n animateur ?",
                          style: TextStyle(
                            fontSize: width * 0.050,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 20,),

                        Form(
                            key: _formKey,
                            child: Column(
                          children: [
                            DropdownButtonFormField(
                              style: const TextStyle(
                                color: Vert,
                                fontWeight: FontWeight.bold,
                              ),
                              hint: const Text(
                                'Qui es-tu ?',
                                style: TextStyle(
                                  color: Vert,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  type = value!;

                                  print(type);
                                });
                              },
                              items: ['Animateur', 'Eleve'].map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Qui es-tu ?';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(color: Vert, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(width: 1.5, color: Vert),
                                ),
                                hintStyle: const TextStyle(color: Colors.black),
                                filled: true,
                              ),

                              // 🔽 Flèche personnalisée
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Vert, // couleur de la flèche
                                size: 30,    // taille de la flèche (optionnel)
                              ),
                            ),
                          ],
                        ))


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
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      print(type);
                      prefs.setString("type_compte",type);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Login()),
                      );
                    }
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
                    'Continuer',
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

  getDbLocalPays() async {
    /*setState(() {
      _isLoading = true;
    });*/
    int? taille_role=0;
    try {
      db_manager.countDbRoles().then((value) {
        setState(() {
          taille_role = value;
        });
      });

      print("**********-----Api_service: getDbLocalPays : taille ");
      print(taille_role);

      if(taille_role==0)
      {
        db_manager.removeAllDbRoles();
        liste_role.clear();
        List<Role> cette_liste = [];

        api_service.getApi('pays').then((value) {
          List<dynamic> responseData = value['data'];
          /*print("********** PAYS IN REGISTER");
          print(responseData);*/

          /*if(!responseData.isEmpty){
            responseData.forEach((element) {
              Pays ce_item = Pays.fromJson(element);
              db_manager.insertDbPays(ce_item);
              cette_liste.add(ce_item) ;
            });
          }
          setState(() {
            liste_pays = cette_liste;
            /*print("********** UPDATE PAYS IN REGISTER");
            print(liste_pays.length);*/
          });*/
        });
      }
    } catch (e) {
      print("*********----ERROR getDbLocalPays-------");
      print(e.toString());
    } finally {
      /*setState(() {
        _isLoading = false;
      });*/
    }
  }

}
