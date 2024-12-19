import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../components/bottomBar.dart';
import '../login/login.dart';
import '../cart/cart.dart';
import '../profil/profil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = "Loading...";
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Firebase Realtime Database reference
  final databaseRef = FirebaseDatabase.instance.ref('clothes');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Magasin de vêtements",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E90FF), // Bleu océan
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          const CartScreen(fromDetails: false),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Clothes List from Firebase
          Expanded(
            child: StreamBuilder(
              stream: databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Erreur lors du chargement des vêtements."));
                }
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text("Aucun vêtement disponible."));
                }

                // Convert Firebase data into List
                final clothesMap = snapshot.data!.snapshot.value as Map<Object?, Object?>;
                final clothesList = clothesMap.values.toList();

                return ListView.builder(
                  itemCount: clothesList.length,
                  itemBuilder: (context, index) {
                    final item = clothesList[index] as Map;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Coins arrondis
                      ),
                      color: const Color(0xFFFFFFFF), // Fond blanc
                      elevation: 4, // Ombre douce
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8), // Coins arrondis des images
                          child: Image.network(
                            item['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C), // Noir doux
                          ),
                        ),
                        subtitle: Text(
                          "Taille: ${item['size']}\nPrix: \$${item['price']}",
                          style: const TextStyle(
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: {
                              'title': item['title'],
                              'category': item['category'],
                              'size': item['size'],
                              'brand': item['brand'],
                              'price': item['price'],
                              'imageUrl': item['imageUrl'],
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
