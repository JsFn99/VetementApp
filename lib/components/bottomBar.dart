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
      backgroundColor: Colors.blue[100],
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_bag, color: Colors.blue),
          label: 'Acheter',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.blue),
          label: 'Panier',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.blue),
          label: 'Profil',
        ),
      ],
    );
  }
}