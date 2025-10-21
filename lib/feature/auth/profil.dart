import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wokadia/feature/auth/apropos.dart';
import 'package:wokadia/feature/choix_auth.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/utils/api_service.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/models/DomaineWithModules.dart';
import 'package:wokadia/models/historique_module.dart';
import 'package:wokadia/models/historique_programme.dart';
import 'package:wokadia/models/users.dart';

import 'package:wokadia/models/DomaineWithModules.dart';
import 'package:wokadia/models/game.dart';
import 'package:wokadia/models/chapitres.dart';
import 'package:wokadia/models/domaines.dart';
import 'package:wokadia/models/modules.dart';
import 'package:wokadia/models/organisations.dart';
import 'package:wokadia/models/phrase.dart';
import 'package:wokadia/models/programme.dart';
import 'package:wokadia/models/users.dart';
import 'package:wokadia/models/word.dart';

import '../../models/exercice.dart';
import '../../models/question.dart';
import '../../models/reponse.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({super.key});

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  bool isEditing = false;
  ApiService api_service = ApiService();
  DbManager db_manager = DbManager();
  PreferenceManager pref_manager = PreferenceManager();
  late User user;
  var _isLoading = false;
  List<Chapitre> liste_chapitre = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocalUser();
  }

Future<void> _getLocalUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<User> users = await db_manager.getAllDbUser();
      if (users.isNotEmpty) {
        user = users.first;

        // Initialise les champs avec les données de l'utilisateur
        nomController.text = user.name ?? '';
        orgaController.text = user.organisation_name;
        phoneController.text = user.contact ?? '';
        emailController.text = user.email ?? '';

        setState(() {}); // Pour refléter les nouvelles valeurs dans l'UI
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    api_service.getApi('historique-module/${user.online_id}').then((value) async {
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


  List<Map<String, dynamic>> _loadingSteps = [
   // {"label": "Connexion au serveur", "done": false},
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
                        "Mise à jour \ndes données",
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
                                    : SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Vert),
                                )/*Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Vert,
                                      width: 2,
                                    ),
                                  ),
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

  void updateLoadingStep(int index) {
    if (_setStateDialog != null) {
      _setStateDialog!(() {
        _loadingSteps[index]["done"] = true;
      });
    }
  }

  Future<void> updated() async {
    if (await hasInternetConnection()) {
      print('connected');
      showProgressDialog(context);
      await getDbLocalModule();
      await getDbLocalProgramme();
      await fetchAndSaveDomaines();

    }else{
      print('Pas de connexion internet');
      //Navigator.of(context).pop();
      displayDialog(context, "Actualisation", "Une erreur s’est produite lors de l’actualisation des données. Vérifiez votre connexion Internet et réessayez.", "warning");

    }


  }


  showAlertDialog(BuildContext context,String message){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: Vert,),
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



  /*Future<List<DomaineWithModules>> fetchAndSaveDomaines() async {
    List<DomaineWithModules> domainesWithModules = [];

    try {
      // 1️⃣ Récupération API
      final response = await ApiService().getApi('domaines');
      List<dynamic> domainList = response['data'];

      // 2️⃣ Charger tous les online_id existants (1 seule fois)
      final existingDomainIds = (await db_manager.getAllDomainOnlineIds()).toSet();
      final existingModuleIds = (await db_manager.getAllModuleOnlineIds()).toSet();

      // 3️⃣ Ouvrir la base en transaction pour rapidité
      final db = await DbManager.db();
      await db.transaction((txn) async {
        for (var domaineJson in domainList) {
          Domaines domaine = Domaines.fromJson(domaineJson);

          int localDomaineId;

          // 4️⃣ Domaine inexistant → insertion
          if (!existingDomainIds.contains(domaine.online_id)) {
            localDomaineId = await db_manager.insertDbDomaineWithTxn(txn, domaine);
            existingDomainIds.add(domaine.online_id);
            print("✅ Nouveau domaine ajouté : ${domaine.name}");
          } else {
            // Domaine déjà présent → récupérer son ID local
            final existingDomaine = await db_manager.getDomaineByOnlineId(domaine.online_id);
            localDomaineId = existingDomaine?.id ?? 0;
            print("⏭ Domaine déjà présent : ${domaine.name}");
          }

          List<Modules> modulesList = [];
          List<dynamic> modulesJson = domaineJson['modules'] ?? [];

          for (var moduleJson in modulesJson) {
            Modules module = Modules.fromJson(moduleJson, localDomaineId);

            // 5️⃣ Module inexistant → téléchargement + insertion
            if (!existingModuleIds.contains(module.online_id)) {
              if (module.module_icon.isNotEmpty) {
                try {
                  final localPath = await downloadAndSaveImage(module.module_icon);
                  module.localIconPath = localPath;
                } catch (e) {
                  print('⚠️ Erreur téléchargement icône: $e');
                }
              }

              await db_manager.insertDbModuleWithTxn(txn, module);
              existingModuleIds.add(module.online_id);
              print("✅ Nouveau module ajouté : ${module.name}");
            } else {
              print("⏭ Module déjà présent : ${module.name}");
            }

            modulesList.add(module);
          }

          domainesWithModules.add(
            DomaineWithModules(domaine: domaine, modules: modulesList),
          );
        }
      });

      updateLoadingStep(0);
      await getDbLocalChapitre();

      print('✅ Synchronisation terminée avec succès');
    } catch (e) {
      print('❌ Erreur fetchAndSaveDomaines: $e');
    }

    return domainesWithModules;
  }
*/


  Future<List<DomaineWithModules>> fetchAndSaveDomaines() async {
    List<DomaineWithModules> domainesWithModules = [];

    try {
      // 1️⃣ Appel API
      final response = await ApiService().getApi('domaines');
      List<dynamic> domainList = response['data'];

      // 2️⃣ Vider les anciennes données
      //await db_manager.removeAllDbDomaines();
      //await db_manager.removeAllDbModules();

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
      updateLoadingStep(0);
      await getDbLocalChapitre();
      print('✅ Domaines et modules enregistrés en local avec succès');

    } catch (e) {
      print('❌ Erreur fetchAndSaveDomaines: $e');
    }

    return domainesWithModules;
  }


  getDbLocalChapitre() async {
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
            updateLoadingStep(1);
            await getDbLocalQuestions();

          }else{
            updateLoadingStep(1);
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

      print("✅ Synchronisation des programmes & exercices terminée.");
      updateLoadingStep(4);
     //await db_manager.removeAllSelectedModules();
     //await db_manager.removeAllSelectedProgrammes();

      Navigator.of(context).pop();
      displayDialog(context, "Actualisation", "Données actualisées avec succès !", "success");


    } catch (e) {
      print("❌ Erreur syncProgrammesFromApi : $e");
    }
  }



  Future<void> syncGamesFromApi() async {
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
      updateLoadingStep(3);
      await syncProgrammesFromApi();

      print("✅ Synchronisation des jeux avec icônes terminée.");
    } catch (e) {
      print("❌ Erreur syncGamesFromApi : $e");
    }
  }





  Future<void> getDbLocalQuestions() async {
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
      updateLoadingStep(2);
      await syncGamesFromApi();

      print("✅ Toutes les questions et réponses ont été synchronisées localement.");

    } catch (e) {
      print("❌ Erreur lors de la récupération des questions locales : $e");
    }
  }


  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController orgaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
    child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),

          const SizedBox(width: 10),

          const Text(
            'Compte',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const Spacer(), // <-- pousse le reste vers la droite

          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AproposPage()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.update, color: Colors.black), // autre icône ?
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: Text("Actualiser"),
                    content: Text("Voulez-vous actualiser vos données ? "
                        "\n\nCette opération nécessite une connexion internet."),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await  updated();
                        },
                        child: const Text('Oui'),
                        style: ButtonStyle(
                          // elevation: MaterialStateProperty.all(5),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(Vert),
                          shadowColor: MaterialStateProperty.all(Vertneutre),
                          padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                          fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Ajustez cette valeur selon vos préférences
                          )),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
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
            },
          ),
        ],
      ),


      const SizedBox(height: 10),

   Divider(),
      const SizedBox(height: 10),
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Stack(
    alignment: Alignment.bottomRight,
    children: [
    const CircleAvatar(
    foregroundColor: Vert,
    radius: 40,
    backgroundColor: Vert,
    backgroundImage: AssetImage('assets/images/profil.png'),
    ),
    /*Container(
    decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: Vert,
    ),
    padding: const EdgeInsets.all(5),
    child: const Icon(Icons.lock, color: Colors.white, size: 14),
    ),*/
    ],
    ),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    user.name,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
    const SizedBox(height: 4),
    Text(user.email),
    const SizedBox(height: 4),
    Text(user.organisation_name),
    const SizedBox(height: 8),
    ElevatedButton(
    onPressed: () {
    setState(() {
    isEditing = !isEditing;
    });
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Vertneutre,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    ),
    child: Text(
    isEditing ? 'Enregistrer' : 'Editer',
    style: TextStyle(color: Vert),
    ),
    ),
    ],
    ),
    ),
    ],
    ),

    const SizedBox(height: 30),

    // Champs modifiables
    InputField(label: 'Nom', controller: nomController, enabled: isEditing),
    InputField(label: 'Téléphone', controller: phoneController, enabled: isEditing),
    InputField(label: 'Email', controller: emailController, enabled: isEditing),
    InputField(label: 'Organisation', controller: orgaController, enabled: isEditing),

    const SizedBox(height: 30),

    // Bouton déconnexion
    SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () async {
        pref_manager.removeAllPrefItem();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Bienvenue(),
          ),
        );
        //db_manager.removeAllDbRows();
      },
    icon: const Icon(Icons.logout),
    label: const Text(
    "Déconnexion",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red.shade700,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
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

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Vert, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }




}
