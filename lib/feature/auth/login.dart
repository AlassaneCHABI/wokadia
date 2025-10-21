import 'dart:io';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:wokadia/feature/auth/register.dart';
import 'package:wokadia/feature/utils/api_service.dart';
import 'package:wokadia/feature/utils/auth_service.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/widget/dropdown.dart';
import 'package:wokadia/models/DomaineWithModules.dart';
import 'package:wokadia/models/game.dart';
import 'package:wokadia/models/chapitres.dart';
import 'package:wokadia/models/domaines.dart';
import 'package:wokadia/models/historique_module.dart';
import 'package:wokadia/models/historique_programme.dart';
import 'package:wokadia/models/modules.dart';
import 'package:wokadia/models/organisations.dart';
import 'package:wokadia/models/phrase.dart';
import 'package:wokadia/models/programme.dart';
import 'package:wokadia/models/users.dart';
import 'package:wokadia/models/word.dart';

import '../../models/exercice.dart';
import '../../models/question.dart';
import '../../models/reponse.dart';
import '../home/home.dart';
import 'package:path_provider/path_provider.dart';



class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => new _LoginUIState();
}

class _LoginUIState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _isLoading = false;
  int user_id =0;
  late User user;
  DbManager db_manager = DbManager();
  ApiService api_service = ApiService();
  List<Chapitre> liste_chapitre = [];
  String messageAlert="Connexion en cours...";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // largeur max pour centrer le contenu sur tablette/desktop
    final double contentMaxWidth = 600;
    // largeur max des boutons
    final double buttonMaxWidth = 400;

    bool passwordVisible = true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return SingleChildScrollView(
              child: Center( // 🔑 centre tout le contenu sur grands écrans
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.09,
                      vertical: height * 0.03,
                    ),
                    child:Form(
                      key: _formKey,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // tout centré
                      children: [
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Connexion",style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            height: 1,
                            decorationThickness: 1,
                          ),),),
                        SizedBox(height: 10,),
                        //SizedBox(height: height * 0.03),
                        Image.asset(
                          'assets/images/active_youth_connexion.png',
                          width: width * 2,
                          height: width * 0.90,
                          //fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10,),


                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(width:2,color: Vert)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 2, color: Vert),
                            ),
                            hintText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Vert,
                            ),
                            hintStyle: const TextStyle(color: Vert),
                            alignLabelWithHint: false,
                            fillColor: Colors.white,
                            filled: true,

                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Veuillez entrer votre adresse email';
                            }
                            return null;
                          },

                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 13,),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(width:2,color: Vert)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 2, color: Vert),
                            ),
                            hintText: "Mot de passe",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Vert,
                            ),
                            hintStyle: const TextStyle(color: Vert),
                            alignLabelWithHint: false,
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible ? Icons.visibility_off : Icons.visibility,
                                color: Vert,
                              ),
                              onPressed: () {
                                print("object");
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                          obscureText: passwordVisible,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),

                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                          child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: Center(child: Text("Mot de passe oublié ?"),)
                          ),
                        ),

                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () async {

                                if (_formKey.currentState!.validate()) {

                                  /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );*/
                                  if (await hasInternetConnection()) {
                                  loginUserToServer();
                                  }else{
                                    print('Pas de connexion internet');
                                    Navigator.of(context).pop();
                                    //Navigator.of(context).pop();
                                    displayDialog(context, "Actualisation", "Une erreur s’est produite lors du chargement des données. Vérifiez votre connexion Internet et réessayez.", "warning");

                                  }

                                }
                                else {
                                  displayDialog(context,
                                      "Erreur de validation",
                                      "Veuillez remplir tous les champs",
                                      "error");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Vert,
                                textStyle: const TextStyle(fontSize: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
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

                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                          child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: Center(child:InkWell(
                                onTap:() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => Register()),
                                  );
                                },
                                child:  Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Vous n'avez pas de compte ? ",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "Créer",
                                        style: TextStyle(color: Vert, fontWeight: FontWeight.bold,fontSize: 15),
                                      ),

                                    ],
                                  ),
                                )
                                ,) )
                          ),
                        ),

                      ],
                    ),)

                  ),
                ),
              ),
            );
          },
        ),
      ),

      // ✅ Boutons fixés en bas, centrés et responsives
    /*  bottomNavigationBar: Padding(
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
                child: Center(child: Text("Mot de passe oublié ?"),)
              ),
            ),
            
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: buttonMaxWidth),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );*/
                      loginUserToServer();
                    }
                    else {
                      displayDialog(context,
                          "Erreur de validation",
                          "Veuillez remplir tous les champs",
                          "error");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
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

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: buttonMaxWidth),
              child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Center(child:InkWell(
                    onTap:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Register()),
                      );
                    },
                      child:  Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Vous n'avez pas de compte ? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "Créer",
                              style: TextStyle(color: Vert, fontWeight: FontWeight.bold,fontSize: 15),
                            ),

                          ],
                        ),
                      )
                    ,) )
              ),
            ),

          ],
        ),
      ),*/
    );
  }



  List<Map<String, dynamic>> _loadingSteps = [
    {"label": "Connexion au serveur", "done": false},
    {"label": "Chargement des domaines et modules", "done": false},
    {"label": "Chargement des chapitre", "done": false},
    {"label": "Chargement des questions", "done": false},
    {"label": "Chargement des jeux", "done": false},
    {"label": "Chargement des programmes sportifs", "done": false},
  ];



  late StateSetter _setStateDialog;

  void showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  _setStateDialog = setStateDialog;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Titre ---
                      Text(
                        "Chargement des\n données",
                        style: TextStyle(
                          color: Vert, // Vert principal
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Vert,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Liste des étapes ---
                      Column(
                        children: _loadingSteps.map((step) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF8EF), // vert clair
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    step["label"],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                step["done"]
                                    ? Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Vert,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                                    :SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Vert),
                                ),/* Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Vert,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Vert),
                                ),*/
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }


  /*void showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            _setStateDialog = setStateDialog; // pour mise à jour dynamique
            return AlertDialog(
              title: const Text("Connexion en cours"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _loadingSteps.map((step) {
                  return Row(
                    children: [
                      step["done"]
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(step["label"])),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
*/

  void updateLoadingStep(int index) {
    if (_setStateDialog != null) {
      _setStateDialog!(() {
        _loadingSteps[index]["done"] = true;
      });
    }
  }


  /*void showAlertDialog(BuildContext context, String message) {
    messageAlert = message;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _setStateDialog = setState; // Pour mettre à jour le message plus tard
            return AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Vert,),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "$messageAlert...",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            );
          },
        );
      },
    );
  }*/


  /*getDbLocalModule() async {
    db_manager.clearModelData();
    api_service.getApi('historique-module/$user_id').then((value) {
      List<dynamic> responseData = value['data'];

      if(!responseData.isEmpty){
        responseData.forEach((element) {
          ModuleData ce_item = ModuleData.fromJson(element);
          db_manager.insertModelData(ce_item);
        });
      }

    });
  }*/


  getDbLocalProgramme() async {
    // 1. On vide les anciennes données locales
    await db_manager.clearProgrammeData();

    // 2. On récupère les programmes depuis l’API
    api_service.getApi('historique-programme/${user_id}').then((value) async {
      List<dynamic> responseData = value['data'];

      // 3. Vérifier que la liste n’est pas vide
      if (responseData.isNotEmpty) {
        // 4. Parcourir et filtrer selon user_id
        for (var element in responseData) {
          // Vérifie que l’élément contient bien un champ user_id
         // if (element['user_id'] == user_id) {
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
    api_service.getApi('historique-module/$user_id').then((value) async {
      List<dynamic> responseData = value['data'];

      // 3. Vérifier que la liste n’est pas vide
      if (responseData.isNotEmpty) {
        // 4. Parcourir et filtrer selon user_id
        for (var element in responseData) {
          // Vérifie que l’élément contient bien un champ user_id
          //if (element['user_id'] == user_id) {
            ModuleData ce_item = ModuleData.fromJson(element);
            // 5. Insertion dans la base locale
            db_manager.insertModelData(ce_item);
       //   }
        }
      }
    }).catchError((error) {
      print("Erreur lors de la récupération de l'historique des modules : $error");
    });
  }


  /*getDbLocalProgramme() async {
    db_manager.clearModelData();
    api_service.getApi('historique-programme/$user_id').then((value) {
      List<dynamic> responseData = value['data'];

      if(!responseData.isEmpty){
        responseData.forEach((element) {
          ProgrammeData ce_item = ProgrammeData.fromJson(element);
          db_manager.insertProgrammeData(ce_item);
        });
      }

    });
  }*/



  Future<List<DomaineWithModules>> fetchAndSaveDomaines() async {
    /*_setStateDialog(() {
      messageAlert = "Chargement des Domaines";
    });*/

    List<DomaineWithModules> domainesWithModules = [];

    try {
      // 1️⃣ Appel API
      final response = await ApiService().getApi('domaines');
      List<dynamic> domainList = response['data'];

      // 2️⃣ Vider les anciennes données
      await db_manager.removeAllDbDomaines();
      await db_manager.removeAllDbModules();

      // 3️⃣ Parcourir les domaines
      for (var domaineJson in domainList) {
        Domaines domaine = Domaines.fromJson(domaineJson);

        int? localDomaineId = await db_manager.insertDbDomaine(domaine);

        List<Modules> modulesList = [];
        List<dynamic> modulesJson = domaineJson['modules'] ?? [];

        for (var moduleJson in modulesJson) {
          Modules module = Modules.fromJson(moduleJson, localDomaineId!);

          // 4️⃣ Télécharger l'icône et stocker localement
          if (module.module_icon.isNotEmpty) {
            try {
              final localPath = await downloadAndSaveImage(module.module_icon);
              module.localIconPath = localPath;
            } catch (e) {
              print('⚠️ Erreur téléchargement icône: $e');
            }
          }

          // 5️⃣ Insérer module en base
          await db_manager.insertDbModule(module);
          modulesList.add(module);
        }

        // 6️⃣ Ajouter à la liste imbriquée
        domainesWithModules.add(DomaineWithModules(domaine: domaine, modules: modulesList));
      }

      print('✅ Domaines et modules enregistrés en local avec succès');
      updateLoadingStep(1);
      await getDbLocalChapitre();

    } catch (e) {
      print('❌ Erreur fetchAndSaveDomaines: $e');
    }

    return domainesWithModules;
  }


  getDbLocalChapitre() async {
    /*_setStateDialog(() {
      messageAlert = "Chargement des chapitres";
    });*/
    try {
      int? nbr_chapitre = await db_manager.countDbChapitres();

        liste_chapitre.clear();
        await db_manager.clearAllChapitres();

        api_service.getApi('chapitres').then((value) async {
          List<dynamic> responseData = value['data'];

          if (responseData.isNotEmpty) {
            for (var element in responseData) {
              Chapitre ce_item = Chapitre.fromJson(element);

              // 🔹 Liste des nouvelles images locales
              List<String> localImages = [];

              // Pour chaque image renvoyée par l'API
              for (String imgUrl in ce_item.images) {
                try {
                  String localPath = await downloadAndSaveImage(imgUrl);
                  localImages.add(localPath);
                } catch (e) {
                  print("❌ Erreur téléchargement image $imgUrl : $e");
                }
              }

              // 🔹 Créer un nouvel objet Chapitre avec images locales
              Chapitre chapitreLocal = Chapitre(
                id: ce_item.id,
                onlineId: ce_item.onlineId,
                moduleId: ce_item.moduleId,
                titre: ce_item.titre,
                description: ce_item.description,
                images: localImages, // ✅ images locales
                slug: ce_item.slug,
              );

              // 🔹 Enregistrement en DB
              await db_manager.insertChapitre(chapitreLocal);

              print("✅ Chapitre inséré: ${chapitreLocal.titre}");
            }
            updateLoadingStep(2);
            await getDbLocalQuestions();
          }
        });


    } catch (e) {
      print("❌ ERROR getDbLocalChapitre: ${e.toString()}");
    }
  }



// Fonction utilitaire pour télécharger et enregistrer une image localement
  Future<String> downloadAndSaveImage(String url) async {
    final response = await http.get(Uri.parse(BASE_URL+url));

    if (response.statusCode == 200) {
      final documentDir = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final file = File('${documentDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } else {
      throw Exception('Erreur téléchargement image $url');
    }
  }



  Future<void> syncProgrammesFromApi() async {
   /* _setStateDialog(() {
      messageAlert = "Chargement des Programmes Sportif";
    });*/
    try {
      // 1. Vider les tables locales
      await db_manager.removeAllExercises();
      await db_manager.removeAllProgrammes();

      // 2. Appel API
      final response = await api_service.getApi('programmes');
      final List<dynamic> programmeData = response['data'];

      for (var pJson in programmeData) {
        // 3. Télécharger l’icône programme si dispo
        String? localProgrammeIcon;
        if (pJson['programme_icon'] != null) {
          try {
            localProgrammeIcon =
            await downloadAndSaveImage(pJson['programme_icon']);
          } catch (e) {
            print("⚠️ Erreur téléchargement icône programme: $e");
          }
        }

        // 4. Créer Programme et insérer en DB
        final programme = Programme(
          onlineId: pJson['online_id'],
          name: pJson['name'],
          duration: pJson['duration'],
          programmeIcon: localProgrammeIcon,
        );

        final programmeId = await db_manager.insertProgramme(programme);
        print("Bon pour les progeamme");

        // 5. Gérer les exercices liés
        if (pJson['exercises'] != null) {
          for (var eJson in pJson['exercises']) {
            // Télécharger icône exercice si dispo
            String? localExerciseIcon;
            if (eJson['exercise_icon'] != null) {
              try {
                localExerciseIcon =
                await downloadAndSaveImage(eJson['exercise_icon']);
              } catch (e) {
                print("⚠️ Erreur téléchargement icône exercice: $e");
              }
            }

            print("En cours pour exercice");
            // Créer Exercise et insérer

            final exercise = Exercice(
              onlineId: eJson['online_id'],
              name: eJson['name'] ?? "",
              programmeId: programmeId,
              programmeName: eJson['programme_name'] ?? "",
              durationSeconds: eJson['duration_seconds'] != null
                  ? int.tryParse(eJson['duration_seconds'].toString()) ?? 0
                  : 0,
              exerciseIcon: localExerciseIcon ?? "", // valeur vide si pas d'icône
              instruction: eJson['instruction'] ?? "",
            );


            await db_manager.insertExercise(exercise);
            print("Bon pour exercice");
          }
        }
      }
      updateLoadingStep(5);
      print("✅ Synchronisation des programmes & exercices terminée.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      print("❌ Erreur syncProgrammesFromApi : $e");
    }
  }



  Future<void> syncGamesFromApi() async {
    /*_setStateDialog(() {
      messageAlert = "Chargement des Jeux";
    });*/
    try {
      await db_manager.removeAllWords();
      await db_manager.removeAllPhrases();
      await db_manager.removeAllGames();

      final response = await api_service.getApi('games');
      final List<dynamic> gameData = response['data'];

      for (var gJson in gameData) {
        // Télécharger l'icône si disponible
        String? localIconPath;
        if (gJson['game_icon'] != null) {
          try {
            localIconPath =
            await downloadAndSaveImage(gJson['game_icon']);
          } catch (e) {
            print("⚠️ Erreur téléchargement icône: $e");
          }
        }

        // Créer le Game avec chemin local
        final game = Game(
          onlineId: gJson['online_id'],
          name: gJson['name'],
          gameIcon: gJson['game_icon'],
          localIconPath: localIconPath,
        );

        final gameId = await db_manager.insertGame(game);

        // --- Phrases ---
        if (gJson['phrases'] != null) {
          for (var pJson in gJson['phrases']) {
            final phrase = Phrase.fromJson(pJson, gameId);
            final phraseId = await db_manager.insertPhrase(phrase);

            // --- Words ---
            if (pJson['words'] != null) {
              for (var wJson in pJson['words']) {
                final word = Word.fromJson(wJson, phraseId);
                await db_manager.insertWord(word);
              }
            }
          }
        }
      }
      print("✅ Synchronisation des jeux avec icônes terminée.");
      updateLoadingStep(4);
      await syncProgrammesFromApi();
    } catch (e) {
      print("❌ Erreur syncGamesFromApi : $e");
    }
  }





  Future<void> getDbLocalQuestions() async {
    /*_setStateDialog(() {
      messageAlert = "Chargement des Qcm";
    });*/
    try {
      // 1️⃣ Supprimer toutes les questions et réponses locales pour éviter les doublons
      await db_manager.removeAllDbQuestions();
      await db_manager.removeAllDbReponse();

      // 2️⃣ Récupérer toutes les questions depuis l'API
      final response = await api_service.getApi('questions');
      final List<dynamic> questionData = response['data'];

      // 3️⃣ Parcourir chaque question
      for (var qJson in questionData) {
        final question = Question.fromJson(qJson);

        // Inserer la question dans la DB
        await db_manager.insertQuestion(question);

        // Inserer toutes les réponses liées
        if (qJson['reponses'] != null) {
          for (var rJson in qJson['reponses']) {
            final reponse = Reponse.fromJson(rJson);
            await db_manager.insertReponse(reponse);
          }
        }
      }

      print("✅ Toutes les questions et réponses ont été synchronisées localement.");
      updateLoadingStep(3);
      await syncGamesFromApi();

    } catch (e) {
      print("❌ Erreur lors de la récupération des questions locales : $e");
    }
  }



  Future<bool> hasInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }


  loginUserToServer() async {
    //showAlertDialog(context, "Connexion en cours");
    showProgressDialog(context);
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim());
    bool isPasswordValid = _passwordController.text.trim().length >= 6;

    if (!isEmailValid || !isPasswordValid)
    {
      Navigator.of(context).pop();
      displayDialog(context,
          "Erreur d'authentification",
          "Email et/ou mot de passe incorrect",
          "error");
    }
    else {
      final data = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };
      // print(data);
      setState(() {
        _isLoading = true;
      });
      String response_msg = await AuthService().loginToServer(data);

      if (response_msg.startsWith("succes"))
      {
        updateLoadingStep(0);

        List tab = response_msg.split("***");
        print("tab");
        print(tab);
        print(tab[1]);

        setState(() {
          user_id = int.parse(tab[1]);
        });

        setState(() {
          _isLoading = false;
        });

        await getDbLocalModule();
        await getDbLocalProgramme();
        updateLoadingStep(0);
        await fetchAndSaveDomaines();

      }
      else {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });

        displayDialog(context,
            "Erreur d'authentification",
            "${response_msg}",
            "warning");
      }
    }
  }

}


