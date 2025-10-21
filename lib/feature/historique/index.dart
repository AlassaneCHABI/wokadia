import 'package:flutter/material.dart';
import 'package:wokadia/feature/auth/profil.dart';
import 'package:wokadia/feature/cours/indes.dart';
import 'package:wokadia/feature/home/home.dart';
import 'package:wokadia/feature/jeux/index_jeu.dart';
import 'package:wokadia/feature/utils/db_manager.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/models/historique_programme.dart';
import 'package:wokadia/models/historique_module.dart';
import 'package:wokadia/models/users.dart';
import '../utils/constant.dart';
import '../widget/custombottomnavigation.dart';


class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  int _selectedIndex = 3;
  PreferenceManager prefManager = PreferenceManager();
  String? name;
  final DbManager dbManager = DbManager();

  List<ProgrammeData> _programmeList = [];
  List<ModuleData> _moduleList = [];
  bool _isLoading = true;
  bool showEE = true;

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadProgrammeData();
    _loadModuleData();
  }

  Future<void> _loadName() async {
    String? savedName = await prefManager.getPrefItem("name");
    setState(() => name = savedName);
  }

  Future<void> _loadProgrammeData() async {
    final data = await dbManager.getAllProgrammeData();
    setState(() {
      _programmeList = data;
      _isLoading = false;
    });
  }

  Future<void> _loadModuleData() async {
    final data = await dbManager.getAllModelData();
    setState(() {
      _moduleList = data;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const IndexJeu()));
        break;
      case 3:
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ComptePage()));*/
        break;
    }
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

  Widget buildHistoryCard(ProgrammeData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Vert,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lieu / Village",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data.centre}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  "Date de formation",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                Text(
                  "${data.date}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Programme",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),

                Text(
                  data.programmeName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),

                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Durée",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    /*Text(
                      "Score",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),*/
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.temps_total!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryModulCard(ModuleData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.userName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Vert,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lieu / Village",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data.centre}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date de formation",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                Text(
                  "${data.date}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Module",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Text(
                  data.moduleName!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),

                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Durée",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Score",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     data.temps_total!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "${data.score}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: VertClaire,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.09,
              vertical: size.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.12,
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                const Text(
                  "Historique / Listes des élèves formés",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // ===== Carte nombre =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nombre total de personnes formées",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${_programmeList.fold<int>(0, (sum, item) => sum + item.nombreTotalEleve) + _moduleList.fold<int>(0, (sum, item) => sum + item.nombreTotalEleve)}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showEE = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: showEE ? Vert : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "EE / LPS",
                          textAlign: TextAlign.center, // 🔑 pour centrer sur 2 lignes
                          style: TextStyle(
                            color: showEE ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showEE = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !showEE ? Vert : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "PROGRAMME\n SPORTIF ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !showEE ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 20,),

                // ===== Liste dynamique =====
                !showEE? Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _programmeList.isEmpty
                      ? const Center(
                    child: Text(
                      "Aucune donnée trouvée",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                      : ListView.separated(
                    itemCount: _programmeList.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return buildHistoryCard(_programmeList[index]);
                    },
                    padding: const EdgeInsets.only(bottom: 100),
                  ),
                ):
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _moduleList.isEmpty
                      ? const Center(
                    child: Text(
                      "Aucune donnée trouvée",
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                      : ListView.separated(
                    itemCount: _moduleList.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return buildHistoryModulCard(_moduleList[index]);
                    },
                    padding: const EdgeInsets.only(bottom: 100),
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
}
