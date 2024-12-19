import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: const Color(0xFFBFE8FF), // Bleu ciel doux
      selectedItemColor: const Color(0xFFFFA500), // Orange (pour les éléments sélectionnés)
      unselectedItemColor: const Color(0xFF1E90FF), // Bleu océan pour les non-sélectionnés
      selectedIconTheme: const IconThemeData(size: 28), // Icône légèrement plus grande pour l'élément sélectionné
      unselectedIconTheme: const IconThemeData(size: 24), // Icône légèrement plus petite pour les non-sélectionnés
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Acheter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      type: BottomNavigationBarType.fixed, // Conserve une taille fixe
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFFA500), // Harmonisation avec le design
      ),
      unselectedLabelStyle: const TextStyle(
        color: Color(0xFF1E90FF),
      ),
    );
  }
}
