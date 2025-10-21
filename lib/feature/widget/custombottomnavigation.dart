import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/constant.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final List<Map<String, String>> _navItems = const [
    {"label": "Accueil", "icon": "assets/Icone/home.png"},
    {"label": "Cours", "icon": "assets/Icone/cours.png"},
    {"label": "Jeux", "icon": "assets/Icone/jeux.png"},
   // {"label": "Sport", "icon": "assets/Icone/sport.png"},
    {"label": "Historique", "icon": "assets/Icone/historique.png"},
    //{"label": "Chat", "icon": "assets/icones/chat.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),

        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isActive = selectedIndex == index;

          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item["icon"]!,
                  color: isActive ? Vert : Colors.grey,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 5),
                Text(
                  item["label"]!,
                  style: TextStyle(
                    color: isActive ? Vert : Colors.grey,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
