import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wokadia/feature/auth/profil.dart';
import 'package:wokadia/feature/cours/indes.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/jeux/QuizPageJeu.dart';
import 'package:wokadia/feature/jeux/index_jeu.dart';
import 'package:wokadia/feature/sport/cardiopage.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/models/programme.dart';
import '../utils/constant.dart';
import '../widget/custombottomnavigation.dart';
import '../../models/game.dart';

class IndexSport extends StatefulWidget {
  const IndexSport({super.key});

  @override
  State<IndexSport> createState() => _IndexSportState();
}

class _IndexSportState extends State<IndexSport> {
  int _selectedIndex = 3;
  PreferenceManager prefManager = PreferenceManager();
  String? name;
  final DbManager dbManager = DbManager();

  Future<void> _loadName() async {
    String? savedName = await prefManager.getPrefItem("name");
    setState(() {
      name = savedName;
    });
  }

  Future<List<Programme>> _loadGames() async {
    return await dbManager.getAllProgrammes();
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IndexJeu()),
        );
        break;
      case 3:
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
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Youth",
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Vert,
                        decoration: TextDecoration.underline,
                        decorationColor: Vert,
                        decorationThickness: 2,
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
                  "Programme sportif",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
               // const SizedBox(height: 20),

                // === Grille dynamique des jeux ===
                Expanded(
                  child: FutureBuilder<List<Programme>>(
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
                        ),
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];

                          return buildGameCard(
                            title: game.name,
                            image: game.programmeIcon ??
                                "assets/images/jump.png",
                            isLocal: game.programmeIcon != null,
                            color: Colors.green.shade100,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        CardioPage(programme: game)),
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
        padding: const EdgeInsets.all(16),
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
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
