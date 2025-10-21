import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/auth/profil.dart';
import 'package:wokadia/feature/cours/indes.dart';
import 'package:wokadia/feature/historique/index.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/jeux/QuizPageJeu.dart';
import 'package:wokadia/feature/sport/index_sport.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import '../utils/constant.dart';
import '../widget/custombottomnavigation.dart';
import '../../models/game.dart';

class IndexJeu extends StatefulWidget {
  const IndexJeu({super.key});

  @override
  State<IndexJeu> createState() => _IndexJeuState();
}

class _IndexJeuState extends State<IndexJeu> {
  int _selectedIndex = 2;
  PreferenceManager prefManager = PreferenceManager();
  String? name;
  final DbManager dbManager = DbManager();

  Future<void> _loadName() async {
    String? savedName = await prefManager.getPrefItem("name");
    setState(() {
      name = savedName;
    });
  }

  Future<List<Game>> _loadGames() async {
    print("Je suis ici");
    final games = await dbManager.getGames();
    print("🟢 Nombre de jeux chargés : ${games.length}");
    for (var g in games) {
      print("➡️ ${g.id} | ${g.name} | isDone=${g.isDone}");
    }
    return games;
  }


  String getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "";
    List<String> parts = fullName.trim().split(" ");
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Indes()));
        break;
      case 2:
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Historique()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: VertClaire,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.09,
              vertical: height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      height: height * 0.12,
                      child: Image.asset(
                        "assets/images/active_youth.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ComptePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Vert,
                          child: Text(
                            getInitials(name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                  ],
                ),
                SizedBox(height: height * 0.03),
                const Text(
                  "Jeux",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                //const SizedBox(height: 20),

                // === Grille dynamique des jeux ===
                Expanded(
                  child: FutureBuilder<List<Game>>(
                    future: _loadGames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Aucun jeu disponible"));
                      }

                      final games = snapshot.data!;

                      return GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];

                          return buildGameCard(
                            title: game.name,
                            image: game.localIconPath ??
                                game.gameIcon ??
                                "assets/images/jump.png",
                            isLocal: game.localIconPath != null,
                            color: Colors.green.shade100,
                            isDone: game.isDone,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        QuizPageJeux(game: game)),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 30,
            child: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  // === Widget Carte de jeu ===
  Widget buildGameCard({
    required String title,
    required String image,
    required Color color,
    required bool isDone,
    bool isLocal = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: isLocal
                  ? Image.file(File(image), fit: BoxFit.contain)
                  : image.startsWith("http")
                  ? Image.network(image, fit: BoxFit.contain)
                  : Image.asset(image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              title.length > 23 ? '${title.substring(0, 23)}...' : title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10,),
            isDone?
               Text(
                "Terminé ✅",
                style: TextStyle(
                  fontSize: 12,
                  color: Vert,
                  fontWeight: FontWeight.w600,
                ),
              ):SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
