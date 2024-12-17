import 'package:flutter/material.dart';
import '../login/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = "Loading...";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  void _fetchUserEmail() {
    setState(() {
      userEmail = "user@example.com";
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle different screens or actions based on the selected index
    if (index == 0) {
      // Navigate to 'Acheter' screen
    } else if (index == 1) {
      // Navigate to 'Panier' screen
    } else if (index == 2) {
      // Navigate to 'Profil' screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Magasin de vêtements",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2661FA),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue dans notre application de vente de vêtements !",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ici, vous pouvez acheter des vêtements de qualité.",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
        backgroundColor: const Color(0xFF2661FA),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, color: Colors.blue),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.blue),
            label: 'Panier',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}