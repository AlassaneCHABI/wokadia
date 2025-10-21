import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wokadia/feature/auth/login.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/utils/api_service.dart';
import 'package:wokadia/feature/utils/auth_service.dart';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'package:wokadia/feature/widget/dropdown.dart';
import 'package:country_picker/country_picker.dart';
import 'package:wokadia/models/commune.dart';
import 'package:wokadia/models/organisations.dart';
import 'package:wokadia/models/pays.dart';


class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterUIState createState() => new _RegisterUIState();
}

class _RegisterUIState extends State<Register> {
  final TextEditingController _typecompteController = TextEditingController();
  final TextEditingController _organisationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;
  String _email = '', _password = '';
  File? photo;
  String? _selectedCountry;

  DbManager db_manager = DbManager();
  ApiService api_service = ApiService();
  List<Organisations> liste_organsiation = [];
  Organisations? _selectedOrganisation;
  Pays? _selectedPays;
  Commune? _selectedCommune;
  String Organisation_id="";
  int Pays_id=0;
  String Commune_id="";
  String Organisation_name="";
  String Pays_name="";
  String Commune_name="";
  bool _isLoading=false;

  List<Pays> liste_pays = [];
  List<Commune> liste_communes = [];

  PreferenceManager pref_manager = PreferenceManager();




  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        photo = File(picked.path);
      });
      Navigator.pop(context); // ferme le BottomSheet seulement
    }
  }


  void modalBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
            ),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),

            ],
          ),
        );
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    print("Je suis ici");
    super.initState();
    initialise();
    getDbLocalOrganisation();
    getDbLocalPays();
    getDbLocalCommune();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Column(children: [
              SizedBox(height: 30,),
              Center(
                child: AnimatedSpeechBubble(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        "Décline ton identité !",
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
                'assets/images/active_youth_connexion.png',
                width: width * 2,
                height: width * 0.90,
                //fit: BoxFit.cover,
              ),

           Expanded(child: SingleChildScrollView(
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
                       /*TextFormField(
                         controller: _typecompteController,
                         style: const TextStyle(fontSize: 16),
                         decoration: InputDecoration(
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(25.0),
                               borderSide: BorderSide(width:1,color: Vert)
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           hintText: "Animateur",

                           hintStyle: const TextStyle(color: Vert),
                           alignLabelWithHint: false,
                           fillColor: Colors.white,
                           filled: true,

                         ),
                         validator: (value) {
                           if (value?.isEmpty ?? true) {
                             return 'Veuillez entrer votre nom';
                           }
                           return null;
                         },

                         //obscureText: passwordVisible,
                         keyboardType: TextInputType.text,
                         textInputAction: TextInputAction.done,
                       ),*/

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
                             _typecompteController.text=value!;
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
                             borderSide: const BorderSide(color: Vert, width: 1),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
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

                       SizedBox(height: 13,),
                       DropdownButtonFormField<Organisations>(
                        value: _selectedOrganisation,
                         style: const TextStyle(
                           color: Vert,
                           fontWeight: FontWeight.bold,
                         ),
                         hint: const Text(
                           'Organisation',
                           style: TextStyle(
                             color: Vert,
                             fontWeight: FontWeight.w500,
                             //fontSize: 18,
                           ),
                         ),
                         isExpanded: true,
                         onChanged: (Organisations? value) {
                           setState(() {
                             Organisation_name = value!.name;
                             Organisation_id = value!.online_id.toString();

                           });
                         },
                         items: liste_organsiation.map((org) {
                           return DropdownMenuItem<Organisations>(
                             value: org,
                             child: Text(org.name),
                           );
                         }).toList(),
                         /*validator: (value) {
                           if (value == null) {
                             return 'Sélectionnez une organisation';
                           }
                           return null;
                         },*/
                         decoration: InputDecoration(
                           fillColor: Colors.white,
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(color: Vert, width: 1),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           filled: true,
                         ),
                         icon: const Icon(
                           Icons.arrow_drop_down,
                           color: Vert,
                           size: 30,
                         ),
                       ),

                       SizedBox(height: 13,),
                       DropdownButtonFormField<Pays>(
                        value: _selectedPays,
                         style: const TextStyle(
                           color: Vert,
                           fontWeight: FontWeight.bold,
                         ),
                         hint: const Text(
                           'Pays',
                           style: TextStyle(
                             color: Vert,
                             fontWeight: FontWeight.w500,
                             //fontSize: 18,
                           ),
                         ),
                         isExpanded: true,
                         onChanged: (Pays? value) {
                           setState(() {
                             Pays_name = value!.pays_name;
                             Pays_id = value!.online_id;

                             getDbLocalCommunebyPays_id(Pays_id);

                           });
                         },
                         items: liste_pays.map((pay) {
                           return DropdownMenuItem<Pays>(
                             value: pay,
                             child: Text(pay.pays_name),
                           );
                         }).toList(),
                         /*validator: (value) {
                           if (value == null) {
                             return 'Sélectionnez une organisation';
                           }
                           return null;
                         },*/
                         decoration: InputDecoration(
                           fillColor: Colors.white,
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(color: Vert, width: 1),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           filled: true,
                         ),
                         icon: const Icon(
                           Icons.arrow_drop_down,
                           color: Vert,
                           size: 30,
                         ),
                       ),

                       SizedBox(height: 13,),
                       DropdownButtonFormField<Commune>(
                        value: _selectedCommune,
                         style: const TextStyle(
                           color: Vert,
                           fontWeight: FontWeight.bold,
                         ),
                         hint: const Text(
                           'Commune',
                           style: TextStyle(
                             color: Vert,
                             fontWeight: FontWeight.w500,
                             //fontSize: 18,
                           ),
                         ),
                         isExpanded: true,
                         onChanged: (Commune? value) {
                           setState(() {
                             Commune_name = value!.commune_name;
                             Commune_id = value!.online_id.toString();

                           });
                         },
                         items: liste_communes.map((com) {
                           return DropdownMenuItem<Commune>(
                             value: com,
                             child: Text(com.commune_name),
                           );
                         }).toList(),
                         /*validator: (value) {
                           if (value == null) {
                             return 'Sélectionnez une organisation';
                           }
                           return null;
                         },*/
                         decoration: InputDecoration(
                           fillColor: Colors.white,
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(color: Vert, width: 1),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           filled: true,
                         ),
                         icon: const Icon(
                           Icons.arrow_drop_down,
                           color: Vert,
                           size: 30,
                         ),
                       ),

                       SizedBox(height: 13,),
                       TextFormField(
                         controller: _usernameController,
                         style: const TextStyle(fontSize: 16),
                         decoration: InputDecoration(
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(25.0),
                               borderSide: BorderSide(width:1,color: Vert)
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           hintText: "Nom et prénom",

                           hintStyle: const TextStyle(
                            color: Vert,
                            //fontWeight: FontWeight.w500,
                            //fontSize: 18,
                            ),
                           alignLabelWithHint: false,
                           fillColor: Colors.white,
                           filled: true,

                         ),
                         validator: (value) {
                           if (value?.isEmpty ?? true) {
                             return 'Veuillez entrer votre nom et prénom';
                           }
                           return null;
                         },

                         //obscureText: passwordVisible,
                         keyboardType: TextInputType.text,
                         textInputAction: TextInputAction.done,
                       ),
                       SizedBox(height: 13,),
                       TextFormField(
                         controller: _telController,
                         style: const TextStyle(fontSize: 16),
                         decoration: InputDecoration(
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(25.0),
                               borderSide: BorderSide(width:1,color: Vert)
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
                           ),
                           hintText: "Télephone",

                           hintStyle: const TextStyle(color: Vert),
                           alignLabelWithHint: false,
                           fillColor: Colors.white,
                           filled: true,

                         ),
                         validator: (value) {
                           if (value?.isEmpty ?? true) {
                             return 'Veuillez entrer votre téléphone';
                           }
                           return null;
                         },

                         //obscureText: passwordVisible,
                         keyboardType: TextInputType.phone,
                         textInputAction: TextInputAction.done,
                       ),
                       SizedBox(height: 13,),

                       TextFormField(
                         controller: _emailController,
                         style: const TextStyle(fontSize: 16),
                         decoration: InputDecoration(
                           focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(25.0),
                               borderSide: BorderSide(width:1,color: Vert)
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
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
                               borderSide: BorderSide(width:1,color: Vert)
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(width: 1, color: Vert),
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

                       SizedBox(height: 10,),
                      /* SizedBox(
                         width: double.infinity,
                         height: 55,
                         child: ElevatedButton(
                           onPressed: () {
                             modalBottomMenu(context);
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.white,
                             textStyle: const TextStyle(fontSize: 20),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(25),
                               side: BorderSide(
                                 color: Vert,
                                 width: 1,
                               ),
                             ),
                           ),
                           child: Text(
                             'Ajouter une photo',
                             style: TextStyle(
                               //fontSize: width * 0.060,
                               color: Vert,
                             ),
                           ),
                         ),
                       ),


                       const SizedBox(height: 10),

                       // Aperçu de l’image
                       if (photo != null)
                         ClipRRect(
                           borderRadius: BorderRadius.circular(8),
                           child: Image.file(
                             photo!,
                             height: 120,
                             fit: BoxFit.cover,
                           ),
                         ),*/

                       SizedBox(height: 20,),

                       ConstrainedBox(
                         constraints: BoxConstraints(maxWidth: buttonMaxWidth),
                         child: SizedBox(
                           width: double.infinity,
                           height: 55,
                           child: ElevatedButton(
                             onPressed: () {
                               if (_formKey.currentState!.validate()) {registerUserToServer();

                               }
                               else {
                                 displayDialog(context,
                                     "Erreur de validation",
                                     "Veuillez remplir tous les champs",
                                     "error");
                               }

                               /*Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (_) => Login()),
                               );*/
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
                               'Créer compte',
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
                   ),)

                 ),
               ),
             ),
           ))


            ],);
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
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
                    'Créer compte',
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
      ),*/
    );

  }


  getDbLocalOrganisation() async {
    try {
      int? nbr_organsiation = await db_manager.countDbOrganisations();

      if (nbr_organsiation == 0) {
        List<Organisations> cette_liste = [];
        liste_organsiation.clear();
        await db_manager.removeAllDbOrganisations();

        api_service.getApi('organisations').then((value) async {
          List<dynamic> responseData = value['data'];

          if (responseData.isNotEmpty) {
            for (var element in responseData) {
              Organisations ce_item = Organisations.fromJson(element);
              print("Organisation");
              print(ce_item);
              await db_manager.insertDbOrganisation(ce_item);
              cette_liste.add(ce_item);
            }
          }

          setState(() {
            liste_organsiation = cette_liste;
          });
        });
      } else {
        // Charger depuis la DB locale
        var data = await db_manager.getAllDbOrganisations();
        setState(() {
          liste_organsiation = data;
        });
      }
    } catch (e) {
      print("❌ ERROR getDbLocalOrganisation: ${e.toString()}");
    }
  }


  Future<void> initialise() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("type_compte");
      setState(() {
        _typecompteController.text = prefs.getString('type_compte') ?? '';

        print(_typecompteController.text);
      });
    } catch (e) {
      debugPrint("Erreur SharedPreferences: $e");
    }
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




  getDbLocalPays() async {
    /*setState(() {
      _isLoading = true;
    });*/
    int? taille_pays=0;
    try {
      db_manager.countDbPays().then((value) {
        setState(() {
          taille_pays = value;
        });
      });

      print("**********-----Api_service: getDbLocalPays : taille ");
      print(taille_pays);

      if(taille_pays==0)
      {
        db_manager.removeAllDbPays();
        liste_pays.clear();
        List<Pays> cette_liste = [];

        api_service.getApi('pays').then((value) {
          List<dynamic> responseData = value['data'];
          /*print("********** PAYS IN REGISTER");
          print(responseData);*/

          if(!responseData.isEmpty){
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
          });
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




  getDbLocalCommune() async {
    /*setState(() {
      _isLoading = true;
    });*/
    int? taille_commune=0;
    try {
      db_manager.countDbCommunes().then((value) {
        setState(() {
          taille_commune = value;
        });
      });

      print("**********-----Api_service: getDbLocalCommune : taille ");
      print(taille_commune);

      if(taille_commune==0)
      {
        db_manager.removeAllDbCommunes();
        liste_communes.clear();
       // List<Commune> cette_liste = [];

        api_service.getApi('commune').then((value) {
          List<dynamic> responseData = value['data'];
          /*print("********** PAYS IN REGISTER");
          print(responseData);*/

          if(!responseData.isEmpty){
            responseData.forEach((element) {
              Commune ce_item = Commune.fromJson(element);
              db_manager.insertDbCommune(ce_item);
              //cette_liste.add(ce_item) ;
            });
          }
          /*setState(() {
            liste_communes = cette_liste;
            /*print("********** UPDATE PAYS IN REGISTER");
            print(liste_pays.length);*/
          });*/
        });
      }
    } catch (e) {
      print("*********----ERROR getDbLocalCommune-------");
      print(e.toString());
    } finally {
      /*setState(() {
        _isLoading = false;
      });*/
    }
  }



  getDbLocalCommunebyPays_id(int pays_id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      db_manager.getDbCommunesByPaysId(pays_id).then((value) {
        setState(() {
          liste_communes = value; // ✅ ici maintenant c'est bien une List<Commune>
        });
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  registerUserToServer() async {
    showAlertDialog(context,"Création en cours");
    print("Les id");
    print(Pays_id);
    print(Commune_id);
    final data = {
      'organisation_name': Organisation_name,
      'organisation_id':Organisation_id,
      'pays_name': Pays_name,
      'pays_id': Pays_id,
      'commune_name': Commune_name,
      'commune_id': Commune_id,
      'role': _typecompteController.text,
      'name': _usernameController.text,
      'contact': _telController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    print("********** DATA USER TO REGISTER------");
    print(data);
    setState(() {
      _isLoading = true;
    });

    var response = await AuthService().registerUserProfile(data);

    print("****-------RESPONSE REGISTER----");
    print(response);
    setState(() {
      _isLoading = false;
    });

    if (response == "succes") {
      Navigator.of(context).pop();
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Création de compte"),
            content: Text("Votre compte a été créé avec succès!", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) =>  Login()),
                          (route) => false);
                },
                child: const Text('OK'),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(15),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Vert),
                    shadowColor: MaterialStateProperty.all(Vert),
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
    else {
      Navigator.of(context).pop();
      displayDialog(context,
          "Erreur d'enregistrement",
          "${response}",
          "warning");
    }
  }

}
