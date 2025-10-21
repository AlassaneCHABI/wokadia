import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // ajouter dans pubspec.yaml
import 'package:wokadia/feature/cours/indes.dart';
import 'package:wokadia/feature/historique/index.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/quiz/QuizPage.dart';
import 'package:wokadia/feature/utils/api_service.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'package:wokadia/models/SelectedModule.dart';
import 'package:wokadia/models/eleve.dart';
import 'package:wokadia/models/historique_module.dart';
import 'package:wokadia/models/historique_programme.dart';
import 'dart:io';

import 'package:wokadia/models/programme.dart';
import 'package:wokadia/models/selectedProgramme.dart';
import 'package:wokadia/models/users.dart';


class FelicitationCardio extends StatefulWidget {
  final Programme programme;
  final int totalTime;
   FelicitationCardio({super.key,required this.programme,required this.totalTime,});

  @override
  State<FelicitationCardio> createState() => _FelicitationCardioState();
}

class _FelicitationCardioState extends State<FelicitationCardio> {
  bool moduleDone = false;
  bool ProgrammeDone = false;
  List<SelectedModule> allModules = [];
  List<SelectedProgramme> allProgrammes = [];
  List<Map<String, dynamic>> eleves = [];
  late User user;
  DbManager db_manager = DbManager();
  ApiService api_service = ApiService();

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  Future<void> _checkAllProgramme() async {
    bool done = await DbManager().allProgrammeDone();
    setState(() {
      //chapitreDone = done;
      ProgrammeDone = done;
    });
    print("------------------Programme done--------------");
    print(ProgrammeDone);
  }

  Future<void> _checkAllChapitres() async {
    bool done = await DbManager().allModulesDone();
    setState(() {
      moduleDone = done;
    });
    print("-----------------moduleDone---------------");
    print(moduleDone);
  }


  Future<void> loadModules() async {
    final loadedModules = await DbManager().getAllSelectedModules();
    setState(() {
      allModules = loadedModules;
    });
  }

  Future<void> loadProgrammes() async {
    final loaded = await DbManager().getAllSelectedProgrammes();
    setState(() {
      allProgrammes = loaded;
    });
  }


  Future<void> _getLocalUser() async {
    try {
      final List<User> users = await DbManager().getAllDbUser();
      if (users.isNotEmpty) {
        user = users.first;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
    } finally {
    }
  }


  // 🔹 Charger les élèves déjà enregistrés
  Future<void> _loadElevesFromDb() async {
    List<Eleve> savedEleves = await DbManager().getAllEleves();
    setState(() {
      eleves = savedEleves.map((e) => e.toJson()).toList();
    });
  }


  showAlertDialog(BuildContext context,String message){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("$message...." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  getDbLocalProgramme() async {
    // 1. On vide les anciennes données locales
    await db_manager.clearProgrammeData();

    // 2. On récupère les programmes depuis l’API
    api_service.getApi('historique-programme/${user.online_id}').then((value) async {
      List<dynamic> responseData = value['data'];

      // 3. Vérifier que la liste n’est pas vide
      if (responseData.isNotEmpty) {
        // 4. Parcourir et filtrer selon user_id
        for (var element in responseData) {
          // Vérifie que l’élément contient bien un champ user_id
          //if (element['user_id'] == user.online_id) {
            ProgrammeData ceItem = ProgrammeData.fromJson(element);

            // 5. Insertion dans la base locale
            await db_manager.insertProgrammeData(ceItem);
          //}
        }
      }
    }).catchError((error) {
      print("Erreur lors de la récupération de l'historique des programmes : $error");
    });
  }

  getDbLocalModule() async {
    // 1. On vide les anciennes données locales
    await db_manager.clearModelData();

    // 2. On récupère les programmes depuis l’API
    api_service.getApi('historique-module/${user.online_id}').then((value) async {
      List<dynamic> responseData = value['data'];

      // 3. Vérifier que la liste n’est pas vide
      if (responseData.isNotEmpty) {
        // 4. Parcourir et filtrer selon user_id
        for (var element in responseData) {
          // Vérifie que l’élément contient bien un champ user_id
          //if (element['user_id'] == user.online_id) {
            ModuleData ce_item = ModuleData.fromJson(element);
            // 5. Insertion dans la base locale
            db_manager.insertModelData(ce_item);
         // }
        }
      }
    }).catchError((error) {
      print("Erreur lors de la récupération de l'historique des modules : $error");
    });
  }

  _sauvegardeComplete() async {
    print("************ saveDonneeToServerHttp *******");
    print(user.online_id);
    print(jsonEncode(allModules));
    print(jsonEncode(allProgrammes.map((p) => p.toMap()).toList()));
    print(jsonEncode(eleves));
    showAlertDialog(context,"Sauvegarde en cours");
    try{
      String formUrl = API_BASE_URL + '/formations-store';

      var req_donnee = http.MultipartRequest('POST', Uri.parse(formUrl));

      req_donnee.fields['user_id'] = (user.online_id).toString();
      req_donnee.fields['module'] = jsonEncode(allModules);
      req_donnee.fields['programme'] = jsonEncode(allProgrammes.map((p) => p.toMap()).toList());
      req_donnee.fields['eleves'] = jsonEncode(eleves);
      var stream_reponse = await req_donnee.send();
      var reponse_server = await http.Response.fromStream(stream_reponse);
      var msg_server = jsonDecode(reponse_server.body);

      print("********* Send to Server response ***");
      print(reponse_server.body);


      if(msg_server['status'] == "success")
      {

        // db_manager.removeDbinfrasync(curr_infras.site_id);
        await getDbLocalModule();
        await getDbLocalProgramme();
        await db_manager.removeAllSelectedModules();
        await db_manager.removeAllSelectedProgrammes();
        await db_manager.deleteAllEleves();

        Navigator.of(context).pop();

        showDialog(
          context: this.context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text("Sauvegarde complète"),
              content: Text("Donnée envoyée avec succès"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                        this.context,
                        MaterialPageRoute(builder: (context) => Historique()),
                            (route) => false);
                  },
                  child: const Text('OK'),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(15),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Vert),
                      shadowColor: MaterialStateProperty.all(VertClaire),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                      fixedSize: MaterialStateProperty.all(const Size(100, 40))),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
              icon: Image.asset(
                'assets/images/checked_img.png',
                width: 80,
                height: 80,
              ),
            );
          },
        );
      }
      else{
        print("**********-------- REPONSE SERVER SAVE INFRASTRUCTURE---");
        print(msg_server);
        Navigator.of(context).pop();
        setState(() {
          // progressNotifier.value =0.00; // Increment the progress value
        });
        displayDialog(this.context,
            "Erreur de Sauvegarde",
            msg_server['message'],
            "error");
      }

    }catch(e){
      print("Voici l'erreur : $e");
      // print(e);
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAllProgramme();
    _checkAllChapitres();
    loadModules();
    loadProgrammes();
    _getLocalUser();
    _loadElevesFromDb();
  }

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
                      "Bravo tu as terminé !\n",
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.w600
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
            // ✅ Durée totale

            const Text(
              "Durée totale",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "${formatTime(widget.totalTime)} sec",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Vert,
              ),
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
                  onPressed: () async {
                    if (moduleDone && ProgrammeDone) {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text("Sauvegarde complète"),
                            content: Text("Souhaitez-vous envoyer vos résultats en ligne ? "
                                "\n\nCette opération nécessite une connexion internet."),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  _sauvegardeComplete();
                                },
                                child: const Text('Oui'),
                                style: ButtonStyle(
                                  // elevation: MaterialStateProperty.all(5),
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(Vert),
                                  shadowColor: MaterialStateProperty.all(Vert),
                                  padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                                  fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // Ajustez cette valeur selon vos préférences
                                  )),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                               Navigator.pop(ctx);
                               Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(builder: (_) => Indes()),
                               );
                                } ,
                                child: const Text('Annuler'),
                                style: ButtonStyle(
                                  // elevation: MaterialStateProperty.all(5),
                                  foregroundColor: MaterialStateProperty.all(Vert),
                                  backgroundColor: MaterialStateProperty.all(Vert.withOpacity(0.2)),
                                  shadowColor: MaterialStateProperty.all(Colors.black),
                                  padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                                  fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // Ajustez la valeur pour réduire le borderRadius
                                  )),
                                ),
                              ),

                            ],
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            icon: Image.asset(
                              'assets/images/info_img.png',
                              width: 80,
                              height: 80,

                            ),
                          );
                        },
                      );
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Indes()),
                      );*/
                    } else {
                      // ✅ Sinon → continuer
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Indes()),
                      );
                    }
                   /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    (moduleDone && ProgrammeDone) ? 'Terminer' : 'Suivant',
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
