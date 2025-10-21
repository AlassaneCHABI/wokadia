import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/widget/animation.dart';
import 'package:wokadia/models/eleve.dart';
import 'package:wokadia/models/users.dart';
import 'dart:io';

import '../modules/index.dart';
import '../utils/constant.dart';

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key});

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  List<Map<String, dynamic>> eleves = [];
  DbManager db_manager = DbManager();
  late User user;

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

  @override
  void initState() {
    super.initState();
    _loadElevesFromDb();
    _getLocalUser();
  }

  // 🔹 Charger les élèves déjà enregistrés
  Future<void> _loadElevesFromDb() async {
    List<Eleve> savedEleves = await db_manager.getAllEleves();
    setState(() {
      eleves = savedEleves.map((e) => e.toJson()).toList();
    });
  }

  void _showAddDialog() {
    final TextEditingController nomCtrl = TextEditingController();
    final TextEditingController centreCtrl = TextEditingController();
    final TextEditingController villeCtrl = TextEditingController();
    final TextEditingController ecoleCtrl = TextEditingController();
    final TextEditingController classeCtrl = TextEditingController();
    String sexeSelectionne = "";
    File? photo;

    final _formKey = GlobalKey<FormState>();
    final picker = ImagePicker();

    Future<void> _pickImage(ImageSource source, void Function(void Function()) setStateDialog) async {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        setStateDialog(() {
          photo = File(picked.path);
        });
        Navigator.pop(context); // ferme le BottomSheet seulement
      }
    }

    void modalBottomMenu(BuildContext context, setStateDialog) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => _pickImage(ImageSource.camera, setStateDialog),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () => _pickImage(ImageSource.gallery, setStateDialog),
                ),
              ],
            ),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(16),
              scrollable: true,
              title: const Text(
                "Ajouter \nun élève",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  height: 1,
                  decorationThickness: 1,
                ),
              ),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: centreCtrl,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Village / Lieu",
                            hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: nomCtrl,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Noms et prénom",
                            hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hint: const Text(
                              'Sexe',
                              style: TextStyle(
                                color: Vert,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            //hintText: "Sexe",
                            //hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          //value: sexeSelectionne,
                          items: ['Masculin', 'Feminin']
                              .map((sexe) => DropdownMenuItem(
                            value: sexe,
                            child: Text(sexe),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              sexeSelectionne = value!;
                            });

                              print(sexeSelectionne);

                          },
                          validator: (value) => value == null ? 'Veuillez sélectionner un sexe' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: villeCtrl,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Ville",
                            hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: ecoleCtrl,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "École",
                            hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: classeCtrl,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Classe",
                            hintStyle: const TextStyle(color: Vert),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(width: 1, color: Vert),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 15),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 250),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => modalBottomMenu(context, setStateDialog),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(color: Vert, width: 1),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                'Ajouter une photo',
                                style: TextStyle(color: Vert),
                              ),)
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (photo != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              photo!,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VertClaire,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Annuler",
                          style: TextStyle(
                            color: Vert,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // espace entre les deux
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Vert,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() && photo != null) {
                            setState(() {
                              eleves.add({
                                "nom": nomCtrl.text.trim(),
                                "ville": villeCtrl.text.trim(),
                                "ecole": ecoleCtrl.text.trim(),
                                "classe": classeCtrl.text.trim(),
                                "photo": photo!.path,
                                "centre": centreCtrl.text.trim(),
                                "sexe": sexeSelectionne,
                              });
                            });
                            Navigator.pop(context);
                          } else if (photo == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Veuillez sélectionner une photo")),
                            );
                          }
                        },
                        child: const Text(
                          "Valider",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final double buttonMaxWidth = 400;

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),*/
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.01,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: AnimatedSpeechBubble(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        "Décline l'identité de\n l'élève ou des élèves !",
                        textStyle: const TextStyle(fontSize: 15),
                        speed: const Duration(milliseconds: 99),
                      ),
                    ],
                  ),
                ),
              ),

              Image.asset(
                'assets/images/active_youth_connexion.png',
                width: width * 2,
                height: width * 0.50,
                //fit: BoxFit.cover,
              ),

              SizedBox(
                height: 300,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Vert, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "N°",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Vert, fontSize: 20),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Noms et prénoms",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Vert, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Vert, thickness: 2),
                      Expanded(
                        child: ListView.builder(
                          itemCount: eleves.length,
                          itemBuilder: (context, index) {
                            final e = eleves[index];
                            return ListTile(
                              leading: Text(("0" + (index + 1).toString()), style: const TextStyle(fontSize: 17)),
                              title: Text(e["nom"], style: const TextStyle(fontSize: 17)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    eleves.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: _showAddDialog,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Vertneutre,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "+ Ajouter",
                              style: TextStyle(color: Vert, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: height * 0.05, left: width * 0.09, right: width * 0.09),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: buttonMaxWidth),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () async {
                if (eleves.isNotEmpty) {
                  for (var e in eleves) {
                    e['user_id'] = user.online_id;
                    Eleve eleve = Eleve.fromJson(e);
                    await db_manager.insertEleve(eleve);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => index()));
                } else {
                  displayDialog(context, "Erreur d'enregistrement", "Veuillez ajouter au moins un élève", "warning");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Vert,
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Enregistrer',
                style: TextStyle(fontSize: width * 0.060, color: Colors.white,fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
