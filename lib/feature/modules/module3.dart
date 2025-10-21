import 'package:flutter/material.dart';
import 'package:wokadia/feature/modules/index1.dart';
import 'package:wokadia/feature/utils/constant.dart';


class Module3 extends StatefulWidget {
  const Module3({super.key});

  @override
  State<Module3> createState() => _indexState();
}

class _indexState extends State<Module3> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              Text(
                "Programme sportif et \n bien-être",
                style: TextStyle(
                  color: Vert,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Vert,
                  decorationThickness: 1,
                ),
              ),
              const SizedBox(height: 20),

              // Cartes de modules
              buildModuleCard(
                color: Colors.green.shade50,
                title: "Cardio et \n endurance",
                icon: Icons.menu_book,
              ),
              const SizedBox(height: 15),
              buildModuleCard(
                color: Colors.yellow.shade50,
                title: "Renforcement\nmusculaire et\n posture ",
                icon: Icons.warning_amber_rounded,
              ),
              const SizedBox(height: 15),
              buildModuleCard(
                color: Colors.blue.shade50,
                title: "Yoga et \n souplesse",
                icon: Icons.public,
              ),
              const SizedBox(height: 15),
              buildModuleCard(
                color: Colors.teal.shade50,
                title: "Cardio +\n Renforcement",
                icon: Icons.forest,
              ),

              const Spacer(),

              // Bouton Suivant
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Vert,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => index1()),
                    );
                  },
                  child: const Text(
                    "Suivant",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  // Widget réutilisable pour les cartes
  Widget buildModuleCard({
    required Color color,
    required String title,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            icon,
            size: 40,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
